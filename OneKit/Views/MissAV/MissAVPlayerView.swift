import SwiftUI
import WebKit

// MARK: - WKWebView HLS 播放器
struct MissAVPlayerView: View {
    let m3u8URL: String
    let referer: String?
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            // 直接加载 m3u8 URL，Safari 原生 HLS 播放器会接管
            M3U8WebView(url: m3u8URL, referer: referer)
                .edgesIgnoringSafeArea(.all)
            VStack {
                HStack {
                    Spacer()
                    Button { dismiss() } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(.white.opacity(0.8))
                            .padding(12)
                    }
                }
                Spacer()
            }
        }
    }
}

struct M3U8WebView: UIViewRepresentable {
    let url: String
    let referer: String?

    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        config.mediaTypesRequiringUserActionForPlayback = []

        let webView = WKWebView(frame: .zero, configuration: config)
        webView.backgroundColor = .black
        webView.isOpaque = false

        if let url = URL(string: url) {
            var req = URLRequest(url: url)
            if let referer = referer {
                req.setValue(referer, forHTTPHeaderField: "Referer")
            }
            webView.load(req)
        }
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {}
}
