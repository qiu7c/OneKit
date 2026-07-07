import SwiftUI

// MARK: - SF Symbols 浏览器主页
struct SFSymbolsListView: View {
    @StateObject private var viewModel = SFSymbolsViewModel()

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 8), count: 4)

    var body: some View {
        VStack(spacing: 0) {
            // 分类滚动条
            categoryScrollBar

            // Symbol 网格
            ScrollView {
                LazyVGrid(columns: columns, spacing: 8) {
                    ForEach(viewModel.filteredSymbols) { symbol in
                        SymbolGridCell(
                            symbol: symbol,
                            onTap: { viewModel.selectSymbol(symbol) },
                            onCopy: { viewModel.copySymbolName(symbol) }
                        )
                    }
                }
                .padding(12)
            }
        }
        .background(Color.appBackground)
        .navigationTitle("SF Symbols")
        .navigationBarTitleDisplayMode(.inline)
        .searchable(
            text: $viewModel.searchText,
            placement: .navigationBarDrawer(displayMode: .always),
            prompt: "搜索 Symbol 名称或关键词..."
        )
        .onChange(of: viewModel.searchText) { _ in
            viewModel.search()
        }
        .sheet(isPresented: $viewModel.isShowingDetail) {
            if let symbol = viewModel.selectedSymbol {
                SymbolDetailView(symbol: symbol)
            }
        }
    }

    // MARK: - 分类滚动条
    private var categoryScrollBar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 6) {
                ForEach(SFSymbolCategory.allCases) { category in
                    Button {
                        viewModel.selectCategory(category)
                        Haptic.light()
                    } label: {
                        Text(category.rawValue)
                            .font(.caption)
                            .fontWeight(viewModel.selectedCategory == category ? .semibold : .regular)
                            .foregroundColor(viewModel.selectedCategory == category ? .white : .appForeground)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 6)
                            .background(
                                viewModel.selectedCategory == category
                                    ? Color.appForeground
                                    : Color.appCard
                            )
                            .clipShape(Capsule())
                    }
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
        }
        .background(Color.appBackground)
        .overlay(Divider(), alignment: .bottom)
    }
}
