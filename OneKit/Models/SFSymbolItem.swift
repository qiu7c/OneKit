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

// MARK: - 热门常用 Symbol (扩充版)
extension SFSymbolItem {
    static let popularSymbols: [SFSymbolItem] = [

        // 通信
        .init(id: "message.fill", name: "消息", category: .communication, keywords: ["chat", "message", "消息", "聊天"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "bubble.left.fill", name: "气泡", category: .communication, keywords: ["chat", "bubble", "气泡", "聊天"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "bubble.right.fill", name: "右气泡", category: .communication, keywords: ["chat", "reply", "气泡", "回复"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "envelope.fill", name: "信封", category: .communication, keywords: ["mail", "envelope", "邮件", "信封"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "envelope.open.fill", name: "开信封", category: .communication, keywords: ["mail", "open", "邮件", "打开"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "phone.fill", name: "电话", category: .communication, keywords: ["phone", "call", "电话", "呼叫"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "video.fill", name: "视频", category: .communication, keywords: ["video", "facetime", "视频", "通话"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "mic.fill", name: "麦克风", category: .communication, keywords: ["mic", "microphone", "麦克风", "录音"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "mic.slash.fill", name: "麦克风关", category: .communication, keywords: ["mute", "mic off", "静音"], isMulticolor: false, availability: "iOS 13+"),

        // 天气
        .init(id: "sun.max.fill", name: "太阳", category: .weather, keywords: ["sun", "brightness", "太阳", "亮度"], isMulticolor: true, availability: "iOS 13+"),
        .init(id: "moon.fill", name: "月亮", category: .weather, keywords: ["moon", "night", "月亮", "夜间"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "star.fill", name: "星形", category: .weather, keywords: ["star", "favorite", "星星", "收藏"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "cloud.fill", name: "云", category: .weather, keywords: ["cloud", "天气", "云"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "cloud.rain.fill", name: "下雨", category: .weather, keywords: ["rain", "cloud", "下雨", "雨"], isMulticolor: true, availability: "iOS 13+"),
        .init(id: "cloud.bolt.fill", name: "雷雨", category: .weather, keywords: ["bolt", "lightning", "雷雨"], isMulticolor: true, availability: "iOS 13+"),
        .init(id: "cloud.snow.fill", name: "下雪", category: .weather, keywords: ["snow", "winter", "雪", "冬天"], isMulticolor: true, availability: "iOS 13+"),
        .init(id: "wind", name: "风", category: .weather, keywords: ["wind", "breeze", "风"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "thermometer.sun.fill", name: "温度计", category: .weather, keywords: ["temp", "thermometer", "温度"], isMulticolor: true, availability: "iOS 15+"),
        .init(id: "umbrella.fill", name: "雨伞", category: .weather, keywords: ["umbrella", "雨伞", "遮阳"], isMulticolor: true, availability: "iOS 13+"),

        // 物品与工具
        .init(id: "gear", name: "齿轮", category: .objectAndTools, keywords: ["gear", "settings", "设置", "齿轮"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "gearshape.fill", name: "齿轮形状", category: .objectAndTools, keywords: ["settings", "preferences", "设置", "偏好"], isMulticolor: false, availability: "iOS 14+"),
        .init(id: "magnifyingglass", name: "放大镜", category: .objectAndTools, keywords: ["search", "magnifying", "搜索", "查找"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "pencil", name: "铅笔", category: .objectAndTools, keywords: ["pencil", "edit", "编辑", "铅笔"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "trash.fill", name: "垃圾桶", category: .objectAndTools, keywords: ["trash", "delete", "删除", "垃圾桶"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "folder.fill", name: "文件夹", category: .objectAndTools, keywords: ["folder", "directory", "文件夹", "目录"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "doc.fill", name: "文档", category: .objectAndTools, keywords: ["doc", "file", "文档", "文件"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "doc.text.fill", name: "文本文档", category: .objectAndTools, keywords: ["text", "document", "文本", "文档"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "scissors", name: "剪刀", category: .objectAndTools, keywords: ["scissors", "cut", "剪刀", "剪裁"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "link", name: "链接", category: .objectAndTools, keywords: ["link", "url", "链接", "网址"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "key.fill", name: "钥匙", category: .objectAndTools, keywords: ["key", "password", "钥匙", "密码"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "lock.fill", name: "锁", category: .objectAndTools, keywords: ["lock", "secure", "锁", "安全"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "lock.open.fill", name: "开锁", category: .objectAndTools, keywords: ["unlock", "open", "开锁"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "bell.fill", name: "铃铛", category: .objectAndTools, keywords: ["bell", "notification", "通知", "提醒"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "bookmark.fill", name: "书签", category: .objectAndTools, keywords: ["bookmark", "save", "书签", "保存"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "tag.fill", name: "标签", category: .objectAndTools, keywords: ["tag", "label", "标签"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "flashlight.off.fill", name: "手电筒", category: .objectAndTools, keywords: ["flashlight", "torch", "手电筒"], isMulticolor: false, availability: "iOS 16+"),
        .init(id: "camera.fill", name: "相机", category: .objectAndTools, keywords: ["camera", "photo", "相机", "拍照"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "qrcode", name: "二维码", category: .objectAndTools, keywords: ["qr", "qrcode", "二维码"], isMulticolor: false, availability: "iOS 13+"),

        // 设备
        .init(id: "iphone.gen3", name: "iPhone", category: .device, keywords: ["iphone", "phone", "手机"], isMulticolor: false, availability: "iOS 16+"),
        .init(id: "ipad.gen3", name: "iPad", category: .device, keywords: ["ipad", "tablet", "平板"], isMulticolor: false, availability: "iOS 16+"),
        .init(id: "macbook.gen3", name: "MacBook", category: .device, keywords: ["macbook", "laptop", "笔记本"], isMulticolor: false, availability: "iOS 16+"),
        .init(id: "display", name: "显示器", category: .device, keywords: ["display", "monitor", "显示器", "屏幕"], isMulticolor: false, availability: "iOS 14+"),
        .init(id: "applewatch", name: "Apple Watch", category: .device, keywords: ["watch", "applewatch", "手表"], isMulticolor: false, availability: "iOS 14+"),
        .init(id: "airpods.pro", name: "AirPods", category: .device, keywords: ["airpods", "earpods", "耳机"], isMulticolor: false, availability: "iOS 16+"),
        .init(id: "keyboard", name: "键盘", category: .device, keywords: ["keyboard", "键入", "键盘"], isMulticolor: false, availability: "iOS 14+"),
        .init(id: "wifi", name: "WiFi", category: .device, keywords: ["wifi", "network", "无线", "网络"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "antenna.radiowaves.left.and.right", name: "信号", category: .device, keywords: ["signal", "cellular", "信号", "蜂窝"], isMulticolor: false, availability: "iOS 14+"),
        .init(id: "battery.100.bolt", name: "电池充电", category: .device, keywords: ["battery", "power", "电池", "电量"], isMulticolor: false, availability: "iOS 16+"),
        .init(id: "headphones", name: "耳机", category: .device, keywords: ["headphones", "audio", "耳机", "音频"], isMulticolor: false, availability: "iOS 13+"),

        // 编辑
        .init(id: "square.and.pencil", name: "编辑方块", category: .editing, keywords: ["edit", "write", "编辑", "书写"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "highlighter", name: "高亮笔", category: .editing, keywords: ["highlight", "marker", "高亮", "标记"], isMulticolor: false, availability: "iOS 15+"),
        .init(id: "paintbrush.fill", name: "画笔", category: .editing, keywords: ["paint", "brush", "画笔", "绘画"], isMulticolor: false, availability: "iOS 14+"),
        .init(id: "paintpalette.fill", name: "调色板", category: .editing, keywords: ["palette", "color", "调色板", "颜色"], isMulticolor: true, availability: "iOS 14+"),
        .init(id: "ruler.fill", name: "尺子", category: .editing, keywords: ["ruler", "measure", "尺子", "测量"], isMulticolor: false, availability: "iOS 15+"),
        .init(id: "eyedropper", name: "取色器", category: .editing, keywords: ["eyedropper", "picker", "取色", "拾色"], isMulticolor: false, availability: "iOS 14+"),
        .init(id: "wand.and.stars", name: "魔法棒", category: .editing, keywords: ["magic", "wand", "魔法", "特效"], isMulticolor: true, availability: "iOS 14+"),
        .init(id: "crop", name: "裁剪", category: .editing, keywords: ["crop", "trim", "裁剪"], isMulticolor: false, availability: "iOS 14+"),

        // 文本格式
        .init(id: "textformat", name: "文本格式", category: .text, keywords: ["text", "font", "文本", "字体"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "textformat.size", name: "字号", category: .text, keywords: ["size", "font size", "字号", "字体"], isMulticolor: false, availability: "iOS 14+"),
        .init(id: "bold", name: "粗体", category: .text, keywords: ["bold", "粗体"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "italic", name: "斜体", category: .text, keywords: ["italic", "斜体"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "underline", name: "下划线", category: .text, keywords: ["underline", "下划线"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "strikethrough", name: "删除线", category: .text, keywords: ["strikethrough", "删除线"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "list.bullet", name: "列表", category: .text, keywords: ["list", "bullet", "列表"], isMulticolor: false, availability: "iOS 14+"),
        .init(id: "text.alignleft", name: "左对齐", category: .text, keywords: ["align", "left", "左对齐"], isMulticolor: false, availability: "iOS 14+"),
        .init(id: "text.aligncenter", name: "居中", category: .text, keywords: ["align", "center", "居中"], isMulticolor: false, availability: "iOS 14+"),

        // 健康
        .init(id: "heart.fill", name: "心形", category: .health, keywords: ["heart", "love", "健康", "喜欢"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "heart.text.square.fill", name: "健康卡", category: .health, keywords: ["health", "medical", "健康", "医疗"], isMulticolor: false, availability: "iOS 14+"),
        .init(id: "stethoscope", name: "听诊器", category: .health, keywords: ["stethoscope", "doctor", "听诊器", "医生"], isMulticolor: false, availability: "iOS 15+"),
        .init(id: "pill.fill", name: "药丸", category: .health, keywords: ["pill", "medicine", "药", "药品"], isMulticolor: false, availability: "iOS 16+"),
        .init(id: "cross.fill", name: "十字", category: .health, keywords: ["medical", "cross", "医疗", "十字"], isMulticolor: false, availability: "iOS 14+"),
        .init(id: "waveform.path.ecg", name: "心电图", category: .health, keywords: ["ecg", "heart", "心电图", "心脏"], isMulticolor: false, availability: "iOS 14+"),

        // 自然
        .init(id: "leaf.fill", name: "叶子", category: .nature, keywords: ["leaf", "nature", "叶子", "自然"], isMulticolor: true, availability: "iOS 13+"),
        .init(id: "flame.fill", name: "火焰", category: .nature, keywords: ["fire", "flame", "火", "火焰"], isMulticolor: true, availability: "iOS 13+"),
        .init(id: "drop.fill", name: "水滴", category: .nature, keywords: ["drop", "water", "水滴", "水"], isMulticolor: true, availability: "iOS 13+"),
        .init(id: "snowflake", name: "雪花", category: .nature, keywords: ["snow", "flake", "雪", "雪花"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "mountain.2.fill", name: "山", category: .nature, keywords: ["mountain", "landscape", "山", "风景"], isMulticolor: false, availability: "iOS 15+"),
        .init(id: "tree.fill", name: "树", category: .nature, keywords: ["tree", "forest", "树", "森林"], isMulticolor: true, availability: "iOS 13+"),
        .init(id: "camera.macro", name: "微距", category: .nature, keywords: ["macro", "closeup", "微距"], isMulticolor: false, availability: "iOS 15+"),

        // 媒体
        .init(id: "play.fill", name: "播放", category: .media, keywords: ["play", "video", "播放", "视频"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "pause.fill", name: "暂停", category: .media, keywords: ["pause", "暂停"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "stop.fill", name: "停止", category: .media, keywords: ["stop", "停止"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "forward.fill", name: "快进", category: .media, keywords: ["forward", "快进"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "backward.fill", name: "后退", category: .media, keywords: ["backward", "rewind", "后退"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "music.note", name: "音符", category: .media, keywords: ["music", "audio", "音乐", "音符"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "music.mic", name: "麦克风音乐", category: .media, keywords: ["mic", "music", "唱歌"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "photo.fill", name: "照片", category: .media, keywords: ["photo", "image", "图片", "照片"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "video.fill", name: "视频媒体", category: .media, keywords: ["video", "movie", "视频", "电影"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "play.rectangle.fill", name: "播放框", category: .media, keywords: ["video", "movie", "播放", "视频"], isMulticolor: false, availability: "iOS 14+"),
        .init(id: "guitars", name: "吉他", category: .media, keywords: ["guitar", "music", "吉他", "音乐"], isMulticolor: false, availability: "iOS 16+"),

        // 人物
        .init(id: "person.fill", name: "人物", category: .human, keywords: ["person", "user", "人物", "用户"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "person.2.fill", name: "双人", category: .human, keywords: ["people", "group", "人", "群组"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "person.3.fill", name: "三人", category: .human, keywords: ["group", "team", "群组", "团队"], isMulticolor: false, availability: "iOS 15+"),
        .init(id: "person.crop.circle.fill", name: "头像", category: .human, keywords: ["avatar", "profile", "头像", "个人"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "face.smiling", name: "笑脸", category: .human, keywords: ["smile", "face", "表情", "笑脸"], isMulticolor: true, availability: "iOS 15+"),
        .init(id: "face.dashed", name: "虚线脸", category: .human, keywords: ["face", "hidden", "匿名"], isMulticolor: false, availability: "iOS 15+"),
        .init(id: "figure.run", name: "跑步", category: .human, keywords: ["run", "exercise", "跑步", "运动"], isMulticolor: false, availability: "iOS 15+"),
        .init(id: "figure.walk", name: "走路", category: .human, keywords: ["walk", "走路"], isMulticolor: false, availability: "iOS 15+"),
        .init(id: "hand.raised.fill", name: "举手", category: .human, keywords: ["hand", "raise", "举手"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "hand.thumbsup.fill", name: "点赞", category: .human, keywords: ["thumbs up", "like", "点赞", "喜欢"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "hand.thumbsdown.fill", name: "踩", category: .human, keywords: ["thumbs down", "不喜欢", "踩"], isMulticolor: false, availability: "iOS 13+"),

        // 交通
        .init(id: "car.fill", name: "汽车", category: .transport, keywords: ["car", "auto", "汽车"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "bus.fill", name: "公交", category: .transport, keywords: ["bus", "公交"], isMulticolor: false, availability: "iOS 14+"),
        .init(id: "airplane", name: "飞机", category: .transport, keywords: ["airplane", "flight", "飞机", "飞行"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "bicycle", name: "自行车", category: .transport, keywords: ["bike", "cycle", "自行车"], isMulticolor: false, availability: "iOS 14+"),
        .init(id: "sailboat.fill", name: "帆船", category: .transport, keywords: ["boat", "sail", "船", "帆"], isMulticolor: false, availability: "iOS 15+"),
        .init(id: "tram.fill", name: "电车", category: .transport, keywords: ["tram", "train", "电车"], isMulticolor: false, availability: "iOS 14+"),
        .init(id: "fuelpump.fill", name: "加油站", category: .transport, keywords: ["gas", "fuel", "加油站"], isMulticolor: false, availability: "iOS 14+"),
        .init(id: "map.fill", name: "地图", category: .transport, keywords: ["map", "导航", "地图"], isMulticolor: false, availability: "iOS 13+"),

        // 时间
        .init(id: "clock.fill", name: "时钟", category: .time, keywords: ["clock", "time", "时间", "时钟"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "alarm.fill", name: "闹钟", category: .time, keywords: ["alarm", "闹钟"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "timer", name: "计时器", category: .time, keywords: ["timer", "计时"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "calendar", name: "日历", category: .time, keywords: ["calendar", "date", "日历", "日期"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "hourglass", name: "沙漏", category: .time, keywords: ["hourglass", "time", "沙漏", "时间"], isMulticolor: false, availability: "iOS 14+"),

        // 箭头
        .init(id: "arrow.right", name: "右箭头", category: .arrows, keywords: ["arrow", "right", "箭头", "向右"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "arrow.left", name: "左箭头", category: .arrows, keywords: ["arrow", "left", "箭头", "向左"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "arrow.up", name: "上箭头", category: .arrows, keywords: ["arrow", "up", "箭头", "向上"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "arrow.down", name: "下箭头", category: .arrows, keywords: ["arrow", "down", "箭头", "向下"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "arrow.triangle.2.circlepath", name: "刷新", category: .arrows, keywords: ["refresh", "reload", "刷新", "重新"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "arrow.clockwise", name: "顺时针", category: .arrows, keywords: ["clockwise", "rotate", "旋转"], isMulticolor: false, availability: "iOS 14+"),
        .init(id: "arrow.counterclockwise", name: "逆时针", category: .arrows, keywords: ["counterclockwise", "rotate", "旋转"], isMulticolor: false, availability: "iOS 14+"),
        .init(id: "chevron.right", name: "右尖括号", category: .arrows, keywords: ["chevron", "right", "右箭头"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "chevron.left", name: "左尖括号", category: .arrows, keywords: ["chevron", "left", "左箭头"], isMulticolor: false, availability: "iOS 13+"),

        // 形状
        .init(id: "square.fill", name: "方块", category: .shapes, keywords: ["square", "方块"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "circle.fill", name: "圆形", category: .shapes, keywords: ["circle", "圆形"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "triangle.fill", name: "三角", category: .shapes, keywords: ["triangle", "三角"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "diamond.fill", name: "菱形", category: .shapes, keywords: ["diamond", "菱形"], isMulticolor: false, availability: "iOS 14+"),
        .init(id: "hexagon.fill", name: "六边形", category: .shapes, keywords: ["hexagon", "六边形"], isMulticolor: false, availability: "iOS 14+"),
        .init(id: "rectangle.fill", name: "矩形", category: .shapes, keywords: ["rectangle", "矩形"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "capsule.fill", name: "胶囊", category: .shapes, keywords: ["capsule", "胶囊"], isMulticolor: false, availability: "iOS 14+"),
        .init(id: "house.fill", name: "房屋", category: .shapes, keywords: ["home", "house", "首页", "房子"], isMulticolor: false, availability: "iOS 13+"),

        // 无障碍
        .init(id: "figure.roll", name: "轮椅", category: .accessibility, keywords: ["wheelchair", "accessibility", "轮椅", "无障碍"], isMulticolor: false, availability: "iOS 16+"),
        .init(id: "ear.fill", name: "耳朵", category: .accessibility, keywords: ["ear", "hearing", "耳朵", "听力"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "eye.fill", name: "眼睛", category: .accessibility, keywords: ["eye", "vision", "眼睛", "视力"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "eye.slash.fill", name: "闭眼", category: .accessibility, keywords: ["hidden", "invisible", "隐藏"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "speaker.wave.2.fill", name: "音量", category: .accessibility, keywords: ["speaker", "volume", "音量", "声音"], isMulticolor: false, availability: "iOS 14+"),
        .init(id: "speaker.slash.fill", name: "静音", category: .accessibility, keywords: ["mute", "silent", "静音"], isMulticolor: false, availability: "iOS 14+"),
        .init(id: "hand.point.up.fill", name: "手指上", category: .accessibility, keywords: ["point", "finger", "手指"], isMulticolor: false, availability: "iOS 15+"),

        // 商店
        .init(id: "cart.fill", name: "购物车", category: .commerce, keywords: ["cart", "shopping", "购物车", "购物"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "bag.fill", name: "购物袋", category: .commerce, keywords: ["bag", "shopping", "购物袋"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "creditcard.fill", name: "信用卡", category: .commerce, keywords: ["card", "payment", "信用卡", "支付"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "banknote.fill", name: "钞票", category: .commerce, keywords: ["money", "cash", "钱", "现金"], isMulticolor: false, availability: "iOS 16+"),
        .init(id: "gift.fill", name: "礼物", category: .commerce, keywords: ["gift", "present", "礼物"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "dollarsign.circle.fill", name: "美元", category: .commerce, keywords: ["dollar", "currency", "货币"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "percent", name: "百分比", category: .commerce, keywords: ["percent", "discount", "百分比", "折扣"], isMulticolor: false, availability: "iOS 13+"),

        // 键盘
        .init(id: "command", name: "Command", category: .keyboard, keywords: ["command", "cmd", "命令"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "option", name: "Option", category: .keyboard, keywords: ["option", "alt", "选项"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "control", name: "Control", category: .keyboard, keywords: ["control", "ctrl"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "shift", name: "Shift", category: .keyboard, keywords: ["shift", "大写"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "capslock", name: "CapsLock", category: .keyboard, keywords: ["caps lock", "大写锁定"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "delete.left.fill", name: "退格", category: .keyboard, keywords: ["delete", "backspace", "删除", "退格"], isMulticolor: false, availability: "iOS 14+"),
        .init(id: "escape", name: "ESC", category: .keyboard, keywords: ["escape", "esc"], isMulticolor: false, availability: "iOS 15+"),

        // 索引
        .init(id: "a.circle.fill", name: "A 圈", category: .indices, keywords: ["a", "letter", "字母"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "b.circle.fill", name: "B 圈", category: .indices, keywords: ["b", "letter", "字母"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "c.circle.fill", name: "C 圈", category: .indices, keywords: ["c", "letter", "字母"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "number.circle.fill", name: "数字", category: .indices, keywords: ["number", "hash", "数字"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "questionmark.circle.fill", name: "问号", category: .indices, keywords: ["question", "help", "问号", "帮助"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "exclamationmark.circle.fill", name: "感叹", category: .indices, keywords: ["exclamation", "alert", "感叹"], isMulticolor: false, availability: "iOS 13+"),
    ]
}

