import SwiftUI

// MARK: - 工具分类
enum ToolCategory: String, CaseIterable, Identifiable, Codable {
    case icons = "图标工具"
    case design = "设计工具"
    case developer = "开发工具"
    case utility = "实用工具"
    case media = "媒体工具"
    case network = "网络工具"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .icons: return "photo.on.rectangle"
        case .design: return "paintbrush.fill"
        case .developer: return "hammer.fill"
        case .utility: return "wrench.and.screwdriver.fill"
        case .media: return "play.rectangle.fill"
        case .network: return "network"
        }
    }

    var tint: Color {
        switch self {
        case .icons: return Color(hex: "#6366F1")
        case .design: return Color(hex: "#06B6D4")
        case .developer: return Color(hex: "#F59E0B")
        case .utility: return Color(hex: "#8B5CF6")
        case .media: return Color(hex: "#EF4444")
        case .network: return Color(hex: "#10B981")
        }
    }
}

// MARK: - 工具项模型
struct ToolItem: Identifiable, Codable {
    let id: String
    let title: String
    let subtitle: String
    let icon: String
    let category: ToolCategory
    let color: String
    let isBuiltIn: Bool
    let tags: [String]

    static let placeholder: ToolItem = .init(
        id: "更多工具开发中",
        title: "更多工具",
        subtitle: "即将推出...",
        icon: "square.3.layers.3d.down.right",
        category: .utility,
        color: "#8B5CF6",
        isBuiltIn: false,
        tags: ["即将推出"]
    )
}

// MARK: - 预置工具列表
extension ToolItem {
    static let builtInTools: [ToolItem] = [
        .init(
            id: "sf-symbols",
            title: "SF Symbols",
            subtitle: "浏览、搜索和预览 SF Symbols 5",
            icon: "star.square.fill",
            category: .icons,
            color: "#6366F1",
            isBuiltIn: true,
            tags: ["系统图标", "SF Symbols", "预览"]
        ),
        .init(
            id: "appstore-icon",
            title: "AppStore 图标下载",
            subtitle: "搜索并下载 App 的高清图标",
            icon: "magnifyingglass.circle.fill",
            category: .icons,
            color: "#06B6D4",
            isBuiltIn: true,
            tags: ["AppStore", "图标下载", "搜索"]
        ),
        .init(
            id: "color-palette",
            title: "调色板工具",
            subtitle: "取色、调色板生成和管理",
            icon: "paintpalette.fill",
            category: .design,
            color: "#F59E0B",
            isBuiltIn: true,
            tags: ["颜色", "取色", "色板"]
        ),
        .init(
            id: "more-2",
            title: "JSON 格式化",
            subtitle: "JSON 格式化、验证与压缩",
            icon: "curlybraces.square.fill",
            category: .developer,
            color: "#10B981",
            isBuiltIn: false,
            tags: ["即将推出"]
        ),
        .init(
            id: "more-3",
            title: "二维码生成",
            subtitle: "生成和扫描二维码 / 条码",
            icon: "qrcode",
            category: .utility,
            color: "#8B5CF6",
            isBuiltIn: false,
            tags: ["即将推出"]
        ),
        .init(
            id: "more-4",
            title: "图片压缩",
            subtitle: "批量压缩和转换图片格式",
            icon: "photo.compress",
            category: .media,
            color: "#EF4444",
            isBuiltIn: false,
            tags: ["即将推出"]
        ),
        .init(
            id: "more-5",
            title: "IP 工具",
            subtitle: "网络诊断、IP 查询和速度测试",
            icon: "wifi.square.fill",
            category: .network,
            color: "#06B6D4",
            isBuiltIn: false,
            tags: ["即将推出"]
        ),
        .init(
            id: "more-6",
            title: "正则测试",
            subtitle: "正则表达式编写与实时测试",
            icon: "doc.text.magnifyingglass",
            category: .developer,
            color: "#6366F1",
            isBuiltIn: false,
            tags: ["即将推出"]
        ),
    ]
}
