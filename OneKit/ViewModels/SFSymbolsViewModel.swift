import SwiftUI

@MainActor
class SFSymbolsViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var selectedCategory: SFSymbolCategory = .all
    @Published var filteredSymbols: [SFSymbolItem] = []
    @Published var selectedSymbol: SFSymbolItem?
    @Published var isShowingDetail = false
    @Published var showFavoritesOnly = false

    private let service = SFSymbolService.shared
    private let config = ConfigManager.shared

    init() { Task { await loadSymbols() } }

    func loadSymbols() async {
        let symbols = await service.symbols(for: selectedCategory)
        filteredSymbols = showFavoritesOnly ? symbols.filter { config.isFavorite($0.id) } : symbols
    }

    func search() {
        Task {
            if searchText.isEmpty {
                let symbols = await service.symbols(for: selectedCategory)
                filteredSymbols = showFavoritesOnly ? symbols.filter { config.isFavorite($0.id) } : symbols
            } else {
                let results = await service.searchSymbols(query: searchText)
                filteredSymbols = showFavoritesOnly ? results.filter { config.isFavorite($0.id) } : results
            }
        }
    }

    func selectCategory(_ category: SFSymbolCategory) {
        selectedCategory = category; searchText = ""; search()
    }

    func selectSymbol(_ symbol: SFSymbolItem) {
        selectedSymbol = symbol; isShowingDetail = true; Haptic.light()
    }

    func toggleFavorite(_ symbol: SFSymbolItem) {
        config.toggleFavorite(symbol.id)
        search()
    }

    func isFavorite(_ symbol: SFSymbolItem) -> Bool {
        config.isFavorite(symbol.id)
    }

    func copySymbolName(_ symbol: SFSymbolItem) {
        UIPasteboard.general.string = symbol.id; Haptic.success()
    }
}
