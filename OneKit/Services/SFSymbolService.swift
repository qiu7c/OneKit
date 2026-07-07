import SwiftUI

// MARK: - SF Symbols 服务
actor SFSymbolService {
    static let shared = SFSymbolService()

    private init() {}

    /// 完整符号列表
    private var allSymbols: [SFSymbolItem] {
        SFSymbolItem.allComprehensiveSymbols
    }

    /// 搜索 SF Symbols
    func searchSymbols(query: String) -> [SFSymbolItem] {
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            return allSymbols
        }

        let lowercased = query.lowercased()
        return allSymbols.filter { item in
            item.name.lowercased().contains(lowercased) ||
            item.id.lowercased().contains(lowercased) ||
            item.keywords.contains { $0.lowercased().contains(lowercased) }
        }
    }

    /// 按分类获取 Symbols
    func symbols(for category: SFSymbolCategory) -> [SFSymbolItem] {
        if category == .all {
            return allSymbols
        }
        return allSymbols.filter { $0.category == category }
    }
}
