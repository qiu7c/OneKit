import SwiftUI

struct DeltaForceView: View {
    @State private var isLoading = true
    @State private var pageTitle = "三角洲行动助手"
    @State private var canGoBack = false
    @State private var webView: WKWebView?

    let url = URL(string: "https://sjz.upx8.com/")!

    var body: some View {
        VStack(spacing: 0) {
            // 进度条
            if isLoading {
                ProgressView()
                    .progressViewStyle(.linear)
                    .tint(Color.accentColor)
            }

            // WebView
            WebViewRepresentable(url: url, isLoading: $isLoading, title: $pageTitle, canGoBack: $canGoBack, webView: $webView)
                .ignoresSafeArea(edges: .bottom)
        }
        .navigationTitle(pageTitle)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button { webView?.reload() } label: { Image(systemName: "arrow.clockwise") }
                    .disabled(isLoading)
            }
            ToolbarItemGroup(placement: .navigationBarLeading) {
                if canGoBack {
                    Button { webView?.goBack() } label: { Image(systemName: "chevron.left") }
                }
            }
        }
    }
}

// MARK: - WKWebView 封装 (完整版)
struct WebViewRepresentable: UIViewRepresentable {
    let url: URL
    @Binding var isLoading: Bool
    @Binding var title: String
    @Binding var canGoBack: Bool
    @Binding var webView: WKWebView?

    func makeCoordinator() -> Coordinator { Coordinator(self) }

    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.preferences.javaScriptEnabled = true
        let wv = WKWebView(frame: .zero, configuration: config)
        wv.navigationDelegate = context.coordinator
        wv.allowsBackForwardNavigationGestures = true
        wv.load(URLRequest(url: url))
        DispatchQueue.main.async { webView = wv }
        return wv
    }

    func updateUIView(_: WKWebView, context: Context) {}

    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebViewRepresentable
        init(_ p: WebViewRepresentable) { parent = p }

        func webView(_ wv: WKWebView, didStartProvisionalNavigation nav: WKNavigation!) { parent.isLoading = true }
        func webView(_ wv: WKWebView, didFinish navigation: WKNavigation!) {
            parent.isLoading = false; parent.title = wv.title ?? ""; parent.canGoBack = wv.canGoBack
        }
        func webView(_ wv: WKWebView, didFail navigation: WKNavigation!, withError e: Error) { parent.isLoading = false }
        func webView(_ wv: WKWebView, didFailProvisionalNavigation nav: WKNavigation!, withError e: Error) { parent.isLoading = false }
    }
}
