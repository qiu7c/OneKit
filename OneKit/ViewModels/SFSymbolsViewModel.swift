import SwiftUI

// MARK: - SF Symbols ViewModel
@MainActor
class SFSymbolsViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var selectedCategory: SFSymbolCategory = .all
    @Published var filteredSymbols: [SFSymbolItem] = []
    @Published var selectedSymbol: SFSymbolItem?
    @Published var isShowingDetail = false

    private let service = SFSymbolService.shared

    init() {
        Task {
            await loadSymbols()
        }
    }

    // MARK: - 加载 Symbols
    func loadSymbols() async {
        let symbols = await service.symbols(for: selectedCategory)
        filteredSymbols = symbols
    }

    // MARK: - 搜索
    func search() {
        Task {
            if searchText.isEmpty {
                let symbols = await service.symbols(for: selectedCategory)
                filteredSymbols = symbols
            } else {
                let results = await service.searchSymbols(query: searchText)
                filteredSymbols = results
            }
        }
    }

    // MARK: - 切换分类
    func selectCategory(_ category: SFSymbolCategory) {
        selectedCategory = category
        searchText = ""
        search()
    }

    // MARK: - 选择 Symbol
    func selectSymbol(_ symbol: SFSymbolItem) {
        selectedSymbol = symbol
        isShowingDetail = true
        Haptic.light()
    }

    // MARK: - 复制名称
    func copySymbolName(_ symbol: SFSymbolItem) {
        UIPasteboard.general.string = symbol.id
        Haptic.success()
    }
}
