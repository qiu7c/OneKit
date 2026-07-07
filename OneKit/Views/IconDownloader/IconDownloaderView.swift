import SwiftUI

struct IconDownloaderView: View {
    @StateObject private var viewModel = IconDownloadViewModel()
    @State private var selectedApp: ITunesApp?
    @State private var showDetail = false

    var body: some View {
        ZStack {
            if viewModel.searchResults.isEmpty && !viewModel.isSearching { emptyStateView }
            else { resultsList }

            if viewModel.isSearching {
                ProgressView().scaleEffect(1.2).frame(maxWidth: .infinity, maxHeight: .infinity).background(Color.appBackground.opacity(0.8))
            }

            if viewModel.showError {
                Rectangle().fill(Color.black.opacity(0.3)).ignoresSafeArea()
                    .id("errbg-\(viewModel.showError)")
                VStack(spacing: 16) {
                    Text("提示").font(.headline).fontWeight(.bold)
                    Text(viewModel.errorMessage?.isEmpty == false ? viewModel.errorMessage! : "请求失败，请检查网络连接")
                        .font(.body).foregroundColor(.appSecondary).multilineTextAlignment(.center)
                    Button { viewModel.showError = false } label: {
                        Text("确定").fontWeight(.semibold).foregroundColor(.white)
                            .frame(maxWidth: .infinity).frame(height: 40)
                            .background(Color.appForeground).clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
                .padding(24).background(Color.appBackground).clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(color: .black.opacity(0.15), radius: 20).padding(40)
                .id("err-\(viewModel.showError)")
            }
        }
        .background(Color.appBackground)
        .navigationTitle("图标下载").navigationBarTitleDisplayMode(.inline).toolbar(.hidden, for: .tabBar)
        .searchable(text: $viewModel.searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "搜索 App 名称...")
        .onSubmit(of: .search) { Task { await viewModel.search() } }
        .onChange(of: viewModel.searchText) { v in if v.isEmpty { viewModel.clearResults() } }
        .sheet(isPresented: $showDetail) { if let app = selectedApp { IconPreviewView(app: app, viewModel: viewModel) } }
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
