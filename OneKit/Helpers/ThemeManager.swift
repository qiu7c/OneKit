import SwiftUI

// MARK: - 主题模式
enum AppTheme: String, CaseIterable, Identifiable {
    case system = "跟随系统"
    case pureBlack = "纯黑模式"
    case pureWhite = "纯白模式"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .system: return "circle.lefthalf.filled"
        case .pureBlack: return "moon.fill"
        case .pureWhite: return "sun.max.fill"
        }
    }

    /// 对应的 SwiftUI ColorScheme
    var colorScheme: ColorScheme? {
        switch self {
        case .pureBlack: return .dark
        case .pureWhite: return .light
        case .system: return nil
        }
    }
}

// MARK: - 主题管理器
final class ThemeManager: ObservableObject {
    static let shared = ThemeManager()

    @Published var currentTheme: AppTheme {
        didSet {
            UserDefaults.standard.set(currentTheme.rawValue, forKey: "app_theme")
            // 通知窗口更新
            applyTheme()
        }
    }

    private init() {
        if let saved = UserDefaults.standard.string(forKey: "app_theme"),
           let theme = AppTheme(rawValue: saved) {
            currentTheme = theme
        } else {
            currentTheme = .system
        }
    }

    /// 应用到所有窗口
    func applyTheme() {
        let scenes = UIApplication.shared.connectedScenes
        for scene in scenes {
            if let windowScene = scene as? UIWindowScene {
                for window in windowScene.windows {
                    window.overrideUserInterfaceStyle = {
                        switch currentTheme {
                        case .pureBlack: return .dark
                        case .pureWhite: return .light
                        case .system: return .unspecified
                        }
                    }()
                }
            }
        }
    }
}
