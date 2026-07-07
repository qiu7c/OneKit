import XCTest
@testable import OneKit

final class OneKitTests: XCTestCase {

    // MARK: - ToolItem 模型测试
    func testToolItemBuiltInCount() {
        let tools = ToolItem.builtInTools
        XCTAssertFalse(tools.isEmpty, "内置工具列表不应为空")
        XCTAssertTrue(tools.contains(where: { $0.id == "sf-symbols" }), "应包含 SF Symbols 工具")
        XCTAssertTrue(tools.contains(where: { $0.id == "appstore-icon" }), "应包含 AppStore 图标下载工具")
    }

    func testToolItemCategoryMapping() {
        let tools = ToolItem.builtInTools
        for tool in tools {
            XCTAssertFalse(tool.category.rawValue.isEmpty, "工具分类不应为空")
            XCTAssertFalse(tool.category.icon.isEmpty, "分类图标不应为空")
        }
    }

    // MARK: - SFSymbolItem 模型测试
    func testSFSymbolPopularSymbols() {
        let symbols = SFSymbolItem.popularSymbols
        XCTAssertFalse(symbols.isEmpty, "热门 Symbol 列表不应为空")
        XCTAssertGreaterThanOrEqual(symbols.count, 20, "至少应有 20 个热门 Symbol")

        for symbol in symbols {
            XCTAssertFalse(symbol.id.isEmpty, "Symbol 名称不应为空")
            XCTAssertFalse(symbol.name.isEmpty, "Symbol 中文名不应为空")
        }
    }

    func testSFSymbolCategories() {
        let categories = SFSymbolCategory.allCases
        XCTAssertFalse(categories.isEmpty, "分类列表不应为空")
        XCTAssertTrue(categories.contains(.all), "应包含 '全部' 分类")

        for category in categories {
            XCTAssertFalse(category.rawValue.isEmpty, "分类名不应为空")
        }
    }

    // MARK: - AppStoreApp 模型测试
    func testITunesAppModel() {
        let app = ITunesApp(
            trackId: 12345,
            trackName: "Test App",
            artistName: "Test Developer",
            artworkUrl60: "https://example.com/icon60.png",
            artworkUrl100: "https://example.com/icon100.png",
            artworkUrl512: "https://example.com/icon512.png",
            artworkUrl1024: nil,
            primaryGenreName: "Utilities",
            genres: nil,
            trackViewUrl: nil,
            description: nil,
            screenshotUrls: nil,
            averageUserRating: 4.5,
            userRatingCount: 100,
            minimumOsVersion: nil,
            fileSizeBytes: nil,
            version: "1.0",
            releaseNotes: nil,
            sellerName: nil,
            languageCodesISO2A: nil,
            bundleId: nil
        )

        XCTAssertEqual(app.trackName, "Test App")
        XCTAssertEqual(app.artistName, "Test Developer")
        XCTAssertNotNil(app.highResIconURL)
        XCTAssertNotNil(app.midResIconURL)
        XCTAssertNotNil(app.lowResIconURL)
        XCTAssertEqual(app.averageUserRating, 4.5)
    }

    func testIconSizeEnum() {
        let sizes = IconSize.allCases
        XCTAssertEqual(sizes.count, 4, "应有 4 种图标尺寸")

        XCTAssertEqual(IconSize.size60.pixelSize, 60)
        XCTAssertEqual(IconSize.size100.pixelSize, 100)
        XCTAssertEqual(IconSize.size512.pixelSize, 512)
        XCTAssertEqual(IconSize.size1024.pixelSize, 1024)
    }

    // MARK: - SFSymbolService 测试
    func testSFSymbolServiceSearch() async {
        let service = SFSymbolService.shared
        let results = await service.searchSymbols(query: "star")
        XCTAssertFalse(results.isEmpty, "搜索 'star' 应返回结果")
    }

    func testSFSymbolServiceEmptySearch() async {
        let service = SFSymbolService.shared
        let results = await service.searchSymbols(query: "")
        // 空搜索应返回热门列表
        XCTAssertFalse(results.isEmpty, "空搜索应返回热门 Symbol")
    }

    func testSFSymbolServiceCategoryFilter() async {
        let service = SFSymbolService.shared
        let allSymbols = await service.symbols(for: .all)
        let weatherSymbols = await service.symbols(for: .weather)

        XCTAssertFalse(allSymbols.isEmpty)
        // 分类过滤后应少于或等于全部
        XCTAssertLessThanOrEqual(weatherSymbols.count, allSymbols.count)
    }

    // MARK: - 颜色测试
    func testHexColorInit() {
        let color = Color(hex: "#000000")
        let white = Color(hex: "#FFFFFF")
        let red = Color(hex: "#FF0000")

        // 只需确保不崩溃
        XCTAssertNotNil(color)
        XCTAssertNotNil(white)
        XCTAssertNotNil(red)
    }

    // MARK: - ToolCategory 测试
    func testToolCategoryCompleteness() {
        let categories = ToolCategory.allCases
        XCTAssertFalse(categories.isEmpty)

        for category in categories {
            XCTAssertFalse(category.icon.isEmpty, "分类应有图标")
        }
    }

    // MARK: - 性能测试
    func testPopularSymbolsLoadingPerformance() {
        measure {
            _ = SFSymbolItem.popularSymbols
        }
    }
}
