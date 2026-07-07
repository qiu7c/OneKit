import SwiftUI

// MARK: - SF Symbols 分类
enum SFSymbolCategory: String, CaseIterable, Identifiable, Codable {
    case all = "全部"
    case communication = "通信"
    case weather = "天气"
    case objectAndTools = "物品与工具"
    case device = "设备"
    case editing = "编辑"
    case text = "文本格式"
    case health = "健康"
    case nature = "自然"
    case media = "媒体"
    case keyboard = "键盘"
    case commerce = "商业"
    case time = "时间"
    case human = "人物"
    case transport = "交通"
    case accessibility = "无障碍"
    case indices = "索引"
    case arrows = "箭头"
    case shapes = "形状"

    var id: String { rawValue }

    var symbolCount: Int {
        Self.symbolCounts[self] ?? 0
    }

    private static let symbolCounts: [SFSymbolCategory: Int] = [
        .all: 6000,
        .communication: 280, .weather: 120, .objectAndTools: 750,
        .device: 320, .editing: 180, .text: 150, .health: 90,
        .nature: 100, .media: 200, .keyboard: 40, .commerce: 100,
        .time: 50, .human: 120, .transport: 80, .accessibility: 40,
        .indices: 60, .arrows: 200, .shapes: 60
    ]
}

// MARK: - SF Symbols 条目
struct SFSymbolItem: Identifiable, Codable {
    let id: String        // SF Symbol 名称
    let name: String
    let category: SFSymbolCategory
    let keywords: [String]  // 搜索关键词
    let isMulticolor: Bool
    let availability: String  // "iOS 13+", "iOS 14+", "iOS 15+", "iOS 16+", "iOS 17+"

    // 渲染名称
    var systemName: String { id }

    // 可用性检查
    var isAvailableOnCurrentOS: Bool {
        // iOS 16+ 兼容，假设所有 symbol 可用
        true
    }
}

// MARK: - 热门常用 Symbol
extension SFSymbolItem {
    static let popularSymbols: [SFSymbolItem] = [
        .init(id: "star.fill", name: "星形填充", category: .shapes, keywords: ["star", "favorite", "星星", "收藏"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "heart.fill", name: "心形填充", category: .human, keywords: ["heart", "love", "喜欢", "爱心"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "bell.fill", name: "铃铛填充", category: .objectAndTools, keywords: ["bell", "notification", "通知", "提醒"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "gear", name: "齿轮", category: .objectAndTools, keywords: ["gear", "settings", "设置", "齿轮"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "magnifyingglass", name: "放大镜", category: .objectAndTools, keywords: ["search", "magnifying", "搜索", "查找"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "house.fill", name: "房屋填充", category: .shapes, keywords: ["home", "house", "首页", "房子"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "person.fill", name: "人物填充", category: .human, keywords: ["person", "user", "人物", "用户"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "envelope.fill", name: "信封填充", category: .communication, keywords: ["mail", "envelope", "邮件", "信封"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "clock.fill", name: "时钟填充", category: .time, keywords: ["clock", "time", "时间", "时钟"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "calendar", name: "日历", category: .time, keywords: ["calendar", "date", "日历", "日期"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "photo.fill", name: "照片填充", category: .media, keywords: ["photo", "image", "图片", "照片"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "camera.fill", name: "相机填充", category: .objectAndTools, keywords: ["camera", "photo", "相机", "拍照"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "message.fill", name: "消息填充", category: .communication, keywords: ["message", "chat", "消息", "聊天"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "phone.fill", name: "电话填充", category: .communication, keywords: ["phone", "call", "电话", "呼叫"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "cloud.fill", name: "云填充", category: .weather, keywords: ["cloud", "天气", "云"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "music.note", name: "音符", category: .media, keywords: ["music", "audio", "音乐", "音符"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "doc.fill", name: "文档填充", category: .objectAndTools, keywords: ["doc", "file", "文档", "文件"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "folder.fill", name: "文件夹填充", category: .objectAndTools, keywords: ["folder", "directory", "文件夹", "目录"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "trash.fill", name: "垃圾桶填充", category: .objectAndTools, keywords: ["trash", "delete", "删除", "垃圾桶"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "pencil", name: "铅笔", category: .editing, keywords: ["pencil", "edit", "编辑", "铅笔"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "bolt.fill", name: "闪电填充", category: .weather, keywords: ["bolt", "lightning", "闪电"], isMulticolor: true, availability: "iOS 13+"),
        .init(id: "moon.fill", name: "月亮填充", category: .weather, keywords: ["moon", "night", "月亮", "夜间"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "sun.max.fill", name: "太阳填充", category: .weather, keywords: ["sun", "brightness", "太阳", "亮度"], isMulticolor: true, availability: "iOS 13+"),
        .init(id: "wifi", name: "WiFi", category: .device, keywords: ["wifi", "network", "无线", "网络"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "battery.100.bolt", name: "电池充电", category: .device, keywords: ["battery", "power", "电池", "电量"], isMulticolor: false, availability: "iOS 16+"),
        .init(id: "iphone.gen3", name: "iPhone", category: .device, keywords: ["iphone", "phone", "手机"], isMulticolor: false, availability: "iOS 16+"),
        .init(id: "square.and.arrow.up", name: "分享", category: .shapes, keywords: ["share", "export", "分享", "导出"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "qrcode", name: "二维码", category: .shapes, keywords: ["qr", "qrcode", "二维码"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "face.smiling", name: "笑脸", category: .human, keywords: ["smile", "face", "表情", "笑脸"], isMulticolor: true, availability: "iOS 15+"),
        .init(id: "figure.run", name: "跑步", category: .human, keywords: ["run", "exercise", "跑步", "运动"], isMulticolor: false, availability: "iOS 15+"),
    ]
}
