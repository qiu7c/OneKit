import SwiftUI

struct SFSymbolsListView: View {
    @StateObject private var viewModel = SFSymbolsViewModel()
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 8), count: 4)

    var body: some View {
        VStack(spacing: 0) {
            categoryScrollBar
            ScrollView {
                LazyVGrid(columns: columns, spacing: 8) {
                    ForEach(viewModel.filteredSymbols) { symbol in
                        SymbolGridCell(
                            symbol: symbol,
                            isFavorite: viewModel.isFavorite(symbol),
                            onTap: { viewModel.selectSymbol(symbol) },
                            onCopy: { viewModel.copySymbolName(symbol) },
                            onFavorite: { viewModel.toggleFavorite(symbol) }
                        )
                    }
                }.padding(12)
            }
        }
        .background(Color.appBackground)
        .navigationTitle("SF Symbols").navigationBarTitleDisplayMode(.inline)
        .searchable(text: $viewModel.searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "搜索...")
        .onChange(of: viewModel.searchText) { _ in viewModel.search() }
        .onChange(of: viewModel.showFavoritesOnly) { _ in viewModel.search() }
        .sheet(isPresented: $viewModel.isShowingDetail) {
            if let symbol = viewModel.selectedSymbol { SymbolDetailView(symbol: symbol) }
        }
    }

    private var categoryScrollBar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 6) {
                ForEach(SFSymbolCategory.allCases) { cat in
                    Button {
                        viewModel.selectCategory(cat); Haptic.light()
                    } label: {
                        Text(cat.rawValue).font(.caption)
                            .fontWeight(viewModel.selectedCategory == cat ? .semibold : .regular)
                            .foregroundColor(viewModel.selectedCategory == cat ? Color.appBackground : .appForeground)
                            .padding(.horizontal, 14).padding(.vertical, 6)
                            .background(viewModel.selectedCategory == cat ? Color.appForeground : Color.appCard)
                            .clipShape(Capsule())
                    }
                }
            }.padding(.horizontal, 12).padding(.vertical, 10)
        }
        .overlay(alignment: .trailing) {
            // 收藏筛选按钮
            Button {
                withAnimation { viewModel.showFavoritesOnly.toggle(); Haptic.light() }
            } label: {
                Image(systemName: viewModel.showFavoritesOnly ? "heart.fill" : "heart")
                    .font(.body).foregroundColor(viewModel.showFavoritesOnly ? .red : .appSecondary)
                    .padding(.trailing, 12)
            }
        }
        .background(Color.appBackground)
        .overlay(Divider(), alignment: .bottom)
    }
}
