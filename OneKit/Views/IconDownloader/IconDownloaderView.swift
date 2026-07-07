import SwiftUI

// MARK: - AppStore 图标下载器
struct IconDownloaderView: View {
    @StateObject private var viewModel = IconDownloadViewModel()
    @State private var selectedApp: ITunesApp?
    @State private var showDetail = false

    var body: some View {
        ZStack {
            if viewModel.searchResults.isEmpty && !viewModel.isSearching {
                emptyStateView
            } else {
                resultsList
            }

            // 加载指示器
            if viewModel.isSearching {
                ProgressView()
                    .scaleEffect(1.2)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.appBackground.opacity(0.8))
            }
        }
        .background(Color.appBackground)
        .navigationTitle("图标下载")
        .navigationBarTitleDisplayMode(.inline)
        .searchable(
            text: $viewModel.searchText,
            placement: .navigationBarDrawer(displayMode: .always),
            prompt: "搜索 App 名称..."
        )
        .onSubmit(of: .search) {
            Task { await viewModel.search() }
        }
        .onChange(of: viewModel.searchText) { newValue in
            if newValue.isEmpty {
                viewModel.clearResults()
            }
        }
        .alert("提示", isPresented: $viewModel.showError) {
            Button("确定", role: .cancel) {}
        } message: {
            Text(viewModel.errorMessage ?? "未知错误")
        }
        .sheet(isPresented: $showDetail) {
            if let app = selectedApp {
                IconPreviewView(
                    app: app,
                    viewModel: viewModel
                )
            }
        }
    }

    // MARK: - 空状态
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "magnifyingglass.circle")
                .font(.system(size: 60))
                .foregroundColor(.appSecondary.opacity(0.5))

            Text("搜索 AppStore 应用")
                .font(.title3)
                .fontWeight(.medium)
                .foregroundColor(.appForeground)

            Text("输入应用名称搜索，\n即可下载高清图标")
                .font(.body)
                .foregroundColor(.appSecondary)
                .multilineTextAlignment(.center)
        }
        .padding()
    }

    // MARK: - 结果列表
    private var resultsList: some View {
        ScrollView {
            LazyVStack(spacing: 8) {
                ForEach(viewModel.searchResults) { app in
                    AppSearchResultRow(
                        app: app,
                        onTap: {
                            selectedApp = app
                            showDetail = true
                            Haptic.light()
                        },
                        onDownload: { size in
                            Task { await viewModel.downloadIcon(for: app, size: size) }
                        }
                    )
                }
            }
            .padding(.vertical, 8)
        }
    }
}
