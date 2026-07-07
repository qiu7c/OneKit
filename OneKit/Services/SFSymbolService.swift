import SwiftUI

// MARK: - SF Symbols 服务
actor SFSymbolService {
    static let shared = SFSymbolService()

    private init() {}

    /// 搜索 SF Symbols
    func searchSymbols(query: String) -> [SFSymbolItem] {
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            return SFSymbolItem.popularSymbols
        }

        let lowercased = query.lowercased()
        return SFSymbolItem.popularSymbols.filter { item in
            item.name.lowercased().contains(lowercased) ||
            item.id.lowercased().contains(lowercased) ||
            item.keywords.contains { $0.lowercased().contains(lowercased) }
        }
    }

    /// 按分类获取 Symbols
    func symbols(for category: SFSymbolCategory) -> [SFSymbolItem] {
        if category == .all {
            return SFSymbolItem.popularSymbols
        }
        return SFSymbolItem.popularSymbols.filter { $0.category == category }
    }
}
