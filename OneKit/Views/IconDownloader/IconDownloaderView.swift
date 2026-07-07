import SwiftUI

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
            if viewModel.isSearching {
                ProgressView().scaleEffect(1.2).frame(maxWidth: .infinity, maxHeight: .infinity).background(Color.appBackground.opacity(0.8))
            }
        }
        .background(Color.appBackground)
        .navigationTitle("图标下载").navigationBarTitleDisplayMode(.inline).toolbar(.hidden, for: .tabBar)
        .searchable(text: $viewModel.searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "搜索 App 名称...")
        .onSubmit(of: .search) { Task { await viewModel.search() } }
        .onChange(of: viewModel.searchText) { v in if v.isEmpty { viewModel.clearResults() } }
        .sheet(isPresented: $showDetail) { if let app = selectedApp { IconPreviewView(app: app, viewModel: viewModel) } }
        // 完全独立的错误页
        .fullScreenCover(isPresented: $viewModel.showError) {
            ErrorPageView(message: viewModel.errorMessage) {
                viewModel.showError = false
                Task { await viewModel.search() }
            }
        }
    }

    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "magnifyingglass.circle").font(.system(size: 60)).foregroundColor(.appSecondary.opacity(0.5))
            Text("搜索 AppStore 应用").font(.title3).fontWeight(.medium).foregroundColor(.appForeground)
            Text("输入应用名称搜索，即可下载高清图标").font(.body).foregroundColor(.appSecondary).multilineTextAlignment(.center)
        }.padding()
    }

    private var resultsList: some View {
        ScrollView {
            LazyVStack(spacing: 8) {
                ForEach(viewModel.searchResults) { app in
                    AppSearchResultRow(app: app, onTap: { selectedApp = app; showDetail = true; Haptic.light() })
                }
            }.padding(.vertical, 8)
        }
    }
}

// MARK: - 独立错误页面
struct ErrorPageView: View {
    @Environment(\.dismiss) var dismiss
    let message: String?
    let onRetry: () -> Void

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Spacer()
                Image(systemName: "wifi.slash").font(.system(size: 60)).foregroundColor(.appSecondary.opacity(0.5))
                Text("请求失败").font(.title2).fontWeight(.bold).foregroundColor(.appForeground)
                Text(message?.isEmpty == false ? message! : "请检查网络连接后重试")
                    .font(.body).foregroundColor(.appSecondary).multilineTextAlignment(.center).padding(.horizontal, 40)
                Spacer()
                Button {
                    dismiss()
                    onRetry()
                } label: {
                    Text("重试").fontWeight(.semibold).foregroundColor(.white)
                        .frame(maxWidth: .infinity).frame(height: 50)
                        .background(Color.appForeground).clipShape(RoundedRectangle(cornerRadius: 12))
                        .padding(.horizontal, 40)
                }
                Button { dismiss() } label: {
                    Text("取消").foregroundColor(.appSecondary).padding(.bottom, 20)
                }
            }
            .background(Color.appBackground)
            .navigationTitle("错误").navigationBarTitleDisplayMode(.inline)
        }
    }
}
