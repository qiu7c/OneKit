import SwiftUI

enum ToolCategory: String, CaseIterable, Identifiable, Codable {
    case icons = "图标工具"; case design = "设计工具"; case developer = "开发工具"; case utility = "实用工具"; case media = "媒体工具"; case network = "网络工具"
    var id: String { rawValue }; var icon: String { switch self { case .icons: return "photo.on.rectangle"; case .design: return "paintbrush.fill"; case .developer: return "hammer.fill"; case .utility: return "wrench.and.screwdriver.fill"; case .media: return "play.rectangle.fill"; case .network: return "network" } }
    var tint: Color { switch self { case .icons: return Color(hex: "#6366F1"); case .design: return Color(hex: "#06B6D4"); case .developer: return Color(hex: "#10B981"); case .utility: return Color(hex: "#8B5CF6"); case .media: return Color(hex: "#EF4444"); case .network: return Color(hex: "#06B6D4") } }
}

struct ToolItem: Identifiable, Codable, Hashable {
    let id: String; let title: String; let subtitle: String; let icon: String; let category: ToolCategory; let color: String; let isBuiltIn: Bool; let tags: [String]
    static let placeholder: ToolItem = .init(id: "more", title: "更多工具", subtitle: "即将推出...", icon: "square.3.layers.3d.down.right", category: .utility, color: "#8B5CF6", isBuiltIn: false, tags: ["即将推出"])
}

extension ToolItem {
    static let builtInTools: [ToolItem] = [
        .init(id: "sf-symbols", title: "SF Symbols", subtitle: "浏览搜索预览 SF Symbols", icon: "star.square.fill", category: .icons, color: "#6366F1", isBuiltIn: true, tags: ["系统图标"]),
        .init(id: "appstore-icon", title: "AppStore 图标下载", subtitle: "搜索下载 App 高清图标", icon: "magnifyingglass.circle.fill", category: .icons, color: "#06B6D4", isBuiltIn: true, tags: ["AppStore"]),
        .init(id: "color-palette", title: "调色板", subtitle: "取色·调色·图片取色", icon: "paintpalette.fill", category: .design, color: "#F59E0B", isBuiltIn: true, tags: ["颜色"]),
        .init(id: "codec", title: "编解码", subtitle: "JSON·Base64·URL·Unicode·Hash", icon: "curlybraces.square.fill", category: .developer, color: "#10B981", isBuiltIn: true, tags: ["JSON"]),
        .init(id: "http-request", title: "HTTP 请求", subtitle: "GET·POST·PUT·DELETE", icon: "paperplane.fill", category: .developer, color: "#6366F1", isBuiltIn: true, tags: ["HTTP"]),
        .init(id: "delta-force", title: "三角洲助手", subtitle: "今日密码·改枪码·交易行", icon: "scope", category: .utility, color: "#DC2626", isBuiltIn: true, tags: ["三角洲"]),
        .init(id: "more-2", title: "二维码生成", subtitle: "生成和扫描二维码", icon: "qrcode", category: .utility, color: "#8B5CF6", isBuiltIn: false, tags: ["即将推出"]),
        .init(id: "more-3", title: "图片压缩", subtitle: "批量压缩图片", icon: "photo.compress", category: .media, color: "#EF4444", isBuiltIn: false, tags: ["即将推出"]),
        .init(id: "more-4", title: "IP 工具", subtitle: "网络诊断·IP查询", icon: "wifi.square.fill", category: .network, color: "#06B6D4", isBuiltIn: false, tags: ["即将推出"]),
    ]
}
