import SwiftUI

// MARK: - 主题色定义 (纯黑/白为主)
extension Color {
    // 主色调 - 纯黑白
    static let appBackground = Color(.systemBackground)     // 白色(浅色) / 黑色(深色)
    static let appForeground = Color(.label)                 // 黑色(浅色) / 白色(深色)
    static let appSecondary = Color(.secondaryLabel)         // 灰色副文本
    static let appTertiary = Color(.tertiaryLabel)           // 更浅的辅助色
    static let appCard = Color(.secondarySystemBackground)   // 卡片背景
    static let appCardAlt = Color(.tertiarySystemBackground) // 替代卡片背景
    static let appSeparator = Color(.separator)              // 分隔线
    static let appGrouped = Color(.systemGroupedBackground)  // 分组背景

    // 强调色 - 极简风格，少量使用
    static let appAccent = Color.primary                     // 使用系统主色
    static let appAccentSecondary = Color.secondary          // 辅助色

    // 深色模式适配渐变 (非常微妙)
    static let cardBorderGradient = LinearGradient(
        colors: [Color.primary.opacity(0.1), Color.primary.opacity(0.03)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    // 工具卡片渐变色映射
    static func cardGradient(for colorHex: String) -> LinearGradient {
        LinearGradient(
            colors: [Color(hex: colorHex).opacity(0.08), Color.clear],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    // 工具卡片图标色
    static func iconTint(for colorHex: String) -> Color {
        Color(hex: colorHex)
    }
}

// MARK: - Hex 颜色初始化
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 6:
            (a, r, g, b) = (255, (int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = ((int >> 24) & 0xFF, (int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
