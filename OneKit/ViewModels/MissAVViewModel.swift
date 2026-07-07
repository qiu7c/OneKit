import SwiftUI
import WebKit
import OSLog

// MARK: - 状态
enum MissAVState: Equatable {
    case idle
    case searching
    case loaded(count: Int)
    case extracting
    case error(String)

    var description: String {
        switch self {
        case .idle: return ""
        case .searching: return "搜索中..."
        case .loaded(let c): return "找到 \(c) 个视频"
        case .extracting: return "解析视频地址..."
        case .error(let e): return e
        }
    }
}

// MARK: - WKWebView 抓取引擎 + ViewModel
@MainActor
final class MissAVViewModel: NSObject, ObservableObject {
    // MARK: 单例（WKWebView 全局复用）
    static let shared = MissAVViewModel()

    @Published var state: MissAVState = .idle
    @Published var videos: [MissAVMedia] = []
    @Published var searchText = ""
    @Published var selectedVideo: MissAVMedia?

    internal var webView: WKWebView?
    private let baseURL = "https://missav.ai"

    // Continuations for async/await bridging
    private var searchContinuation: CheckedContinuation<[MissAVMedia], Error>?
    private var m3u8Continuation: CheckedContinuation<String, Error>?

    // JS 消息处理
    private enum MessageName: String, CaseIterable {
        case videoList = "missavVideoList"
        case m3u8Detected = "missavM3U8"
        case log = "missavLog"
    }

    override private init() {
        super.init()
        setupWebView()
    }

    // MARK: - WebView 初始化
    private func setupWebView() {
        let config = WKWebViewConfiguration()
        let controller = config.userContentController

        // 注册所有 JS 消息处理器
        for name in MessageName.allCases {
            controller.add(self, name: name.rawValue)
        }

        // 预注入拦截脚本（注入所有页面）
        let interceptionScript = WKUserScript(
            source: Self.m3u8InterceptionJS,
            injectionTime: .atDocumentStart,
            forMainFrameOnly: false
        )
        controller.addUserScript(interceptionScript)

        webView = WKWebView(frame: .zero, configuration: config)
        webView?.navigationDelegate = self

        // 设置自定义 UA
        webView?.customUserAgent = "Mozilla/5.0 (iPhone; CPU iPhone OS 18_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.0 Mobile/15E148 Safari/604.1"
    }

    /// 将 WKWebView 挂到窗口层级（必须这样才能渲染和执行 JS）
    func attachToWindow() {
        guard let webView = webView, webView.superview == nil else { return }
        webView.isHidden = false
        webView.alpha = 0.01
        webView.frame = CGRect(x: 0, y: 0, width: 320, height: 480)
        if let window = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first?.windows.first {
            window.addSubview(webView)
        }
    }

    /// 从窗口层级移除
    func detachFromWindow() {
        webView?.removeFromSuperview()
    }
}

// MARK: - 公开 API
extension MissAVViewModel {
    /// 搜索视频
    func search(query: String) async throws -> [MissAVMedia] {
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else { return [] }

        await MainActor.run { self.state = .searching }
        ensureWebView()

        return try await withCheckedThrowingContinuation { continuation in
            self.searchContinuation = continuation

            let encoded = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
            let urlStr = "\(baseURL)/cn/search/\(encoded)"
            guard let url = URL(string: urlStr) else {
                continuation.resume(throwing: MissAVError.invalidURL)
                return
            }
            os_log(.debug, "MissAV 搜索: %@", urlStr)
            webView?.load(URLRequest(url: url))
        }
    }

    /// 提取视频的 m3u8 地址
    func extractM3U8(for video: MissAVMedia) async throws -> String {
        await MainActor.run { self.state = .extracting; self.selectedVideo = video }
        ensureWebView()

        return try await withCheckedThrowingContinuation { continuation in
            self.m3u8Continuation = continuation

            guard let url = URL(string: video.detailURL) else {
                continuation.resume(throwing: MissAVError.invalidURL)
                return
            }
            os_log(.debug, "MissAV 提取 m3u8: %@", video.detailURL)
            webView?.load(URLRequest(url: url))
        }
    }
}

// MARK: - WKNavigationDelegate
extension MissAVViewModel: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        guard webView.url?.absoluteString != nil else { return }

        if searchContinuation != nil {
            // 搜索页加载完成 → 注入抓取脚本
            let scrapeJS = Self.buildScrapeJS(baseURL: baseURL)
            webView.evaluateJavaScript(scrapeJS) { _, error in
                if let error = error {
                    os_log(.error, "注入抓取JS失败: %@", error.localizedDescription)
                }
            }
            // 兜底：5秒后还没收到消息就报错
            DispatchQueue.main.asyncAfter(deadline: .now() + 8) { [weak self] in
                guard let self = self, let cont = self.searchContinuation else { return }
                self.searchContinuation = nil
                cont.resume(throwing: MissAVError.timeout)
            }
        }

        if m3u8Continuation != nil {
            // 详情页加载完成 → 注入提取脚本 + 模拟交互
            let extractJS = Self.extractM3U8JS
            webView.evaluateJavaScript(extractJS) { _, error in
                if let error = error {
                    os_log(.error, "注入m3u8提取JS失败: %@", error.localizedDescription)
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 12) { [weak self] in
                guard let self = self, let cont = self.m3u8Continuation else { return }
                self.m3u8Continuation = nil
                cont.resume(throwing: MissAVError.m3u8NotFound)
            }
        }
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        failPending(reason: error.localizedDescription)
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        failPending(reason: error.localizedDescription)
    }

    private func failPending(reason: String) {
        let err = MissAVError.networkError(reason)
        searchContinuation?.resume(throwing: err)
        searchContinuation = nil
        m3u8Continuation?.resume(throwing: err)
        m3u8Continuation = nil
    }
}

// MARK: - WKScriptMessageHandler
extension MissAVViewModel: WKScriptMessageHandler {
    func userContentController(_ controller: WKUserContentController, didReceive message: WKScriptMessage) {
        guard let name = MessageName(rawValue: message.name) else { return }

        switch name {
        case .log:
            os_log(.debug, "[MissAV JS] %@", "\(message.body)")

        case .videoList:
            guard let cont = searchContinuation else { return }
            searchContinuation = nil

            do {
                guard let jsonString = message.body as? String,
                      let data = jsonString.data(using: .utf8)
                else {
                    cont.resume(throwing: MissAVError.parseError)
                    return
                }
                let result = try JSONDecoder().decode(MissAVSearchResult.self, from: data)
                let videos = result.items.map { item -> MissAVMedia in
                    let code = Self.extractCode(from: item.detailURL) ?? "UNKNOWN"
                    let tag = Self.classify(url: item.detailURL, title: item.title, tags: item.tags)
                    return MissAVMedia(
                        id: code,
                        title: item.title,
                        coverURL: item.coverURL,
                        detailURL: item.detailURL,
                        tag: tag
                    )
                }
                cont.resume(returning: videos)
            } catch {
                cont.resume(throwing: MissAVError.parseError)
            }

        case .m3u8Detected:
            guard let cont = m3u8Continuation else { return }
            m3u8Continuation = nil

            let url = "\(message.body)"
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .replacingOccurrences(of: "\"", with: "")

            guard !url.isEmpty, url.contains(".m3u8") else {
                cont.resume(throwing: MissAVError.m3u8NotFound)
                return
            }
            cont.resume(returning: url)
        }
    }
}

// MARK: - JavaScript 脚本
extension MissAVViewModel {
    /// 拦截 m3u8 请求（在页面加载前注入）
    private static let m3u8InterceptionJS = """
    (() => {
        if (window.__missavInterceptorInstalled) return;
        window.__missavInterceptorInstalled = true;

        // 拦截 fetch
        const origFetch = window.fetch;
        window.fetch = function(...args) {
            const url = (typeof args[0] === 'string' ? args[0] : args[0]?.url || '');
            if (url.includes('.m3u8') || url.includes('playlist.m3u8')) {
                window.webkit.messageHandlers.missavM3U8.postMessage(url);
            }
            return origFetch.apply(this, args);
        };

        // 拦截 XMLHttpRequest
        const origOpen = XMLHttpRequest.prototype.open;
        XMLHttpRequest.prototype.open = function(...args) {
            const url = args[1] || '';
            if (typeof url === 'string' && (url.includes('.m3u8') || url.includes('playlist.m3u8'))) {
                window.webkit.messageHandlers.missavM3U8.postMessage(url);
            }
            return origOpen.apply(this, args);
        };
    })();
    """

    /// 构建列表页抓取 JS（根据页面结构动态适配）
    private static func buildScrapeJS(baseURL: String) -> String {
        return """
        (() => {
            setTimeout(() => {
                try {
                    const results = [];
                    // 策略1: div.grid a（原项目选择器）
                    const links = document.querySelectorAll('div.grid a');
                    if (links.length > 0) {
                        links.forEach(a => {
                            const img = a.querySelector('img');
                            const title = img?.getAttribute('alt') || a.textContent.trim();
                            const cover = img?.getAttribute('data-src') || img?.src || '';
                            const href = a.href.startsWith('http') ? a.href : '\(baseURL)' + a.href;
                            // 提取标签
                            const badges = Array.from(a.querySelectorAll('.badge, [class*="badge"], tag, [class*="tag"], span:not([class])"))
                                .map(b => b.textContent.trim()).filter(Boolean);
                            if (title && href) {
                                results.push({
                                    title: title.trim(),
                                    coverURL: cover,
                                    detailURL: href,
                                    tags: badges
                                });
                            }
                        });
                    }
                    // 策略2: thumbnail/card 布局
                    if (results.length === 0) {
                        document.querySelectorAll('[class*="thumbnail"] a, [class*="card"] a, article a').forEach(a => {
                            const img = a.querySelector('img');
                            const title = img?.getAttribute('alt') || a.querySelector('[class*="title"]')?.textContent || a.textContent.trim();
                            const cover = img?.getAttribute('data-src') || img?.src || '';
                            const href = a.href.startsWith('http') ? a.href : '\(baseURL)' + a.href;
                            const badges = Array.from(a.querySelectorAll('[class*="badge"], [class*="tag"]'))
                                .map(b => b.textContent.trim()).filter(Boolean);
                            if (title && href) results.push({ title: title.trim(), coverURL: cover, detailURL: href, tags: badges });
                        });
                    }
                    // 去重
                    const seen = new Set();
                    const unique = results.filter(r => {
                        const key = r.title + r.detailURL;
                        if (seen.has(key)) return false;
                        seen.add(key);
                        return true;
                    });
                    window.webkit.messageHandlers.missavVideoList.postMessage(JSON.stringify({ items: unique }));
                    window.webkit.messageHandlers.missavLog.postMessage('MissAV: scraped ' + unique.length + ' items');
                } catch(e) {
                    window.webkit.messageHandlers.missavLog.postMessage('MissAV error: ' + e.message);
                }
            }, 2500);
        })();
        """
    }

    /// 详情页 m3u8 提取 + 模拟播放
    private static let extractM3U8JS = """
    (() => {
        // 方法1: 从 video source 直接读取
        const video = document.querySelector('video source[src*=".m3u8"], video[src*=".m3u8"]');
        if (video) {
            const src = video.src || video.getAttribute('src');
            if (src) {
                window.webkit.messageHandlers.missavM3U8.postMessage(src);
                return;
            }
        }

        // 方法2: 查找 script 中嵌入的 m3u8
        const scripts = document.querySelectorAll('script');
        for (const s of scripts) {
            const text = s.textContent || '';
            const m3u8Regex = /https?://[^"']+\\\\.m3u8[^"']*/g;
            const match = m3u8Regex.exec(text);
            if (match) {
                window.webkit.messageHandlers.missavM3U8.postMessage(match[0]);
                return;
            }
        }

        // 方法3: 点击播放器触发网络请求（然后被拦截脚本捕获）
        const player = document.querySelector('.plyr, video, [class*="player"], [class*="video"]');
        if (player) {
            player.click();
            // 再点一次封面/中央播放按钮
            setTimeout(() => {
                const playBtn = document.querySelector('[class*="play"], [class*="start"], .plyr__control');
                if (playBtn) playBtn.click();
            }, 1000);
        }

        // 方法4: 查找 data 属性中的 m3u8
        document.querySelectorAll('[data-url*=".m3u8"], [data-src*=".m3u8"], [data-href*=".m3u8"]').forEach(el => {
            const val = el.getAttribute('data-url') || el.getAttribute('data-src') || el.getAttribute('data-href') || '';
            if (val) window.webkit.messageHandlers.missavM3U8.postMessage(val);
        });
    })();
    """
}

// MARK: - 工具方法
extension MissAVViewModel {
    /// 从 URL 提取番号
    static func extractCode(from url: String) -> String? {
        // /cn/MIDV-XXX 或 /cn/abc/MIDV-XXX
        let pattern = "[a-zA-Z]+-\\d+"
        if let range = url.range(of: pattern, options: .regularExpression) {
            return String(url[range]).uppercased()
        }
        return nil
    }

    /// 分类标签（与原项目一致）
    static func classify(url: String, title: String, tags: [String]) -> MissAVTag {
        let urlLower = url.lowercased()
        let titleLower = title.lowercased()
        let allTags = tags.map { $0.lowercased() }

        let isUncensored = urlLower.contains("uncensored") || urlLower.contains("leak")
            || titleLower.contains("无码")
            || allTags.contains(where: { $0.contains("无码") || $0.contains("uncensored") })

        let isChinese = (urlLower.contains("chinese") || titleLower.contains("中文字幕")
            || allTags.contains(where: { $0.contains("中文") || $0 == "chinese" }))
            && !isUncensored

        let isEnglish = urlLower.contains("english") || titleLower.contains("英文字幕")
            || allTags.contains(where: { $0.contains("英文") || $0 == "english" || $0 == "english subtitle" })

        if isChinese { return .chinese }
        if isEnglish { return .english }
        if isUncensored { return .uncensored }
        return .normal
    }
}

// MARK: - 错误
enum MissAVError: LocalizedError {
    case invalidURL
    case parseError
    case timeout
    case m3u8NotFound
    case networkError(String)

    var errorDescription: String? {
        switch self {
        case .invalidURL: return "无效的 URL"
        case .parseError: return "解析失败"
        case .timeout: return "请求超时"
        case .m3u8NotFound: return "未找到视频流地址"
        case .networkError(let e): return "网络错误: \(e)"
        }
    }
}
