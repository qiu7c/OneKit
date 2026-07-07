import SwiftUI
import WebKit

// MARK: - WKWebView HLS 播放器（绕过 CDN TLS 指纹封锁）
struct MissAVPlayerView: View {
    let m3u8URL: String
    let referer: String?     // MissAV 详情页 URL，用于 Referer 头
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)

            WebVideoPlayer(m3u8URL: m3u8URL, referer: referer)
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

// MARK: - WKWebView 播放器
struct WebVideoPlayer: UIViewRepresentable {
    let m3u8URL: String
    let referer: String?

    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        config.mediaTypesRequiringUserActionForPlayback = []

        let webView = WKWebView(frame: .zero, configuration: config)
        webView.backgroundColor = .black
        webView.isOpaque = false

        let refererURL = referer.flatMap { URL(string: $0) }

        let html = """
        <!DOCTYPE html>
        <html>
        <head>
            <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
            <style>
                * { margin: 0; padding: 0; }
                body { background: #000; display: flex; align-items: center; justify-content: center; height: 100vh; }
                video { width: 100%; max-height: 100vh; }
            </style>
        </head>
        <body>
            <video id="player" controls autoplay playsinline></video>
            <script>
                var v = document.getElementById('player');
                v.src = '\(m3u8URL)';
                v.play().catch(function(e) {
                    // 自动播放被拦截，用户手动点播放
                    console.log('autoplay blocked:', e.message);
                });
            </script>
        </body>
        </html>
        """

        webView.loadHTMLString(html, baseURL: refererURL)
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {}
}
