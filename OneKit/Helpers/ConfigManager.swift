import SwiftUI
import UniformTypeIdentifiers

// MARK: - 配置模型
struct UserConfig: Codable {
    var favoriteSymbols: [String]
    var savedColors: [PaletteColor]
    var quickLaunchTools: [String]
    var showDeltaPwd: Bool
    var theme: String
    var version: String = "1.0"
}

// MARK: - 配置管理器
final class ConfigManager: ObservableObject {
    static let shared = ConfigManager()

    // 收藏的 SF Symbols
    @AppStorage("fav_symbols") var favoriteSymbols: String = "" // 逗号分隔

    var favoriteSymbolsList: [String] {
        get { favoriteSymbols.split(separator: ",").map(String.init).filter { !$0.isEmpty } }
        set { favoriteSymbols = newValue.joined(separator: ",") }
    }

    func toggleFavorite(_ symbolId: String) {
        var list = favoriteSymbolsList
        if let idx = list.firstIndex(of: symbolId) {
            list.remove(at: idx)
        } else {
            list.append(symbolId)
        }
        favoriteSymbols = list.joined(separator: ",")
    }

    func isFavorite(_ symbolId: String) -> Bool {
        favoriteSymbolsList.contains(symbolId)
    }

    // MARK: - 导出配置
    func exportConfig() -> Data? {
        let tools = QuickLaunchManager.shared.visibleTools.map { $0.id }
        let savedColors = loadSavedColors()
        let theme = UserDefaults.standard.string(forKey: "app_theme") ?? "system"
        let showPwd = UserDefaults.standard.bool(forKey: "show_delta_pwd")

        let config = UserConfig(
            favoriteSymbols: favoriteSymbolsList,
            savedColors: savedColors,
            quickLaunchTools: tools,
            showDeltaPwd: showPwd,
            theme: theme
        )
        return try? JSONEncoder().encode(config)
    }

    // MARK: - 导入配置
    func importConfig(data: Data) -> Bool {
        guard let config = try? JSONDecoder().decode(UserConfig.self, from: data) else { return false }

        // 恢复收藏
        favoriteSymbols = config.favoriteSymbols.joined(separator: ",")

        // 恢复保存的颜色
        if let colorData = try? JSONEncoder().encode(config.savedColors) {
            UserDefaults.standard.set(colorData, forKey: "saved_palette_colors")
        }

        // 恢复首页工具
        if !config.quickLaunchTools.isEmpty {
            if let toolData = try? JSONEncoder().encode(config.quickLaunchTools) {
                UserDefaults.standard.set(toolData, forKey: "quick_launch_tools")
            }
        }

        // 恢复主题
        UserDefaults.standard.set(config.theme, forKey: "app_theme")

        // 恢复密码显示
        UserDefaults.standard.set(config.showDeltaPwd, forKey: "show_delta_pwd")

        return true
    }

    private func loadSavedColors() -> [PaletteColor] {
        guard let data = UserDefaults.standard.data(forKey: "saved_palette_colors"),
              let colors = try? JSONDecoder().decode([PaletteColor].self, from: data) else { return [] }
        return colors
    }

    // MARK: - 导出文件
    func exportConfigFile() -> URL? {
        guard let data = exportConfig() else { return nil }
        let url = FileManager.default.temporaryDirectory.appendingPathComponent("OneKit_Config.json")
        try? data.write(to: url)
        return url
    }
}
