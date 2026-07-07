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
    static let shared = MissAVViewModel()

    @Published var state: MissAVState = .idle
    @Published var videos: [MissAVMedia] = []
    @Published var searchText = ""
    @Published var selectedVideo: MissAVMedia?
    @Published var debugLog: [String] = []

    internal var webView: WKWebView?
    private let baseURL = "https://missav.ai"
    private var isSearching = false

    private var searchContinuation: CheckedContinuation<[MissAVMedia], Error>?
    private var m3u8Continuation: CheckedContinuation<String, Error>?

    private enum MessageName: String, CaseIterable {
        case videoList = "missavVideoList"
        case m3u8Detected = "missavM3U8"
        case log = "missavLog"
    }

    override private init() {
        super.init()
        log("🔧 ViewModel 初始化")
    }

    // MARK: - 调试日志
    private func log(_ msg: String) {
        os_log(.debug, "[MissAV VM] %@", msg)
        Task { @MainActor in
            self.debugLog.append("[\(dateStr())] \(msg)")
            if self.debugLog.count > 100 { self.debugLog.removeFirst(50) }
        }
    }
    private func dateStr() -> String {
        let f = DateFormatter(); f.dateFormat = "HH:mm:ss.SSS"; return f.string(from: Date())
    }

    // MARK: - WebView 初始化
    private func setupWebView() {
        log("🔧 setupWebView()")
        let config = WKWebViewConfiguration()
        let controller = config.userContentController

        for name in MessageName.allCases {
            controller.add(self, name: name.rawValue)
        }

        // Enable JS
        config.preferences.javaScriptEnabled = true

        // 拦截 m3u8 请求（页面最早阶段注入）
        let interceptionScript = WKUserScript(
            source: Self.m3u8InterceptionJS,
            injectionTime: .atDocumentStart,
            forMainFrameOnly: false
        )
        controller.addUserScript(interceptionScript)

        // 自动点击播放器（DOM 就绪后自动执行，无需 evaluateJavaScript）
        let autoClickScript = WKUserScript(
            source: Self.autoClickJS,
            injectionTime: .atDocumentEnd,
            forMainFrameOnly: false
        )
        controller.addUserScript(autoClickScript)

        webView = WKWebView(frame: .zero, configuration: config)
        webView?.navigationDelegate = self
        webView?.customUserAgent = "Mozilla/5.0 (iPhone; CPU iPhone OS 18_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.0 Mobile/15E148 Safari/604.1"
        log("✅ WKWebView 创建完成")
    }

    func ensureWebView() {
        if webView == nil { setupWebView() }
    }

    func attachToWindow() {
        guard let webView = webView else { log("⚠️ attachToWindow: webView 为 nil"); return }
        guard webView.superview == nil else { log("⏭️ attachToWindow: 已在窗口层级中"); return }
        webView.isHidden = false
        webView.alpha = 0.02
        webView.isUserInteractionEnabled = false  // 不拦截触摸事件
        webView.frame = CGRect(x: 0, y: 0, width: 320, height: 480)
        if let window = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first?.windows.first {
            window.addSubview(webView)
            log("✅ WKWebView 已挂载到窗口")
        } else {
            log("❌ 找不到 UIWindow，无法挂载 WKWebView")
        }
    }

    func detachFromWindow() {
        webView?.removeFromSuperview()
        log("👋 WKWebView 从窗口移除")
    }
}

// MARK: - 公开 API
extension MissAVViewModel {
    func search(query: String) async throws -> [MissAVMedia] {
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else { return [] }
        // 防重入：正在搜索时忽略新请求
        if isSearching { throw MissAVError.searchInProgress }
        isSearching = true
        defer { isSearching = false }

        await MainActor.run { self.state = .searching }
        if webView == nil { log("⚠️ search: webView 为 nil，重新创建"); setupWebView() }
        attachToWindow()

        return try await withCheckedThrowingContinuation { continuation in
            // 清除旧 continuation 和导航
            self.searchContinuation?.resume(throwing: MissAVError.cancelled)
            self.searchContinuation = nil
            webView?.stopLoading()

            self.searchContinuation = continuation

            let encoded = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
            let urlStr = "\(baseURL)/cn/search/\(encoded)"
            guard let url = URL(string: urlStr) else {
                log("❌ 无效 URL: \(urlStr)")
                continuation.resume(throwing: MissAVError.invalidURL)
                return
            }
            log("🔍 搜索: \(urlStr)")
            let req = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 30)
            webView?.load(req)

            DispatchQueue.main.asyncAfter(deadline: .now() + 15) { [weak self] in
                guard let self = self, let cont = self.searchContinuation else { return }
                self.searchContinuation = nil
                self.log("⏰ 搜索超时 15s")
                self.dumpPageState()
                cont.resume(throwing: MissAVError.timeout)
            }
        }
    }

    func extractM3U8(for video: MissAVMedia) async throws -> String {
        await MainActor.run { self.state = .extracting; self.selectedVideo = video }
        if webView == nil { log("⚠️ extractM3U8: webView 为 nil，重新创建"); setupWebView() }
        attachToWindow()

        return try await withCheckedThrowingContinuation { continuation in
            // 清除旧的
            self.m3u8Continuation?.resume(throwing: MissAVError.cancelled)
            self.m3u8Continuation = nil
            webView?.stopLoading()

            self.m3u8Continuation = continuation

            guard let url = URL(string: video.detailURL) else {
                log("❌ 无效详情 URL: \(video.detailURL)")
                continuation.resume(throwing: MissAVError.invalidURL)
                return
            }
            log("🎬 提取 m3u8: \(video.detailURL)")
            webView?.load(URLRequest(url: url))

            DispatchQueue.main.asyncAfter(deadline: .now() + 25) { [weak self] in
                guard let self = self, let cont = self.m3u8Continuation else { return }
                self.m3u8Continuation = nil
                self.log("⏰ m3u8 提取超时 25s")
                self.dumpPageState()
                cont.resume(throwing: MissAVError.m3u8NotFound)
            }
        }
    }

    private func dumpPageState() {
        webView?.evaluateJavaScript("JSON.stringify({ url: location.href, title: document.title, bodyLen: document.body?.innerHTML?.length || 0, hasGrid: !!document.querySelector('div.grid'), snapshot: document.body?.innerText?.substring(0, 500) || '' })") { result, error in
            if let error = error {
                self.log("📄 dumpPageState 错误: \(error.localizedDescription)")
            } else if let json = result as? String {
                self.log("📄 页面状态: \(json)")
            }
        }
    }
}

// MARK: - WKNavigationDelegate
extension MissAVViewModel: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        log("🌐 开始加载: \(webView.url?.absoluteString ?? "nil")")
    }

    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        log("📥 didCommit: \(webView.url?.absoluteString ?? "nil")")
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let urlStr = webView.url?.absoluteString ?? "nil"
        let title = webView.title ?? "nil"
        log("✅ didFinish: \(urlStr) | 标题: \(title)")

        // 诊断：dump 页面内容
        dumpPageState()

        if searchContinuation != nil {
            if urlStr.contains("/search/") {
                // 搜索页 → 注入抓取 JS
                log("📋 搜索页，注入抓取 JS")
                let scrapeJS = Self.buildScrapeJS(baseURL: baseURL)
                webView.evaluateJavaScript(scrapeJS) { _, error in
                    if let error = error {
                        self.log("❌ 注入抓取 JS 失败: \(error.localizedDescription)")
                    } else {
                        self.log("✅ 抓取 JS 注入成功，等待 2.5s 后提取数据")
                    }
                }
            } else if let code = Self.extractCode(from: urlStr) {
                // 搜索跳转到了详情页 → 当作 1 个搜索结果
                log("📋 搜索跳转到详情页: \(code)")
                // 从页面提取封面和标题
                let singleJS = """
                (() => {
                    setTimeout(function() {
                        try {
                            var img = document.querySelector('video') || document.querySelector('img[alt]');
                            var title = document.title.replace(/[\\\\-] MissAV.*/, '').trim() || '\(code)';
                            var cover = '';
                            var el = document.querySelector('meta[property=\\"og:image\\"]');
                            if (el) cover = el.content;
                            if (!cover) {
                                var imgs = document.querySelectorAll('img');
                                for (var i = 0; i < imgs.length; i++) {
                                    var s = imgs[i].src || '';
                                    if (s.indexOf('missav') !== -1 && s.indexOf('cover') !== -1) { cover = s; break; }
                                }
                            }
                            window.webkit.messageHandlers.missavVideoList.postMessage(JSON.stringify({ items: [{ title: title, coverURL: cover || '', detailURL: location.href, tags: [''] }] }));
                        } catch(e) { window.webkit.messageHandlers.missavLog.postMessage('singleJS err: ' + e.message); }
                    }, 2000);
                })();
                """
                webView.evaluateJavaScript(singleJS) { _, error in
                    if let error = error { self.log("❌ 详情页转搜索结果失败: \(error.localizedDescription)") }
                }
            }
        }

        if m3u8Continuation != nil {
            log("📋 详情页加载完成，autoClickJS 已通过 atDocumentEnd 自动注入，等待网络请求拦截...")
        }
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        log("❌ didFail: \(error.localizedDescription)")
        failPending(reason: error.localizedDescription)
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        log("❌ didFailProvisional: \(error.localizedDescription)")
        failPending(reason: error.localizedDescription)
    }

    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        log("🔐 认证挑战: \(challenge.protectionSpace.authenticationMethod)")
        completionHandler(.performDefaultHandling, nil)
    }

    private func failPending(reason: String) {
        log("🛑 终止所有等待: \(reason)")
        searchContinuation?.resume(throwing: MissAVError.networkError(reason))
        searchContinuation = nil
        m3u8Continuation?.resume(throwing: MissAVError.networkError(reason))
        m3u8Continuation = nil
    }
}

// MARK: - WKScriptMessageHandler
extension MissAVViewModel: WKScriptMessageHandler {
    func userContentController(_ controller: WKUserContentController, didReceive message: WKScriptMessage) {
        guard let name = MessageName(rawValue: message.name) else { return }

        switch name {
        case .log:
            log("📢 [JS] \(message.body)")

        case .videoList:
            log("📩 收到视频列表 JS 消息")
            guard let cont = searchContinuation else { log("⚠️ 收到 videoList 但 searchContinuation 为 nil"); return }
            searchContinuation = nil

            do {
                guard let jsonString = message.body as? String,
                      let data = jsonString.data(using: .utf8)
                else {
                    log("❌ videoList 消息格式错误")
                    cont.resume(throwing: MissAVError.parseError)
                    return
                }
                let result = try JSONDecoder().decode(MissAVSearchResult.self, from: data)
                log("✅ 解析到 \(result.items.count) 个视频")
                let videos = result.items.map { item -> MissAVMedia in
                    let code = Self.extractCode(from: item.detailURL) ?? "UNKNOWN"
                    let tag = Self.classify(url: item.detailURL, title: item.title, tags: item.tags)
                    return MissAVMedia(code: code, title: item.title, coverURL: item.coverURL, detailURL: item.detailURL, tag: tag)
                }
                cont.resume(returning: videos)
            } catch {
                log("❌ videoList 解析失败: \(error.localizedDescription)")
                cont.resume(throwing: MissAVError.parseError)
            }

        case .m3u8Detected:
            log("📩 收到 m3u8 消息: \(message.body)")
            guard let cont = m3u8Continuation else { log("⚠️ 收到 m3u8 但 m3u8Continuation 为 nil"); return }
            m3u8Continuation = nil

            let url = "\(message.body)"
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .replacingOccurrences(of: "\"", with: "")

            guard !url.isEmpty, url.contains(".m3u8") else {
                log("❌ m3u8 URL 无效: \(url)")
                cont.resume(throwing: MissAVError.m3u8NotFound)
                return
            }
            log("✅ 获取到 m3u8: \(url)")
            cont.resume(returning: url)
        }
    }
}

// MARK: - JavaScript 脚本
extension MissAVViewModel {
    private static let m3u8InterceptionJS = """
    (() => {
        if (window.__missavInterceptorInstalled) {
            window.webkit.messageHandlers.missavLog.postMessage('拦截器已存在，跳过');
            return;
        }
        window.__missavInterceptorInstalled = true;
        window.webkit.messageHandlers.missavLog.postMessage('拦截器已安装');

        const origFetch = window.fetch;
        window.fetch = function(...args) {
            const url = (typeof args[0] === 'string' ? args[0] : args[0]?.url || '');
            if (url.includes('.m3u8') || url.includes('playlist.m3u8')) {
                window.webkit.messageHandlers.missavM3U8.postMessage(url);
                window.webkit.messageHandlers.missavLog.postMessage('拦截到 m3u8 fetch: ' + url);
            }
            return origFetch.apply(this, args);
        };

        const origOpen = XMLHttpRequest.prototype.open;
        XMLHttpRequest.prototype.open = function(...args) {
            const url = args[1] || '';
            if (typeof url === 'string' && (url.includes('.m3u8') || url.includes('playlist.m3u8'))) {
                window.webkit.messageHandlers.missavM3U8.postMessage(url);
                window.webkit.messageHandlers.missavLog.postMessage('拦截到 m3u8 XHR: ' + url);
            }
            return origOpen.apply(this, args);
        };
        window.webkit.messageHandlers.missavLog.postMessage('拦截器安装完成');
    })();
    """

    private static func buildScrapeJS(baseURL: String) -> String {
        return """
        (() => {
            window.webkit.messageHandlers.missavLog.postMessage('抓取开始: ' + location.href);

            const tryScrape = () => {
                try {
                    var allLinks = document.querySelectorAll('div.grid a');
                    window.webkit.messageHandlers.missavLog.postMessage('div.grid a 总数: ' + allLinks.length);

                    if (allLinks.length === 0) {
                        // dump 页面中所有 a 标签
                        var allA = document.querySelectorAll('a');
                        var urls = [];
                        allA.forEach(function(a) {
                            if (a.href && a.href.indexOf('http') === 0 && a.href.indexOf('missav') !== -1 && a.href.indexOf('/cn/') !== -1) urls.push(a.href.substring(0, 120));
                        });
                        window.webkit.messageHandlers.missavLog.postMessage('所有 missav /cn/ 链接: ' + JSON.stringify(urls.slice(0, 30)));
                    }

                    const results = [];
                    allLinks.forEach(function(a) {
                        var href = a.href.indexOf('http') === 0 ? a.href : '\(baseURL)' + a.href;
                        if (href.indexOf('/cn/') === -1) return;
                        if (href.indexOf('contact') !== -1 || href.indexOf('dmca') !== -1 || href.indexOf('actresses') !== -1 || href.indexOf('ranking') !== -1) return;
                        var img = a.querySelector('img');
                        var title = img ? img.getAttribute('alt') || img.getAttribute('title') || '' : '';
                        var cover = img ? img.getAttribute('data-src') || img.src || '' : '';
                        var badges = [];
                        a.querySelectorAll('.badge, [class*="badge"], tag, [class*="tag"]').forEach(function(b) {
                            var t = b.textContent.trim(); if (t) badges.push(t);
                        });
                        if (title && href) results.push({ title: title.trim(), coverURL: cover, detailURL: href, tags: badges });
                    });

                    window.webkit.messageHandlers.missavLog.postMessage('过滤后: ' + results.length + ' 个');
                    results.forEach(function(r) { window.webkit.messageHandlers.missavLog.postMessage('  ' + r.detailURL + ' | ' + r.title.substring(0, 60)); });

                    var seen = {};
                    var unique = results.filter(function(r) {
                        var key = r.detailURL;
                        if (seen[key]) return false; seen[key] = true; return true;
                    });

                    window.webkit.messageHandlers.missavLog.postMessage('去重后发送 ' + unique.length + ' 个');
                    window.webkit.messageHandlers.missavVideoList.postMessage(JSON.stringify({ items: unique }));
                } catch(e) { window.webkit.messageHandlers.missavLog.postMessage('错误: ' + e.message); }
            };
            setTimeout(tryScrape, 3000);
        })();
        """
    }

    /// 自动点击播放器 + 提取 m3u8（atDocumentEnd 自动执行）
    /// MissAV 现在用自定义播放器（非 Plyr），改写策略
                private static let autoClickJS = """
    (() => {
        if (window !== window.top) return;
        if (location.href.indexOf('missav') === -1) return;
        if (location.href.indexOf('/search/') !== -1) return;
        window.webkit.messageHandlers.missavLog.postMessage('[提取] 启动: ' + location.href);

        // 直接从 script 标签提取视频 ID，构造 m3u8 URL
        // 参考: https://greasyfork.org/scripts/493932
        try {
            var script = document.evaluate('/html/body/script[5]/text()', document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);
            var text = script && script.singleNodeValue ? script.singleNodeValue.textContent : '';
            window.webkit.messageHandlers.missavLog.postMessage('[提取] script[5] 长度: ' + text.length);

            if (text) {
                var idx = text.indexOf('seek');
                window.webkit.messageHandlers.missavLog.postMessage('[提取] seek 位置: ' + idx);
                if (idx !== -1 && idx >= 38) {
                    var videoId = text.substring(idx - 38, idx - 2);
                    window.webkit.messageHandlers.missavLog.postMessage('[提取] 视频ID: ' + videoId);
                    var m3u8 = 'https://surrit.com/' + videoId + '/playlist.m3u8';
                    window.webkit.messageHandlers.missavM3U8.postMessage(m3u8);
                    window.webkit.messageHandlers.missavLog.postMessage('[提取] ✅ m3u8: ' + m3u8);
                } else {
                    window.webkit.messageHandlers.missavLog.postMessage('[提取] 未找到 seek');
                }
            } else {
                window.webkit.messageHandlers.missavLog.postMessage('[提取] script[5] 为空');
            }
        } catch(e) {
            window.webkit.messageHandlers.missavLog.postMessage('[提取] 错误: ' + e.message);
        }
    })();
    """



}

// MARK: - 工具方法
extension MissAVViewModel {
    static func extractCode(from url: String) -> String? {
        let pattern = "[a-zA-Z]+-\\d+"
        if let range = url.range(of: pattern, options: .regularExpression) {
            return String(url[range]).uppercased()
        }
        return nil
    }

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
    case cancelled
    case searchInProgress

    var errorDescription: String? {
        switch self {
        case .invalidURL: return "无效的 URL"
        case .parseError: return "解析失败"
        case .timeout: return "请求超时"
        case .m3u8NotFound: return "未找到视频流地址"
        case .networkError(let e): return "网络错误: \(e)"
        case .cancelled: return "已取消"
        case .searchInProgress: return "正在搜索中，请稍候"
        }
    }
}
