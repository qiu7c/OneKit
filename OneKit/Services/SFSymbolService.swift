import SwiftUI
#if canImport(SFSafeSymbols)
import SFSafeSymbols
#endif

// MARK: - SF Symbols 服务
actor SFSymbolService {
    static let shared = SFSymbolService()

    private init() {}

    /// 所有 SF Symbols (来自 SFSafeSymbols)
    private var allSymbolNames: [String] {
        #if canImport(SFSafeSymbols)
        return SFSymbol.allSymbols.map { $0.rawValue }
        #else
        return SFSymbolItem.popularSymbols.map { $0.id }
        #endif
    }

    /// 搜索 SF Symbols
    func searchSymbols(query: String) -> [SFSymbolItem] {
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            return symbols(for: .all)
        }

        let lowercased = query.lowercased()

        // 先搜预置列表 (有中文名)
        let curated = SFSymbolItem.popularSymbols.filter { item in
            item.name.lowercased().contains(lowercased) ||
            item.id.lowercased().contains(lowercased) ||
            item.keywords.contains { $0.lowercased().contains(lowercased) }
        }

        // 再搜全量 (只有英文名)
        let allResults = allSymbolNames.filter { $0.lowercased().contains(lowercased) }
        let curatedIds = Set(curated.map { $0.id })
        let additional = allResults
            .filter { !curatedIds.contains($0) }
            .map { SFSymbolItem(id: $0, name: $0, category: .all, keywords: [], isMulticolor: false, availability: "iOS 16+") }

        return curated + additional
    }

    /// 按分类获取 Symbols (只限预置列表)
    func symbols(for category: SFSymbolCategory) -> [SFSymbolItem] {
        if category == .all {
            return SFSymbolItem.popularSymbols
        }
        return SFSymbolItem.popularSymbols.filter { $0.category == category }
    }
}
