import SwiftUI
#if canImport(SFSafeSymbols)
import SFSafeSymbols
#endif

// MARK: - SF Symbols 服务
actor SFSymbolService {
    static let shared = SFSymbolService()

    private init() {}

    /// 所有 SF Symbols 名称 (来自 SFSafeSymbols)
    private var allSymbolNames: [String] {
        #if canImport(SFSafeSymbols)
        return SFSymbol.allSymbols.map { $0.rawValue }
        #else
        return SFSymbolItem.popularSymbols.map { $0.id }
        #endif
    }

    /// 获取所有符号 (转为 SFSymbolItem)
    private func makeAllSymbolItems() -> [SFSymbolItem] {
        allSymbolNames.map { name in
            let cat = categoryForSymbol(name)
            return SFSymbolItem(
                id: name,
                name: name,
                category: cat,
                keywords: [],
                isMulticolor: name.contains(".fill"),
                availability: "iOS 16+"
            )
        }
    }

    /// 搜索 SF Symbols (全量)
    func searchSymbols(query: String) -> [SFSymbolItem] {
        let lowercased = query.lowercased()
        return allSymbolNames
            .filter { $0.lowercased().contains(lowercased) }
            .map { SFSymbolItem(id: $0, name: $0, category: .all, keywords: [], isMulticolor: false, availability: "iOS 16+") }
    }

    /// 按分类获取
    func symbols(for category: SFSymbolCategory) -> [SFSymbolItem] {
        if category == .all {
            return makeAllSymbolItems()
        }
        return allSymbolNames
            .filter { categoryForSymbol($0) == category }
            .map { SFSymbolItem(id: $0, name: $0, category: category, keywords: [], isMulticolor: false, availability: "iOS 16+") }
    }

    /// 简易分类映射 (基于名称前缀)
    private func categoryForSymbol(_ name: String) -> SFSymbolCategory {
        if name.hasPrefix("arrow") || name.hasPrefix("chevron") { return .arrows }
        if name.hasPrefix("sun") || name.hasPrefix("moon") || name.hasPrefix("cloud") || name.hasPrefix("snowflake") || name.hasPrefix("tornado") || name.hasPrefix("wind") || name.hasPrefix("umbrella") { return .weather }
        if name.hasPrefix("message") || name.hasPrefix("bubble") || name.hasPrefix("envelope") || name.hasPrefix("phone") || name.hasPrefix("video") || name.hasPrefix("mic") || name.hasPrefix("waveform") { return .communication }
        if name.hasPrefix("iphone") || name.hasPrefix("ipad") || name.hasPrefix("applewatch") || name.hasPrefix("mac") || name.hasPrefix("airpods") || name.hasPrefix("tv") || name.hasPrefix("speaker") || name.hasPrefix("headphone") || name.hasPrefix("wifi") || name.hasPrefix("battery") || name.hasPrefix("display") || name.hasPrefix("printer") || name.hasPrefix("keyboard") { return .device }
        if name.hasPrefix("pencil") || name.hasPrefix("paint") || name.hasPrefix("ruler") || name.hasPrefix("eyedropper") || name.hasPrefix("wand") || name.hasPrefix("crop") || name.hasPrefix("lasso") || name.hasPrefix("eraser") || name.hasPrefix("highlighter") { return .editing }
        if name.hasPrefix("play") || name.hasPrefix("pause") || name.hasPrefix("stop") || name.hasPrefix("forward") || name.hasPrefix("backward") || name.hasPrefix("shuffle") || name.hasPrefix("repeat") || name.hasPrefix("music") || name.hasPrefix("photo") || name.hasPrefix("guitar") { return .media }
        if name.hasPrefix("person") || name.hasPrefix("hand.") || name.hasPrefix("face.") || name.hasPrefix("figure.") || name.hasPrefix("eye") || name.hasPrefix("ear") { return .human }
        if name.hasPrefix("heart") || name.hasPrefix("cross") || name.hasPrefix("stethoscope") || name.hasPrefix("pill") || name.hasPrefix("brain") || name.hasPrefix("lungs") { return .health }
        if name.hasPrefix("leaf") || name.hasPrefix("flame") || name.hasPrefix("drop") || name.hasPrefix("mountain") || name.hasPrefix("tree") { return .nature }
        if name.hasPrefix("trash") || name.hasPrefix("folder") || name.hasPrefix("doc") || name.hasPrefix("calendar") || name.hasPrefix("clock") || name.hasPrefix("alarm") || name.hasPrefix("timer") || name.hasPrefix("book") || name.hasPrefix("map") || name.hasPrefix("location") || name.hasPrefix("lock") || name.hasPrefix("bell") || name.hasPrefix("camera") || name.hasPrefix("gear") || name.hasPrefix("magnifying") || name.hasPrefix("qrcode") || name.hasPrefix("scissors") || name.hasPrefix("link") || name.hasPrefix("tag") || name.hasPrefix("gift") || name.hasPrefix("paperclip") { return .objectAndTools }
        if name.hasPrefix("car") || name.hasPrefix("bus") || name.hasPrefix("tram") || name.hasPrefix("bike") || name.hasPrefix("airplane") || name.hasPrefix("sailboat") || name.hasPrefix("ferry") || name.hasPrefix("fuelpump") || name.hasPrefix("signpost") { return .transport }
        if name.hasPrefix("bag") || name.hasPrefix("cart") || name.hasPrefix("creditcard") || name.hasPrefix("dollar") || name.hasPrefix("banknote") || name.hasPrefix("percent") { return .commerce }
        if name.hasPrefix("square") || name.hasPrefix("circle") || name.hasPrefix("triangle") || name.hasPrefix("diamond") || name.hasPrefix("hexagon") || name.hasPrefix("pentagon") || name.hasPrefix("capsule") || name.hasPrefix("oval") || name.hasPrefix("rectangle") || name.hasPrefix("house") { return .shapes }
        if name.hasPrefix("text") || name.hasPrefix("bold") || name.hasPrefix("italic") || name.hasPrefix("underline") || name.hasPrefix("strikethrough") || name.hasPrefix("list.") { return .text }
        if name.hasPrefix("command") || name.hasPrefix("option") || name.hasPrefix("control") || name.hasPrefix("shift") || name.hasPrefix("capslock") || name.hasPrefix("delete") || name.hasPrefix("escape") || name.hasPrefix("return") || name.hasPrefix("tab") { return .keyboard }
        if name.hasPrefix("a.") || name.hasPrefix("b.") || name.hasPrefix("c.") || name.hasPrefix("number") || name.hasPrefix("questionmark") || name.hasPrefix("exclamationmark") || name.hasPrefix("xmark") || name.hasPrefix("checkmark") || name.hasPrefix("plus.") || name.hasPrefix("minus.") { return .indices }
        if name.contains("circle") || name.contains("square") { return .shapes }
        return .all
    }
}
