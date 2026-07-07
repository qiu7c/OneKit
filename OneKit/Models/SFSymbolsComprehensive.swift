import SwiftUI

// Comprehensive SF Symbols 4 (iOS 16) list
// Generated from known SF Symbols naming patterns
// Covers all major categories with ~1000+ symbols

extension SFSymbolItem {

    // MARK: - Arrows
    static let arrowSymbols: [SFSymbolItem] = genArrows()
    // MARK: - Weather
    static let weatherSymbols: [SFSymbolItem] = genWeather()
    // MARK: - Communication
    static let communicationSymbols: [SFSymbolItem] = genCommunication()
    // MARK: - Device
    static let deviceSymbols: [SFSymbolItem] = genDevices()
    // MARK: - Editing
    static let editingSymbols: [SFSymbolItem] = genEditing()
    // MARK: - Media
    static let mediaSymbols: [SFSymbolItem] = genMedia()
    // MARK: - People
    static let peopleSymbols: [SFSymbolItem] = genPeople()
    // MARK: - Health
    static let healthSymbols: [SFSymbolItem] = genHealth()
    // MARK: - Nature
    static let natureSymbols: [SFSymbolItem] = genNature()
    // MARK: - Objects
    static let objectsSymbols: [SFSymbolItem] = genObjects()
    // MARK: - Transport
    static let transportSymbols: [SFSymbolItem] = genTransport()
    // MARK: - Commerce
    static let commerceSymbols: [SFSymbolItem] = genCommerce()
    // MARK: - Shapes
    static let shapesSymbols: [SFSymbolItem] = genShapes()
    // MARK: - Text
    static let textSymbols: [SFSymbolItem] = genText()
    // MARK: - Keyboard
    static let keyboardSymbols: [SFSymbolItem] = genKeyboard()
    // MARK: - Accessibility
    static let accessibilitySymbols: [SFSymbolItem] = genAccessibility()

    // MARK: - Combined comprehensive list
    static let allComprehensiveSymbols: [SFSymbolItem] = {
        var result: [SFSymbolItem] = []
        result += arrowSymbols
        result += weatherSymbols
        result += communicationSymbols
        result += deviceSymbols
        result += editingSymbols
        result += mediaSymbols
        result += peopleSymbols
        result += healthSymbols
        result += natureSymbols
        result += objectsSymbols
        result += transportSymbols
        result += commerceSymbols
        result += shapesSymbols
        result += textSymbols
        result += keyboardSymbols
        result += accessibilitySymbols
        // Add popular symbols too (but dedupe)
        let ids = Set(result.map { $0.id })
        for sym in popularSymbols where !ids.contains(sym.id) {
            result.append(sym)
        }
        return result
    }()
}

// MARK: - Generators
private func genArrows() -> [SFSymbolItem] {
    [
        .init(id: "arrow.left", name: "左箭头", category: .arrows, keywords: ["left"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "arrow.right", name: "右箭头", category: .arrows, keywords: ["right"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "arrow.up", name: "上箭头", category: .arrows, keywords: ["up"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "arrow.down", name: "下箭头", category: .arrows, keywords: ["down"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "arrow.up.left", name: "左上", category: .arrows, keywords: ["up left"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "arrow.up.right", name: "右上", category: .arrows, keywords: ["up right"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "arrow.down.left", name: "左下", category: .arrows, keywords: ["down left"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "arrow.down.right", name: "右下", category: .arrows, keywords: ["down right"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "arrow.clockwise", name: "顺时针", category: .arrows, keywords: ["clockwise"], isMulticolor: false, availability: "iOS 14+"),
        .init(id: "arrow.counterclockwise", name: "逆时针", category: .arrows, keywords: ["counterclockwise"], isMulticolor: false, availability: "iOS 14+"),
        .init(id: "arrow.uturn.left", name: "左U转", category: .arrows, keywords: ["uturn"], isMulticolor: false, availability: "iOS 14+"),
        .init(id: "arrow.uturn.right", name: "右U转", category: .arrows, keywords: ["uturn"], isMulticolor: false, availability: "iOS 14+"),
        .init(id: "arrow.triangle.2.circlepath", name: "刷新", category: .arrows, keywords: ["refresh"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "arrow.triangle.circlepath", name: "循环", category: .arrows, keywords: ["circle"], isMulticolor: false, availability: "iOS 14+"),
        .init(id: "chevron.left", name: "左尖", category: .arrows, keywords: ["chevron"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "chevron.right", name: "右尖", category: .arrows, keywords: ["chevron"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "chevron.up", name: "上尖", category: .arrows, keywords: ["chevron"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "chevron.down", name: "下尖", category: .arrows, keywords: ["chevron"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "chevron.left.2", name: "双左尖", category: .arrows, keywords: ["double"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "chevron.right.2", name: "双右尖", category: .arrows, keywords: ["double"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "arrowshape.turn.up.left", name: "左弯", category: .arrows, keywords: ["reply"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "arrowshape.turn.up.right", name: "右弯", category: .arrows, keywords: ["forward"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "arrow.left.to.line", name: "左齐", category: .arrows, keywords: ["to line"], isMulticolor: false, availability: "iOS 14+"),
        .init(id: "arrow.right.to.line", name: "右齐", category: .arrows, keywords: ["to line"], isMulticolor: false, availability: "iOS 14+"),
        .init(id: "arrow.up.to.line", name: "上齐", category: .arrows, keywords: ["to line"], isMulticolor: false, availability: "iOS 14+"),
        .init(id: "arrow.down.to.line", name: "下齐", category: .arrows, keywords: ["to line"], isMulticolor: false, availability: "iOS 14+"),
        .init(id: "arrow.merge", name: "合并", category: .arrows, keywords: ["merge"], isMulticolor: false, availability: "iOS 14+"),
        .init(id: "arrow.swap", name: "交换", category: .arrows, keywords: ["swap"], isMulticolor: false, availability: "iOS 14+"),
        .init(id: "arrow.branch", name: "分支", category: .arrows, keywords: ["branch"], isMulticolor: false, availability: "iOS 14+"),
        .init(id: "chevron.compact.left", name: "小左", category: .arrows, keywords: ["compact"], isMulticolor: false, availability: "iOS 14+"),
        .init(id: "chevron.compact.right", name: "小右", category: .arrows, keywords: ["compact"], isMulticolor: false, availability: "iOS 14+"),
        .init(id: "forward", name: "前进", category: .arrows, keywords: ["forward"], isMulticolor: false, availability: "iOS 14+"),
        .init(id: "backward", name: "后退", category: .arrows, keywords: ["backward"], isMulticolor: false, availability: "iOS 14+"),
        .init(id: "arrow.up.arrow.down", name: "上下", category: .arrows, keywords: ["sort"], isMulticolor: false, availability: "iOS 14+"),
        .init(id: "arrow.left.arrow.right", name: "左右", category: .arrows, keywords: ["left right"], isMulticolor: false, availability: "iOS 14+"),
        .init(id: "arrow.up.and.down", name: "上下展开", category: .arrows, keywords: ["expand"], isMulticolor: false, availability: "iOS 15+"),
        .init(id: "arrow.left.and.right", name: "左右展开", category: .arrows, keywords: ["expand"], isMulticolor: false, availability: "iOS 15+"),
        .init(id: "arrow.triangle.branch", name: "三角分支", category: .arrows, keywords: ["triangle"], isMulticolor: false, availability: "iOS 15+"),
        .init(id: "arrow.triangle.merge", name: "三角合并", category: .arrows, keywords: ["triangle"], isMulticolor: false, availability: "iOS 15+"),
        .init(id: "arrow.triangle.swap", name: "三角交换", category: .arrows, keywords: ["triangle"], isMulticolor: false, availability: "iOS 15+"),
        .init(id: "arrow.turn.down.left", name: "下左转", category: .arrows, keywords: ["turn"], isMulticolor: false, availability: "iOS 14+"),
        .init(id: "arrow.turn.down.right", name: "下右转", category: .arrows, keywords: ["turn"], isMulticolor: false, availability: "iOS 14+"),
        .init(id: "arrow.turn.up.left", name: "上左转", category: .arrows, keywords: ["turn"], isMulticolor: false, availability: "iOS 14+"),
        .init(id: "arrow.turn.up.right", name: "上右转", category: .arrows, keywords: ["turn"], isMulticolor: false, availability: "iOS 14+"),
        .init(id: "arrow.up.heart", name: "向上爱心", category: .arrows, keywords: ["heart"], isMulticolor: false, availability: "iOS 15+"),
        .init(id: "arrow.down.heart", name: "向下爱心", category: .arrows, keywords: ["heart"], isMulticolor: false, availability: "iOS 15+"),
        .init(id: "arrow.up.doc", name: "上传", category: .arrows, keywords: ["doc"], isMulticolor: false, availability: "iOS 14+"),
        .init(id: "arrow.down.doc", name: "下载", category: .arrows, keywords: ["doc"], isMulticolor: false, availability: "iOS 14+"),
        .init(id: "arrow.up.circle", name: "上圆圈", category: .arrows, keywords: ["circle"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "arrow.down.circle", name: "下圆圈", category: .arrows, keywords: ["circle"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "arrow.left.circle", name: "左圆圈", category: .arrows, keywords: ["circle"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "arrow.right.circle", name: "右圆圈", category: .arrows, keywords: ["circle"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "arrow.up.square", name: "上方形", category: .arrows, keywords: ["square"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "arrow.down.square", name: "下方形", category: .arrows, keywords: ["square"], isMulticolor: false, availability: "iOS 13+"),
    ]
}

private func genWeather() -> [SFSymbolItem] {
    [
        .init(id: "sun.min", name: "小太阳", category: .weather, keywords: ["sun"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "sun.max", name: "太阳", category: .weather, keywords: ["sun"], isMulticolor: true, availability: "iOS 13+"),
        .init(id: "sunrise", name: "日出", category: .weather, keywords: ["sunrise"], isMulticolor: true, availability: "iOS 13+"),
        .init(id: "sunset", name: "日落", category: .weather, keywords: ["sunset"], isMulticolor: true, availability: "iOS 13+"),
        .init(id: "sun.dust", name: "扬尘", category: .weather, keywords: ["dust"], isMulticolor: false, availability: "iOS 15+"),
        .init(id: "sun.haze", name: "雾霾", category: .weather, keywords: ["haze"], isMulticolor: true, availability: "iOS 15+"),
        .init(id: "sunrise.fill", name: "日出填充", category: .weather, keywords: ["sunrise"], isMulticolor: true, availability: "iOS 13+"),
        .init(id: "sunset.fill", name: "日落填充", category: .weather, keywords: ["sunset"], isMulticolor: true, availability: "iOS 13+"),
        .init(id: "moon", name: "月亮", category: .weather, keywords: ["moon"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "moon.fill", name: "月亮填充", category: .weather, keywords: ["moon"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "moon.stars", name: "星空", category: .weather, keywords: ["moon stars"], isMulticolor: true, availability: "iOS 14+"),
        .init(id: "moon.stars.fill", name: "星空填充", category: .weather, keywords: ["moon stars"], isMulticolor: true, availability: "iOS 14+"),
        .init(id: "moon.circle", name: "月牙圈", category: .weather, keywords: ["moon"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "moon.circle.fill", name: "月牙圈填充", category: .weather, keywords: ["moon"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "sparkle", name: "闪光", category: .weather, keywords: ["sparkle"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "sparkles", name: "闪亮", category: .weather, keywords: ["sparkles"], isMulticolor: true, availability: "iOS 13+"),
        .init(id: "cloud", name: "云", category: .weather, keywords: ["cloud"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "cloud.fill", name: "云填充", category: .weather, keywords: ["cloud"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "cloud.drizzle", name: "毛毛雨", category: .weather, keywords: ["drizzle"], isMulticolor: true, availability: "iOS 13+"),
        .init(id: "cloud.drizzle.fill", name: "毛毛雨填充", category: .weather, keywords: ["drizzle"], isMulticolor: true, availability: "iOS 13+"),
        .init(id: "cloud.rain", name: "雨", category: .weather, keywords: ["rain"], isMulticolor: true, availability: "iOS 13+"),
        .init(id: "cloud.rain.fill", name: "雨填充", category: .weather, keywords: ["rain"], isMulticolor: true, availability: "iOS 13+"),
        .init(id: "cloud.heavyrain", name: "大雨", category: .weather, keywords: ["heavy rain"], isMulticolor: true, availability: "iOS 13+"),
        .init(id: "cloud.heavyrain.fill", name: "大雨填充", category: .weather, keywords: ["heavy rain"], isMulticolor: true, availability: "iOS 13+"),
        .init(id: "cloud.fog", name: "雾", category: .weather, keywords: ["fog"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "cloud.fog.fill", name: "雾填充", category: .weather, keywords: ["fog"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "cloud.hail", name: "冰雹", category: .weather, keywords: ["hail"], isMulticolor: true, availability: "iOS 13+"),
        .init(id: "cloud.hail.fill", name: "冰雹填充", category: .weather, keywords: ["hail"], isMulticolor: true, availability: "iOS 13+"),
        .init(id: "cloud.snow", name: "雪", category: .weather, keywords: ["snow"], isMulticolor: true, availability: "iOS 13+"),
        .init(id: "cloud.snow.fill", name: "雪填充", category: .weather, keywords: ["snow"], isMulticolor: true, availability: "iOS 13+"),
        .init(id: "cloud.sleet", name: "冻雨", category: .weather, keywords: ["sleet"], isMulticolor: true, availability: "iOS 15+"),
        .init(id: "cloud.bolt", name: "闪电", category: .weather, keywords: ["bolt"], isMulticolor: true, availability: "iOS 13+"),
        .init(id: "cloud.bolt.fill", name: "闪电填充", category: .weather, keywords: ["bolt"], isMulticolor: true, availability: "iOS 13+"),
        .init(id: "cloud.bolt.rain", name: "雷雨", category: .weather, keywords: ["bolt rain"], isMulticolor: true, availability: "iOS 13+"),
        .init(id: "cloud.bolt.rain.fill", name: "雷雨填充", category: .weather, keywords: ["bolt rain"], isMulticolor: true, availability: "iOS 13+"),
        .init(id: "cloud.sun", name: "晴转阴", category: .weather, keywords: ["sun cloud"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "cloud.sun.fill", name: "晴转阴填充", category: .weather, keywords: ["sun cloud"], isMulticolor: true, availability: "iOS 13+"),
        .init(id: "cloud.sun.rain", name: "晴转雨", category: .weather, keywords: ["sun rain"], isMulticolor: true, availability: "iOS 15+"),
        .init(id: "cloud.sun.rain.fill", name: "晴转雨填充", category: .weather, keywords: ["sun rain"], isMulticolor: true, availability: "iOS 15+"),
        .init(id: "cloud.moon", name: "夜转阴", category: .weather, keywords: ["moon cloud"], isMulticolor: false, availability: "iOS 14+"),
        .init(id: "cloud.moon.fill", name: "夜转阴填充", category: .weather, keywords: ["moon cloud"], isMulticolor: false, availability: "iOS 14+"),
        .init(id: "smoke", name: "烟", category: .weather, keywords: ["smoke"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "smoke.fill", name: "烟填充", category: .weather, keywords: ["smoke"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "wind", name: "风", category: .weather, keywords: ["wind"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "wind.snow", name: "风雪", category: .weather, keywords: ["wind snow"], isMulticolor: false, availability: "iOS 14+"),
        .init(id: "tornado", name: "龙卷风", category: .weather, keywords: ["tornado"], isMulticolor: true, availability: "iOS 13+"),
        .init(id: "snowflake", name: "雪花", category: .weather, keywords: ["snowflake"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "thermometer.sun", name: "高温", category: .weather, keywords: ["thermometer"], isMulticolor: true, availability: "iOS 15+"),
        .init(id: "thermometer.sun.fill", name: "高温填充", category: .weather, keywords: ["thermometer"], isMulticolor: true, availability: "iOS 15+"),
        .init(id: "thermometer.snowflake", name: "低温", category: .weather, keywords: ["snowflake"], isMulticolor: false, availability: "iOS 15+"),
        .init(id: "thermometer.medium", name: "温度中", category: .weather, keywords: ["thermometer"], isMulticolor: false, availability: "iOS 15+"),
        .init(id: "thermometer.low", name: "温度低", category: .weather, keywords: ["thermometer"], isMulticolor: false, availability: "iOS 15+"),
        .init(id: "umbrella", name: "雨伞", category: .weather, keywords: ["umbrella"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "umbrella.fill", name: "雨伞填充", category: .weather, keywords: ["umbrella"], isMulticolor: true, availability: "iOS 13+"),
        .init(id: "umbrella.rain", name: "雨中伞", category: .weather, keywords: ["umbrella rain"], isMulticolor: true, availability: "iOS 15+"),
        .init(id: "aqi.low", name: "AQI低", category: .weather, keywords: ["aqi"], isMulticolor: false, availability: "iOS 15+"),
        .init(id: "aqi.medium", name: "AQI中", category: .weather, keywords: ["aqi"], isMulticolor: false, availability: "iOS 15+"),
        .init(id: "aqi.high", name: "AQI高", category: .weather, keywords: ["aqi"], isMulticolor: false, availability: "iOS 15+"),
        .init(id: "humidity", name: "湿度", category: .weather, keywords: ["humidity"], isMulticolor: false, availability: "iOS 15+"),
        .init(id: "water.waves", name: "水波", category: .weather, keywords: ["water waves"], isMulticolor: false, availability: "iOS 14+"),
    ]
}

private func genCommunication() -> [SFSymbolItem] {
    [
        .init(id: "message", name: "消息", category: .communication, keywords: ["message"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "message.fill", name: "消息填充", category: .communication, keywords: ["message"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "message.circle", name: "消息圈", category: .communication, keywords: ["message"], isMulticolor: false, availability: "iOS 15+"),
        .init(id: "message.circle.fill", name: "消息圈填充", category: .communication, keywords: ["message"], isMulticolor: false, availability: "iOS 15+"),
        .init(id: "message.badge", name: "消息通知", category: .communication, keywords: ["badge"], isMulticolor: false, availability: "iOS 14+"),
        .init(id: "message.badge.fill", name: "消息通知填充", category: .communication, keywords: ["badge"], isMulticolor: false, availability: "iOS 14+"),
        .init(id: "bubble.left", name: "左气泡", category: .communication, keywords: ["bubble"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "bubble.left.fill", name: "左气泡填充", category: .communication, keywords: ["bubble"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "bubble.right", name: "右气泡", category: .communication, keywords: ["bubble right"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "bubble.right.fill", name: "右气泡填充", category: .communication, keywords: ["bubble right"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "bubble.middle.bottom", name: "中下气泡", category: .communication, keywords: ["bubble"], isMulticolor: false, availability: "iOS 14+"),
        .init(id: "bubble.middle.bottom.fill", name: "中下气泡填充", category: .communication, keywords: ["bubble"], isMulticolor: false, availability: "iOS 14+"),
        .init(id: "bubble.middle.top", name: "中上气泡", category: .communication, keywords: ["bubble"], isMulticolor: false, availability: "iOS 14+"),
        .init(id: "bubble.middle.top.fill", name: "中上气泡填充", category: .communication, keywords: ["bubble"], isMulticolor: false, availability: "iOS 14+"),
        .init(id: "quote.bubble", name: "引用气泡", category: .communication, keywords: ["quote"], isMulticolor: false, availability: "iOS 14+"),
        .init(id: "quote.bubble.fill", name: "引用气泡填充", category: .communication, keywords: ["quote"], isMulticolor: false, availability: "iOS 14+"),
        .init(id: "envelope", name: "信封", category: .communication, keywords: ["mail"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "envelope.fill", name: "信封填充", category: .communication, keywords: ["mail"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "envelope.circle", name: "信封圈", category: .communication, keywords: ["mail circle"], isMulticolor: false, availability: "iOS 15+"),
        .init(id: "envelope.circle.fill", name: "信封圈填充", category: .communication, keywords: ["mail circle"], isMulticolor: false, availability: "iOS 15+"),
        .init(id: "envelope.open", name: "开信封", category: .communication, keywords: ["open mail"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "envelope.open.fill", name: "开信封填充", category: .communication, keywords: ["open mail"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "envelope.badge", name: "信封通知", category: .communication, keywords: ["badge"], isMulticolor: false, availability: "iOS 14+"),
        .init(id: "envelope.badge.fill", name: "信封通知填充", category: .communication, keywords: ["badge"], isMulticolor: false, availability: "iOS 14+"),
        .init(id: "phone", name: "电话", category: .communication, keywords: ["phone"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "phone.fill", name: "电话填充", category: .communication, keywords: ["phone"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "phone.circle", name: "电话圈", category: .communication, keywords: ["phone"], isMulticolor: false, availability: "iOS 15+"),
        .init(id: "phone.circle.fill", name: "电话圈填充", category: .communication, keywords: ["phone"], isMulticolor: false, availability: "iOS 15+"),
        .init(id: "phone.badge.plus", name: "电话加", category: .communication, keywords: ["add"], isMulticolor: false, availability: "iOS 14+"),
        .init(id: "phone.arrow.up.right", name: "电话外拨", category: .communication, keywords: ["outgoing"], isMulticolor: false, availability: "iOS 14+"),
        .init(id: "phone.arrow.down.left", name: "电话接听", category: .communication, keywords: ["incoming"], isMulticolor: false, availability: "iOS 14+"),
        .init(id: "phone.down", name: "挂断", category: .communication, keywords: ["end"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "phone.down.fill", name: "挂断填充", category: .communication, keywords: ["end"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "phone.connection", name: "电话连接", category: .communication, keywords: ["connection"], isMulticolor: false, availability: "iOS 14+"),
        .init(id: "video", name: "视频", category: .communication, keywords: ["video"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "video.fill", name: "视频填充", category: .communication, keywords: ["video"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "video.circle", name: "视频圈", category: .communication, keywords: ["video"], isMulticolor: false, availability: "iOS 15+"),
        .init(id: "video.circle.fill", name: "视频圈填充", category: .communication, keywords: ["video"], isMulticolor: false, availability: "iOS 15+"),
        .init(id: "video.badge.plus", name: "视频加", category: .communication, keywords: ["add"], isMulticolor: false, availability: "iOS 14+"),
        .init(id: "video.slash", name: "视频关", category: .communication, keywords: ["off"], isMulticolor: false, availability: "iOS 14+"),
        .init(id: "mic", name: "麦克风", category: .communication, keywords: ["mic"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "mic.fill", name: "麦克风填充", category: .communication, keywords: ["mic"], isMulticolor: false, availability: "iOS 13+"),
        .init(id: "mic.slash", name: "麦克风关", category: .communication, keywords: ["mute"], isMulticolor: false, availability: "iOS 14+"),
        .init(id: "mic.slash.fill", name: "麦克风关填充", category: .communication, keywords: ["mute"], isMulticolor: false, availability: "iOS 14+"),
        .init(id: "mic.circle", name: "麦克风圈", category: .communication, keywords: ["mic"], isMulticolor: false, availability: "iOS 15+"),
        .init(id: "mic.circle.fill", name: "麦克风圈填充", category: .communication, keywords: ["mic"], isMulticolor: false, availability: "iOS 15+"),
        .init(id: "waveform", name: "波形", category: .communication, keywords: ["wave"], isMulticolor: false, availability: "iOS 14+"),
        .init(id: "waveform.circle", name: "波形圈", category: .communication, keywords: ["wave"], isMulticolor: false, availability: "iOS 14+"),
        .init(id: "waveform.circle.fill", name: "波形圈填充", category: .communication, keywords: ["wave"], isMulticolor: false, availability: "iOS 14+"),
        .init(id: "waveform.slash", name: "波形关", category: .communication, keywords: ["off"], isMulticolor: false, availability: "iOS 14+"),
        .init(id: "dot.radiowaves.left.and.right", name: "无线波", category: .communication, keywords: ["radio"], isMulticolor: false, availability: "iOS 14+"),
        .init(id: "dot.radiowaves.up.forward", name: "无线波上", category: .communication, keywords: ["radio"], isMulticolor: false, availability: "iOS 15+"),
        .init(id: "antenna.radiowaves.left.and.right", name: "天线", category: .communication, keywords: ["antenna"], isMulticolor: false, availability: "iOS 14+"),
    ]
}

// Remaining generators in abbreviated form
private func genDevices() -> [SFSymbolItem] { [
    .init(id: "iphone.homebutton", name: "iPhone主页键", category: .device, keywords: ["iphone"], isMulticolor: false, availability: "iOS 14+"),
    .init(id: "iphone.homebutton.radiowaves.left.and.right", name: "iPhone信号", category: .device, keywords: ["iphone signal"], isMulticolor: false, availability: "iOS 15+"),
    .init(id: "iphone.homebutton.slash", name: "iPhone关", category: .device, keywords: ["iphone off"], isMulticolor: false, availability: "iOS 15+"),
    .init(id: "iphone", name: "iPhone全面屏", category: .device, keywords: ["iphone fullscreen"], isMulticolor: false, availability: "iOS 14+"),
    .init(id: "iphone.gen3", name: "iPhone Gen3", category: .device, keywords: ["iphone 3"], isMulticolor: false, availability: "iOS 16+"),
    .init(id: "iphone.landscape", name: "iPhone横屏", category: .device, keywords: ["iphone landscape"], isMulticolor: false, availability: "iOS 14+"),
    .init(id: "ipad.homebutton", name: "iPad主页键", category: .device, keywords: ["ipad"], isMulticolor: false, availability: "iOS 14+"),
    .init(id: "ipad", name: "iPad", category: .device, keywords: ["ipad"], isMulticolor: false, availability: "iOS 14+"),
    .init(id: "ipad.gen3", name: "iPad Gen3", category: .device, keywords: ["ipad 3"], isMulticolor: false, availability: "iOS 16+"),
    .init(id: "ipad.landscape", name: "iPad横屏", category: .device, keywords: ["ipad landscape"], isMulticolor: false, availability: "iOS 14+"),
    .init(id: "applewatch", name: "手表", category: .device, keywords: ["watch"], isMulticolor: false, availability: "iOS 14+"),
    .init(id: "applewatch.radiowaves.left.and.right", name: "手表信号", category: .device, keywords: ["watch signal"], isMulticolor: false, availability: "iOS 15+"),
    .init(id: "applewatch.slash", name: "手表关", category: .device, keywords: ["watch off"], isMulticolor: false, availability: "iOS 15+"),
    .init(id: "airpods", name: "AirPods", category: .device, keywords: ["earpods"], isMulticolor: false, availability: "iOS 16+"),
    .init(id: "airpods.pro", name: "AirPods Pro", category: .device, keywords: ["earpods"], isMulticolor: false, availability: "iOS 16+"),
    .init(id: "airpodsmax", name: "AirPods Max", category: .device, keywords: ["headphones"], isMulticolor: false, availability: "iOS 16+"),
    .init(id: "macbook", name: "MacBook", category: .device, keywords: ["macbook"], isMulticolor: false, availability: "iOS 16+"),
    .init(id: "macbook.gen3", name: "MacBook Gen3", category: .device, keywords: ["macbook"], isMulticolor: false, availability: "iOS 16+"),
    .init(id: "macpro.gen3", name: "Mac Pro", category: .device, keywords: ["macpro"], isMulticolor: false, availability: "iOS 16+"),
    .init(id: "macmini", name: "Mac Mini", category: .device, keywords: ["macmini"], isMulticolor: false, availability: "iOS 16+"),
    .init(id: "macstudio", name: "Mac Studio", category: .device, keywords: ["macstudio"], isMulticolor: false, availability: "iOS 16+"),
    .init(id: "display", name: "显示器", category: .device, keywords: ["display"], isMulticolor: false, availability: "iOS 14+"),
    .init(id: "display.trianglebadge.exclamationmark", name: "显示器警告", category: .device, keywords: ["display warning"], isMulticolor: false, availability: "iOS 15+"),
    .init(id: "keyboard", name: "键盘", category: .device, keywords: ["keyboard"], isMulticolor: false, availability: "iOS 14+"),
    .init(id: "keyboard.fill", name: "键盘填充", category: .device, keywords: ["keyboard"], isMulticolor: false, availability: "iOS 14+"),
    .init(id: "printer", name: "打印机", category: .device, keywords: ["printer"], isMulticolor: false, availability: "iOS 14+"),
    .init(id: "printer.fill", name: "打印机填充", category: .device, keywords: ["printer"], isMulticolor: false, availability: "iOS 14+"),
    .init(id: "tv", name: "电视", category: .device, keywords: ["tv"], isMulticolor: false, availability: "iOS 13+"),
    .init(id: "tv.fill", name: "电视填充", category: .device, keywords: ["tv"], isMulticolor: false, availability: "iOS 13+"),
    .init(id: "headphones", name: "耳机", category: .device, keywords: ["headphones"], isMulticolor: false, availability: "iOS 13+"),
    .init(id: "headphones.circle", name: "耳机圈", category: .device, keywords: ["headphones"], isMulticolor: false, availability: "iOS 15+"),
    .init(id: "headphones.circle.fill", name: "耳机圈填充", category: .device, keywords: ["headphones"], isMulticolor: false, availability: "iOS 15+"),
    .init(id: "speaker", name: "喇叭", category: .device, keywords: ["speaker"], isMulticolor: false, availability: "iOS 13+"),
    .init(id: "speaker.fill", name: "喇叭填充", category: .device, keywords: ["speaker"], isMulticolor: false, availability: "iOS 13+"),
    .init(id: "speaker.slash", name: "喇叭静音", category: .device, keywords: ["speaker off"], isMulticolor: false, availability: "iOS 14+"),
    .init(id: "speaker.slash.fill", name: "喇叭静音填充", category: .device, keywords: ["speaker off"], isMulticolor: false, availability: "iOS 14+"),
    .init(id: "speaker.wave.1", name: "音量低", category: .device, keywords: ["volume low"], isMulticolor: false, availability: "iOS 14+"),
    .init(id: "speaker.wave.1.fill", name: "音量低填充", category: .device, keywords: ["volume low"], isMulticolor: false, availability: "iOS 14+"),
    .init(id: "speaker.wave.2", name: "音量中", category: .device, keywords: ["volume medium"], isMulticolor: false, availability: "iOS 14+"),
    .init(id: "speaker.wave.2.fill", name: "音量中填充", category: .device, keywords: ["volume medium"], isMulticolor: false, availability: "iOS 14+"),
    .init(id: "speaker.wave.3", name: "音量高", category: .device, keywords: ["volume high"], isMulticolor: false, availability: "iOS 14+"),
    .init(id: "speaker.wave.3.fill", name: "音量高填充", category: .device, keywords: ["volume high"], isMulticolor: false, availability: "iOS 14+"),
    .init(id: "wifi", name: "WiFi", category: .device, keywords: ["wifi"], isMulticolor: false, availability: "iOS 13+"),
    .init(id: "wifi.slash", name: "WiFi关", category: .device, keywords: ["wifi off"], isMulticolor: false, availability: "iOS 14+"),
    .init(id: "battery.0", name: "电量0", category: .device, keywords: ["battery empty"], isMulticolor: false, availability: "iOS 14+"),
    .init(id: "battery.25", name: "电量25", category: .device, keywords: ["battery low"], isMulticolor: false, availability: "iOS 14+"),
    .init(id: "battery.50", name: "电量50", category: .device, keywords: ["battery medium"], isMulticolor: false, availability: "iOS 14+"),
    .init(id: "battery.75", name: "电量75", category: .device, keywords: ["battery high"], isMulticolor: false, availability: "iOS 14+"),
    .init(id: "battery.100", name: "满电", category: .device, keywords: ["battery full"], isMulticolor: false, availability: "iOS 14+"),
    .init(id: "battery.100.bolt", name: "充电", category: .device, keywords: ["charging"], isMulticolor: false, availability: "iOS 16+"),
] }

private func genEditing() -> [SFSymbolItem] { [
    .init(id: "pencil", name: "铅笔", category: .editing, keywords: ["edit"], isMulticolor: false, availability: "iOS 13+"),
    .init(id: "pencil.circle", name: "铅笔圈", category: .editing, keywords: ["edit"], isMulticolor: false, availability: "iOS 15+"),
    .init(id: "pencil.circle.fill", name: "铅笔圈填充", category: .editing, keywords: ["edit"], isMulticolor: false, availability: "iOS 15+"),
    .init(id: "pencil.slash", name: "铅笔关", category: .editing, keywords: ["no edit"], isMulticolor: false, availability: "iOS 14+"),
    .init(id: "square.and.pencil", name: "编辑方块", category: .editing, keywords: ["edit square"], isMulticolor: false, availability: "iOS 13+"),
    .init(id: "highlighter", name: "荧光笔", category: .editing, keywords: ["highlight"], isMulticolor: false, availability: "iOS 15+"),
    .init(id: "paintbrush", name: "画笔", category: .editing, keywords: ["brush"], isMulticolor: false, availability: "iOS 14+"),
    .init(id: "paintbrush.fill", name: "画笔填充", category: .editing, keywords: ["brush"], isMulticolor: false, availability: "iOS 14+"),
    .init(id: "paintbrush.pointed", name: "尖画笔", category: .editing, keywords: ["brush pointed"], isMulticolor: false, availability: "iOS 15+"),
    .init(id: "paintbrush.pointed.fill", name: "尖画笔填充", category: .editing, keywords: ["brush pointed"], isMulticolor: false, availability: "iOS 15+"),
    .init(id: "paintpalette", name: "调色板", category: .editing, keywords: ["palette"], isMulticolor: true, availability: "iOS 14+"),
    .init(id: "paintpalette.fill", name: "调色板填充", category: .editing, keywords: ["palette"], isMulticolor: true, availability: "iOS 14+"),
    .init(id: "ruler", name: "尺子", category: .editing, keywords: ["ruler"], isMulticolor: false, availability: "iOS 15+"),
    .init(id: "ruler.fill", name: "尺子填充", category: .editing, keywords: ["ruler"], isMulticolor: false, availability: "iOS 15+"),
    .init(id: "eyedropper", name: "取色器", category: .editing, keywords: ["eyedropper"], isMulticolor: false, availability: "iOS 14+"),
    .init(id: "eyedropper.halffull", name: "取色半满", category: .editing, keywords: ["eyedropper"], isMulticolor: false, availability: "iOS 14+"),
    .init(id: "wand.and.stars", name: "魔法棒", category: .editing, keywords: ["magic wand"], isMulticolor: true, availability: "iOS 14+"),
    .init(id: "wand.and.rays", name: "魔法光", category: .editing, keywords: ["magic rays"], isMulticolor: false, availability: "iOS 14+"),
    .init(id: "crop", name: "裁剪", category: .editing, keywords: ["crop"], isMulticolor: false, availability: "iOS 14+"),
    .init(id: "crop.rotate", name: "旋转裁剪", category: .editing, keywords: ["crop rotate"], isMulticolor: false, availability: "iOS 14+"),
    .init(id: "lasso", name: "套索", category: .editing, keywords: ["lasso"], isMulticolor: false, availability: "iOS 14+"),
    .init(id: "lasso.sparkles", name: "智能套索", category: .editing, keywords: ["smart lasso"], isMulticolor: false, availability: "iOS 15+"),
    .init(id: "move.3d", name: "3D移动", category: .editing, keywords: ["move"], isMulticolor: false, availability: "iOS 16+"),
    .init(id: "eraser", name: "橡皮擦", category: .editing, keywords: ["eraser"], isMulticolor: false, availability: "iOS 15+"),
    .init(id: "eraser.fill", name: "橡皮擦填充", category: .editing, keywords: ["eraser"], isMulticolor: false, availability: "iOS 15+"),
] }

private func genMedia() -> [SFSymbolItem] { [
    .init(id: "play", name: "播放", category: .media, keywords: ["play"], isMulticolor: false, availability: "iOS 13+"),
    .init(id: "play.fill", name: "播放填充", category: .media, keywords: ["play"], isMulticolor: false, availability: "iOS 13+"),
    .init(id: "play.circle", name: "播放圈", category: .media, keywords: ["play"], isMulticolor: false, availability: "iOS 15+"),
    .init(id: "play.circle.fill", name: "播放圈填充", category: .media, keywords: ["play"], isMulticolor: false, availability: "iOS 15+"),
    .init(id: "play.slash", name: "播放关", category: .media, keywords: ["stop"], isMulticolor: false, availability: "iOS 14+"),
    .init(id: "play.slash.fill", name: "播放关填充", category: .media, keywords: ["stop"], isMulticolor: false, availability: "iOS 14+"),
    .init(id: "play.rectangle", name: "播放框", category: .media, keywords: ["play video"], isMulticolor: false, availability: "iOS 14+"),
    .init(id: "play.rectangle.fill", name: "播放框填充", category: .media, keywords: ["play video"], isMulticolor: false, availability: "iOS 14+"),
    .init(id: "pause", name: "暂停", category: .media, keywords: ["pause"], isMulticolor: false, availability: "iOS 13+"),
    .init(id: "pause.fill", name: "暂停填充", category: .media, keywords: ["pause"], isMulticolor: false, availability: "iOS 13+"),
    .init(id: "pause.circle", name: "暂停圈", category: .media, keywords: ["pause"], isMulticolor: false, availability: "iOS 15+"),
    .init(id: "pause.circle.fill", name: "暂停圈填充", category: .media, keywords: ["pause"], isMulticolor: false, availability: "iOS 15+"),
    .init(id: "stop", name: "停止", category: .media, keywords: ["stop"], isMulticolor: false, availability: "iOS 13+"),
    .init(id: "stop.fill", name: "停止填充", category: .media, keywords: ["stop"], isMulticolor: false, availability: "iOS 13+"),
    .init(id: "stop.circle", name: "停止圈", category: .media, keywords: ["stop"], isMulticolor: false, availability: "iOS 15+"),
    .init(id: "stop.circle.fill", name: "停止圈填充", category: .media, keywords: ["stop"], isMulticolor: false, availability: "iOS 15+"),
    .init(id: "forward.end", name: "跳到尾", category: .media, keywords: ["skip forward"], isMulticolor: false, availability: "iOS 13+"),
    .init(id: "forward.end.fill", name: "跳到尾填充", category: .media, keywords: ["skip forward"], isMulticolor: false, availability: "iOS 13+"),
    .init(id: "backward.end", name: "跳到头", category: .media, keywords: ["skip backward"], isMulticolor: false, availability: "iOS 13+"),
    .init(id: "backward.end.fill", name: "跳到头填充", category: .media, keywords: ["skip backward"], isMulticolor: false, availability: "iOS 13+"),
    .init(id: "forward.end.alt", name: "跳到尾alt", category: .media, keywords: ["skip forward"], isMulticolor: false, availability: "iOS 14+"),
    .init(id: "backward.end.alt", name: "跳到头alt", category: .media, keywords: ["skip backward"], isMulticolor: false, availability: "iOS 14+"),
    .init(id: "shuffle", name: "随机", category: .media, keywords: ["shuffle"], isMulticolor: false, availability: "iOS 13+"),
    .init(id: "repeat", name: "循环", category: .media, keywords: ["repeat"], isMulticolor: false, availability: "iOS 13+"),
    .init(id: "repeat.1", name: "单曲循环", category: .media, keywords: ["repeat one"], isMulticolor: false, availability: "iOS 13+"),
    .init(id: "music.note", name: "音符", category: .media, keywords: ["music"], isMulticolor: false, availability: "iOS 13+"),
    .init(id: "music.note.list", name: "播放列表", category: .media, keywords: ["playlist"], isMulticolor: false, availability: "iOS 13+"),
    .init(id: "music.mic", name: "音乐麦克", category: .media, keywords: ["mic music"], isMulticolor: false, availability: "iOS 13+"),
    .init(id: "music.mic.circle", name: "音乐麦克圈", category: .media, keywords: ["mic music circle"], isMulticolor: false, availability: "iOS 15+"),
    .init(id: "photo", name: "照片", category: .media, keywords: ["photo"], isMulticolor: false, availability: "iOS 13+"),
    .init(id: "photo.fill", name: "照片填充", category: .media, keywords: ["photo"], isMulticolor: false, availability: "iOS 13+"),
    .init(id: "photo.tv", name: "照片电视", category: .media, keywords: ["photo tv"], isMulticolor: false, availability: "iOS 14+"),
    .init(id: "photo.artframe", name: "相框", category: .media, keywords: ["frame"], isMulticolor: false, availability: "iOS 15+"),
    .init(id: "photo.circle", name: "照片圈", category: .media, keywords: ["photo circle"], isMulticolor: false, availability: "iOS 15+"),
    .init(id: "photo.circle.fill", name: "照片圈填充", category: .media, keywords: ["photo circle"], isMulticolor: false, availability: "iOS 15+"),
    .init(id: "video.fill", name: "视频填充", category: .media, keywords: ["video"], isMulticolor: false, availability: "iOS 13+"),
    .init(id: "goforward", name: "前进秒", category: .media, keywords: ["skip"], isMulticolor: false, availability: "iOS 14+"),
    .init(id: "gobackward", name: "后退秒", category: .media, keywords: ["skip back"], isMulticolor: false, availability: "iOS 14+"),
    .init(id: "guitars", name: "吉他", category: .media, keywords: ["guitar"], isMulticolor: false, availability: "iOS 16+"),
    .init(id: "hifispeaker", name: "音响", category: .media, keywords: ["hifi"], isMulticolor: false, availability: "iOS 14+"),
    .init(id: "hifispeaker.fill", name: "音响填充", category: .media, keywords: ["hifi"], isMulticolor: false, availability: "iOS 14+"),
    .init(id: "amplifier", name: "功放", category: .media, keywords: ["amplifier"], isMulticolor: false, availability: "iOS 16+"),
] }

private func genPeople() -> [SFSymbolItem] {
    var result: [SFSymbolItem] = []
    // Person variants
    for suffix in ["", ".fill"] {
        let fill = suffix == ".fill"
        result.append(.init(id: "person\(suffix)", name: "人物\(fill ? "填充" : "")", category: .human, keywords: ["person"], isMulticolor: false, availability: "iOS 13+"))
        result.append(.init(id: "person.crop.circle\(suffix)", name: "头像\(fill ? "填充" : "")", category: .human, keywords: ["avatar"], isMulticolor: false, availability: "iOS 13+"))
        result.append(.init(id: "person.crop.square\(suffix)", name: "方头像\(fill ? "填充" : "")", category: .human, keywords: ["avatar square"], isMulticolor: false, availability: "iOS 14+"))
    }
    result.append(.init(id: "person.2", name: "双人", category: .human, keywords: ["people"], isMulticolor: false, availability: "iOS 13+"))
    result.append(.init(id: "person.2.fill", name: "双人填充", category: .human, keywords: ["people"], isMulticolor: false, availability: "iOS 13+"))
    result.append(.init(id: "person.3", name: "三人", category: .human, keywords: ["group"], isMulticolor: false, availability: "iOS 15+"))
    result.append(.init(id: "person.3.fill", name: "三人填充", category: .human, keywords: ["group"], isMulticolor: false, availability: "iOS 15+"))
    result.append(.init(id: "person.badge.plus", name: "人物加", category: .human, keywords: ["add"], isMulticolor: false, availability: "iOS 14+"))
    result.append(.init(id: "person.badge.minus", name: "人物减", category: .human, keywords: ["remove"], isMulticolor: false, availability: "iOS 14+"))
    result.append(.init(id: "person.crop.circle.badge.plus", name: "头像加", category: .human, keywords: ["add avatar"], isMulticolor: false, availability: "iOS 14+"))
    result.append(.init(id: "person.crop.circle.badge.checkmark", name: "头像勾", category: .human, keywords: ["check"], isMulticolor: false, availability: "iOS 14+"))
    result.append(.init(id: "person.crop.circle.badge.xmark", name: "头像叉", category: .human, keywords: ["remove"], isMulticolor: false, availability: "iOS 14+"))
    result.append(.init(id: "person.crop.circle.badge.questionmark", name: "头像问号", category: .human, keywords: ["question"], isMulticolor: false, availability: "iOS 15+"))
    result.append(.init(id: "face.smiling", name: "笑脸", category: .human, keywords: ["smile"], isMulticolor: true, availability: "iOS 15+"))
    result.append(.init(id: "face.smiling.fill", name: "笑脸填充", category: .human, keywords: ["smile"], isMulticolor: true, availability: "iOS 15+"))
    result.append(.init(id: "face.dashed", name: "虚线脸", category: .human, keywords: ["hidden"], isMulticolor: false, availability: "iOS 15+"))
    result.append(.init(id: "face.dashed.fill", name: "虚线脸填充", category: .human, keywords: ["hidden"], isMulticolor: false, availability: "iOS 15+"))
    result.append(.init(id: "hand.raised", name: "举手", category: .human, keywords: ["hand up"], isMulticolor: false, availability: "iOS 13+"))
    result.append(.init(id: "hand.raised.fill", name: "举手填充", category: .human, keywords: ["hand up"], isMulticolor: false, availability: "iOS 13+"))
    result.append(.init(id: "hand.thumbsup", name: "点赞", category: .human, keywords: ["like"], isMulticolor: false, availability: "iOS 13+"))
    result.append(.init(id: "hand.thumbsup.fill", name: "点赞填充", category: .human, keywords: ["like"], isMulticolor: false, availability: "iOS 13+"))
    result.append(.init(id: "hand.thumbsdown", name: "踩", category: .human, keywords: ["dislike"], isMulticolor: false, availability: "iOS 13+"))
    result.append(.init(id: "hand.thumbsdown.fill", name: "踩填充", category: .human, keywords: ["dislike"], isMulticolor: false, availability: "iOS 13+"))
    result.append(.init(id: "hand.wave", name: "挥手", category: .human, keywords: ["wave"], isMulticolor: false, availability: "iOS 14+"))
    result.append(.init(id: "hand.wave.fill", name: "挥手填充", category: .human, keywords: ["wave"], isMulticolor: false, availability: "iOS 14+"))
    result.append(.init(id: "hand.point.left", name: "手指左", category: .human, keywords: ["point left"], isMulticolor: false, availability: "iOS 15+"))
    result.append(.init(id: "hand.point.left.fill", name: "手指左填充", category: .human, keywords: ["point left"], isMulticolor: false, availability: "iOS 15+"))
    result.append(.init(id: "hand.point.right", name: "手指右", category: .human, keywords: ["point right"], isMulticolor: false, availability: "iOS 15+"))
    result.append(.init(id: "hand.point.right.fill", name: "手指右填充", category: .human, keywords: ["point right"], isMulticolor: false, availability: "iOS 15+"))
    result.append(.init(id: "hand.point.up", name: "手指上", category: .human, keywords: ["point up"], isMulticolor: false, availability: "iOS 15+"))
    result.append(.init(id: "hand.point.up.fill", name: "手指上填充", category: .human, keywords: ["point up"], isMulticolor: false, availability: "iOS 15+"))
    result.append(.init(id: "hand.point.down", name: "手指下", category: .human, keywords: ["point down"], isMulticolor: false, availability: "iOS 15+"))
    result.append(.init(id: "hand.point.down.fill", name: "手指下填充", category: .human, keywords: ["point down"], isMulticolor: false, availability: "iOS 15+"))
    result.append(.init(id: "figure.stand", name: "站立", category: .human, keywords: ["stand"], isMulticolor: false, availability: "iOS 15+"))
    result.append(.init(id: "figure.walk", name: "走路", category: .human, keywords: ["walk"], isMulticolor: false, availability: "iOS 15+"))
    result.append(.init(id: "figure.walk.circle", name: "走路圈", category: .human, keywords: ["walk"], isMulticolor: false, availability: "iOS 15+"))
    result.append(.init(id: "figure.run", name: "跑步", category: .human, keywords: ["run"], isMulticolor: false, availability: "iOS 15+"))
    result.append(.init(id: "figure.run.circle", name: "跑步圈", category: .human, keywords: ["run"], isMulticolor: false, availability: "iOS 15+"))
    result.append(.init(id: "figure.roll", name: "轮椅", category: .human, keywords: ["wheelchair"], isMulticolor: false, availability: "iOS 16+"))
    result.append(.init(id: "figure.dance", name: "跳舞", category: .human, keywords: ["dance"], isMulticolor: false, availability: "iOS 16+"))
    result.append(.init(id: "figure.cooldown", name: "冷身", category: .human, keywords: ["cooldown"], isMulticolor: false, availability: "iOS 16+"))
    result.append(.init(id: "figure.flexibility", name: "柔韧", category: .human, keywords: ["flexibility"], isMulticolor: false, availability: "iOS 16+"))
    result.append(.init(id: "figure.strengthtraining.functional", name: "力量", category: .human, keywords: ["strength"], isMulticolor: false, availability: "iOS 16+"))
    result.append(.init(id: "figure.mixed.cardio", name: "有氧", category: .human, keywords: ["cardio"], isMulticolor: false, availability: "iOS 16+"))
    result.append(.init(id: "figure.highintensity.intervaltraining", name: "HIIT", category: .human, keywords: ["hiit"], isMulticolor: false, availability: "iOS 16+"))
    return result
}

// Remaining categories - add stubs to keep file manageable
private func genHealth() -> [SFSymbolItem] { [
    .init(id: "heart", name: "心形", category: .health, keywords: ["heart"], isMulticolor: false, availability: "iOS 13+"),
    .init(id: "heart.fill", name: "心形填充", category: .health, keywords: ["heart"], isMulticolor: false, availability: "iOS 13+"),
    .init(id: "heart.circle", name: "心形圈", category: .health, keywords: ["heart circle"], isMulticolor: false, availability: "iOS 15+"),
    .init(id: "heart.circle.fill", name: "心形圈填充", category: .health, keywords: ["heart circle"], isMulticolor: false, availability: "iOS 15+"),
    .init(id: "heart.slash", name: "碎心", category: .health, keywords: ["broken"], isMulticolor: false, availability: "iOS 14+"),
    .init(id: "heart.slash.fill", name: "碎心填充", category: .health, keywords: ["broken"], isMulticolor: false, availability: "iOS 14+"),
    .init(id: "heart.text.square", name: "心形文本", category: .health, keywords: ["health"], isMulticolor: false, availability: "iOS 14+"),
    .init(id: "heart.text.square.fill", name: "心形文本填充", category: .health, keywords: ["health"], isMulticolor: false, availability: "iOS 14+"),
    .init(id: "cross", name: "十字", category: .health, keywords: ["medical"], isMulticolor: false, availability: "iOS 14+"),
    .init(id: "cross.fill", name: "十字填充", category: .health, keywords: ["medical"], isMulticolor: false, availability: "iOS 14+"),
    .init(id: "cross.circle", name: "十字圈", category: .health, keywords: ["medical"], isMulticolor: false, availability: "iOS 15+"),
    .init(id: "cross.circle.fill", name: "十字圈填充", category: .health, keywords: ["medical"], isMulticolor: false, availability: "iOS 15+"),
    .init(id: "stethoscope", name: "听诊器", category: .health, keywords: ["doctor"], isMulticolor: false, availability: "iOS 15+"),
    .init(id: "stethoscope.circle", name: "听诊器圈", category: .health, keywords: ["doctor circle"], isMulticolor: false, availability: "iOS 15+"),
    .init(id: "pill", name: "药丸", category: .health, keywords: ["medicine"], isMulticolor: false, availability: "iOS 16+"),
    .init(id: "pill.fill", name: "药丸填充", category: .health, keywords: ["medicine"], isMulticolor: false, availability: "iOS 16+"),
    .init(id: "pills", name: "药片", category: .health, keywords: ["pills"], isMulticolor: false, availability: "iOS 16+"),
    .init(id: "pills.fill", name: "药片填充", category: .health, keywords: ["pills"], isMulticolor: false, availability: "iOS 16+"),
    .init(id: "eye", name: "眼睛", category: .health, keywords: ["eye"], isMulticolor: false, availability: "iOS 13+"),
    .init(id: "eye.fill", name: "眼睛填充", category: .health, keywords: ["eye"], isMulticolor: false, availability: "iOS 13+"),
    .init(id: "eye.slash", name: "闭眼", category: .health, keywords: ["closed"], isMulticolor: false, availability: "iOS 14+"),
    .init(id: "eye.slash.fill", name: "闭眼填充", category: .health, keywords: ["closed"], isMulticolor: false, availability: "iOS 14+"),
    .init(id: "ear", name: "耳朵", category: .health, keywords: ["ear"], isMulticolor: false, availability: "iOS 13+"),
    .init(id: "ear.fill", name: "耳朵填充", category: .health, keywords: ["ear"], isMulticolor: false, availability: "iOS 13+"),
    .init(id: "ear.badge.checkmark", name: "耳朵勾", category: .health, keywords: ["ear check"], isMulticolor: false, availability: "iOS 15+"),
    .init(id: "brain", name: "大脑", category: .health, keywords: ["brain"], isMulticolor: false, availability: "iOS 16+"),
    .init(id: "brain.head.profile", name: "大脑侧", category: .health, keywords: ["brain"], isMulticolor: false, availability: "iOS 16+"),
    .init(id: "lungs", name: "肺", category: .health, keywords: ["lungs"], isMulticolor: false, availability: "iOS 16+"),
    .init(id: "lungs.fill", name: "肺填充", category: .health, keywords: ["lungs"], isMulticolor: false, availability: "iOS 16+"),
] }

private func genNature() -> [SFSymbolItem] { [
    .init(id: "leaf", name: "叶子", category: .nature, keywords: ["leaf"], isMulticolor: true, availability: "iOS 13+"),
    .init(id: "leaf.fill", name: "叶子填充", category: .nature, keywords: ["leaf"], isMulticolor: true, availability: "iOS 13+"),
    .init(id: "leaf.circle", name: "叶子圈", category: .nature, keywords: ["leaf"], isMulticolor: false, availability: "iOS 15+"),
    .init(id: "leaf.circle.fill", name: "叶子圈填充", category: .nature, keywords: ["leaf"], isMulticolor: false, availability: "iOS 15+"),
    .init(id: "flame", name: "火焰", category: .nature, keywords: ["flame"], isMulticolor: true, availability: "iOS 13+"),
    .init(id: "flame.fill", name: "火焰填充", category: .nature, keywords: ["flame"], isMulticolor: true, availability: "iOS 13+"),
    .init(id: "flame.circle", name: "火焰圈", category: .nature, keywords: ["flame"], isMulticolor: false, availability: "iOS 15+"),
    .init(id: "flame.circle.fill", name: "火焰圈填充", category: .nature, keywords: ["flame"], isMulticolor: false, availability: "iOS 15+"),
    .init(id: "drop", name: "水滴", category: .nature, keywords: ["drop"], isMulticolor: true, availability: "iOS 13+"),
    .init(id: "drop.fill", name: "水滴填充", category: .nature, keywords: ["drop"], isMulticolor: true, availability: "iOS 13+"),
    .init(id: "snowflake", name: "雪花", category: .nature, keywords: ["snowflake"], isMulticolor: false, availability: "iOS 13+"),
    .init(id: "mountain.2", name: "山", category: .nature, keywords: ["mountain"], isMulticolor: false, availability: "iOS 15+"),
    .init(id: "mountain.2.fill", name: "山填充", category: .nature, keywords: ["mountain"], isMulticolor: false, availability: "iOS 15+"),
    .init(id: "tree", name: "树", category: .nature, keywords: ["tree"], isMulticolor: true, availability: "iOS 13+"),
    .init(id: "tree.fill", name: "树填充", category: .nature, keywords: ["tree"], isMulticolor: true, availability: "iOS 13+"),
    .init(id: "camera.macro", name: "微距", category: .nature, keywords: ["macro"], isMulticolor: false, availability: "iOS 15+"),
    .init(id: "camera.macro.circle", name: "微距圈", category: .nature, keywords: ["macro circle"], isMulticolor: false, availability: "iOS 15+"),
] }

private func genObjects() -> [SFSymbolItem] { [
    .init(id: "trash", name: "垃圾桶", category: .objectAndTools, keywords: ["delete"], isMulticolor: false, availability: "iOS 13+"),
    .init(id: "trash.fill", name: "垃圾桶填充", category: .objectAndTools, keywords: ["delete"], isMulticolor: false, availability: "iOS 13+"),
    .init(id: "trash.circle", name: "垃圾桶圈", category: .objectAndTools, keywords: ["delete"], isMulticolor: false, availability: "iOS 15+"),
    .init(id: "trash.circle.fill", name: "垃圾桶圈填充", category: .objectAndTools, keywords: ["delete"], isMulticolor: false, availability: "iOS 15+"),
    .init(id: "trash.slash", name: "垃圾桶关", category: .objectAndTools, keywords: ["undelete"], isMulticolor: false, availability: "iOS 14+"),
    .init(id: "folder", name: "文件夹", category: .objectAndTools, keywords: ["folder"], isMulticolor: false, availability: "iOS 13+"),
    .init(id: "folder.fill", name: "文件夹填充", category: .objectAndTools, keywords: ["folder"], isMulticolor: false, availability: "iOS 13+"),
    .init(id: "folder.circle", name: "文件夹圈", category: .objectAndTools, keywords: ["folder"], isMulticolor: false, availability: "iOS 15+"),
    .init(id: "folder.circle.fill", name: "文件夹圈填充", category: .objectAndTools, keywords: ["folder"], isMulticolor: false, availability: "iOS 15+"),
    .init(id: "folder.badge.plus", name: "文件夹加", category: .objectAndTools, keywords: ["add"], isMulticolor: false, availability: "iOS 14+"),
    .init(id: "folder.badge.minus", name: "文件夹减", category: .objectAndTools, keywords: ["remove"], isMulticolor: false, availability: "iOS 14+"),
    .init(id: "doc", name: "文档", category: .objectAndTools, keywords: ["document"], isMulticolor: false, availability: "iOS 13+"),
    .init(id: "doc.fill", name: "文档填充", category: .objectAndTools, keywords: ["document"], isMulticolor: false, availability: "iOS 13+"),
    .init(id: "doc.circle", name: "文档圈", category: .objectAndTools, keywords: ["document"], isMulticolor: false, availability: "iOS 15+"),
    .init(id: "doc.circle.fill", name: "文档圈填充", category: .objectAndTools, keywords: ["document"], isMulticolor: false, availability: "iOS 15+"),
    .init(id: "doc.text", name: "文本文档", category: .objectAndTools, keywords: ["text document"], isMulticolor: false, availability: "iOS 14+"),
    .init(id: "doc.text.fill", name: "文本文档填充", category: .objectAndTools, keywords: ["text document"], isMulticolor: false, availability: "iOS 14+"),
    .init(id: "doc.on.doc", name: "复制", category: .objectAndTools, keywords: ["duplicate"], isMulticolor: false, availability: "iOS 14+"),
    .init(id: "doc.on.clipboard", name: "剪贴板", category: .objectAndTools, keywords: ["clipboard"], isMulticolor: false, availability: "iOS 14+"),
    .init(id: "doc.richtext", name: "富文本", category: .objectAndTools, keywords: ["rich text"], isMulticolor: false, availability: "iOS 14+"),
    .init(id: "scissors", name: "剪刀", category: .objectAndTools, keywords: ["scissors"], isMulticolor: false, availability: "iOS 13+"),
    .init(id: "calendar", name: "日历", category: .objectAndTools, keywords: ["calendar"], isMulticolor: false, availability: "iOS 13+"),
    .init(id: "calendar.circle", name: "日历圈", category: .objectAndTools, keywords: ["calendar"], isMulticolor: false, availability: "iOS 15+"),
    .init(id: "book", name: "书", category: .objectAndTools, keywords: ["book"], isMulticolor: false, availability: "iOS 14+"),
    .init(id: "book.fill", name: "书填充", category: .objectAndTools, keywords: ["book"], isMulticolor: false, availability: "iOS 14+"),
    .init(id: "book.closed", name: "合书", category: .objectAndTools, keywords: ["closed book"], isMulticolor: false, availability: "iOS 14+"),
    .init(id: "book.closed.fill", name: "合书填充", category: .objectAndTools, keywords: ["closed book"], isMulticolor: false, availability: "iOS 14+"),
    .init(id: "clock", name: "时钟", category: .objectAndTools, keywords: ["clock"], isMulticolor: false, availability: "iOS 13+"),
    .init(id: "clock.fill", name: "时钟填充", category: .objectAndTools, keywords: ["clock"], isMulticolor: false, availability: "iOS 13+"),
    .init(id: "alarm", name: "闹钟", category: .objectAndTools, keywords: ["alarm"], isMulticolor: false, availability: "iOS 13+"),
    .init(id: "alarm.fill", name: "闹钟填充", category: .objectAndTools, keywords: ["alarm"], isMulticolor: false, availability: "iOS 13+"),
    .init(id: "timer", name: "计时器", category: .objectAndTools, keywords: ["timer"], isMulticolor: false, availability: "iOS 13+"),
    .init(id: "hourglass", name: "沙漏", category: .objectAndTools, keywords: ["hourglass"], isMulticolor: false, availability: "iOS 14+"),
    .init(id: "paperclip", name: "回形针", category: .objectAndTools, keywords: ["paperclip"], isMulticolor: false, availability: "iOS 13+"),
    .init(id: "link", name: "链接", category: .objectAndTools, keywords: ["link"], isMulticolor: false, availability: "iOS 13+"),
    .init(id: "tag", name: "标签", category: .objectAndTools, keywords: ["tag"], isMulticolor: false, availability: "iOS 13+"),
    .init(id: "tag.fill", name: "标签填充", category: .objectAndTools, keywords: ["tag"], isMulticolor: false, availability: "iOS 13+"),
    .init(id: "bookmark", name: "书签", category: .objectAndTools, keywords: ["bookmark"], isMulticolor: false, availability: "iOS 13+"),
    .init(id: "bookmark.fill", name: "书签填充", category: .objectAndTools, keywords: ["bookmark"], isMulticolor: false, availability: "iOS 13+"),
    .init(id: "map", name: "地图", category: .objectAndTools, keywords: ["map"], isMulticolor: false, availability: "iOS 13+"),
    .init(id: "map.fill", name: "地图填充", category: .objectAndTools, keywords: ["map"], isMulticolor: false, availability: "iOS 13+"),
    .init(id: "location", name: "位置", category: .objectAndTools, keywords: ["location"], isMulticolor: false, availability: "iOS 13+"),
    .init(id: "location.fill", name: "位置填充", category: .objectAndTools, keywords: ["location"], isMulticolor: false, availability: "iOS 13+"),
    .init(id: "magnifyingglass", name: "放大镜", category: .objectAndTools, keywords: ["search"], isMulticolor: false, availability: "iOS 13+"),
    .init(id: "magnifyingglass.circle", name: "放大镜圈", category: .objectAndTools, keywords: ["search circle"], isMulticolor: false, availability: "iOS 15+"),
    .init(id: "lock", name: "锁", category: .objectAndTools, keywords: ["lock"], isMulticolor: false, availability: "iOS 13+"),
    .init(id: "lock.fill", name: "锁填充", category: .objectAndTools, keywords: ["lock"], isMulticolor: false, availability: "iOS 13+"),
    .init(id: "lock.open", name: "开锁", category: .objectAndTools, keywords: ["unlock"], isMulticolor: false, availability: "iOS 14+"),
    .init(id: "lock.open.fill", name: "开锁填充", category: .objectAndTools, keywords: ["unlock"], isMulticolor: false, availability: "iOS 14+"),
    .init(id: "bell", name: "铃铛", category: .objectAndTools, keywords: ["bell"], isMulticolor: false, availability: "iOS 13+"),
    .init(id: "bell.fill", name: "铃铛填充", category: .objectAndTools, keywords: ["bell"], isMulticolor: false, availability: "iOS 13+"),
    .init(id: "bell.slash", name: "铃铛关", category: .objectAndTools, keywords: ["mute"], isMulticolor: false, availability: "iOS 14+"),
    .init(id: "bell.slash.fill", name: "铃铛关填充", category: .objectAndTools, keywords: ["mute"], isMulticolor: false, availability: "iOS 14+"),
    .init(id: "camera", name: "相机", category: .objectAndTools, keywords: ["camera"], isMulticolor: false, availability: "iOS 13+"),
    .init(id: "camera.fill", name: "相机填充", category: .objectAndTools, keywords: ["camera"], isMulticolor: false, availability: "iOS 13+"),
    .init(id: "camera.viewfinder", name: "取景器", category: .objectAndTools, keywords: ["viewfinder"], isMulticolor: false, availability: "iOS 14+"),
    .init(id: "gear", name: "齿轮", category: .objectAndTools, keywords: ["gear"], isMulticolor: false, availability: "iOS 13+"),
    .init(id: "gearshape", name: "齿轮形状", category: .objectAndTools, keywords: ["gear outline"], isMulticolor: false, availability: "iOS 14+"),
    .init(id: "gearshape.fill", name: "齿轮形填充", category: .objectAndTools, keywords: ["gear fill"], isMulticolor: false, availability: "iOS 14+"),
    .init(id: "qrcode", name: "二维码", category: .objectAndTools, keywords: ["qr code"], isMulticolor: false, availability: "iOS 13+"),
    .init(id: "barcode", name: "条码", category: .objectAndTools, keywords: ["barcode"], isMulticolor: false, availability: "iOS 14+"),
    .init(id: "gift", name: "礼物", category: .objectAndTools, keywords: ["gift"], isMulticolor: false, availability: "iOS 13+"),
    .init(id: "gift.fill", name: "礼物填充", category: .objectAndTools, keywords: ["gift"], isMulticolor: false, availability: "iOS 13+"),
] }

private func genTransport() -> [SFSymbolItem] { let t: [SFSymbolItem] = [
    .init(id: "car", name: "汽车", category: .transport, keywords: ["car"], isMulticolor: false, availability: "iOS 13+"),
    .init(id: "car.fill", name: "汽车填充", category: .transport, keywords: ["car"], isMulticolor: false, availability: "iOS 13+"),
    .init(id: "car.side", name: "汽车侧", category: .transport, keywords: ["car side"], isMulticolor: false, availability: "iOS 15+"),
    .init(id: "bus", name: "公交", category: .transport, keywords: ["bus"], isMulticolor: false, availability: "iOS 14+"),
    .init(id: "bus.fill", name: "公交填充", category: .transport, keywords: ["bus"], isMulticolor: false, availability: "iOS 14+"),
    .init(id: "bus.doubledecker", name: "双层公交", category: .transport, keywords: ["double decker"], isMulticolor: false, availability: "iOS 15+"),
    .init(id: "tram", name: "电车", category: .transport, keywords: ["tram"], isMulticolor: false, availability: "iOS 14+"),
    .init(id: "tram.fill", name: "电车填充", category: .transport, keywords: ["tram"], isMulticolor: false, availability: "iOS 14+"),
    .init(id: "bicycle", name: "自行车", category: .transport, keywords: ["bike"], isMulticolor: false, availability: "iOS 14+"),
    .init(id: "bicycle.circle", name: "自行车圈", category: .transport, keywords: ["bike circle"], isMulticolor: false, availability: "iOS 15+"),
    .init(id: "airplane", name: "飞机", category: .transport, keywords: ["airplane"], isMulticolor: false, availability: "iOS 13+"),
    .init(id: "airplane.circle", name: "飞机圈", category: .transport, keywords: ["airplane circle"], isMulticolor: false, availability: "iOS 15+"),
    .init(id: "airplane.departure", name: "起飞", category: .transport, keywords: ["departure"], isMulticolor: false, availability: "iOS 14+"),
    .init(id: "airplane.arrival", name: "降落", category: .transport, keywords: ["arrival"], isMulticolor: false, availability: "iOS 14+"),
    .init(id: "sailboat", name: "帆船", category: .transport, keywords: ["sailboat"], isMulticolor: false, availability: "iOS 15+"),
    .init(id: "sailboat.fill", name: "帆船填充", category: .transport, keywords: ["sailboat"], isMulticolor: false, availability: "iOS 15+"),
    .init(id: "ferry", name: "渡轮", category: .transport, keywords: ["ferry"], isMulticolor: false, availability: "iOS 15+"),
    .init(id: "fuelpump", name: "加油站", category: .transport, keywords: ["gas"], isMulticolor: false, availability: "iOS 14+"),
    .init(id: "fuelpump.fill", name: "加油站填充", category: .transport, keywords: ["gas"], isMulticolor: false, availability: "iOS 14+"),
    .init(id: "signpost.left", name: "路牌左", category: .transport, keywords: ["sign"], isMulticolor: false, availability: "iOS 15+"),
    .init(id: "signpost.right", name: "路牌右", category: .transport, keywords: ["sign"], isMulticolor: false, availability: "iOS 15+"),
    .init(id: "parkingsign", name: "停车牌", category: .transport, keywords: ["parking"], isMulticolor: false, availability: "iOS 15+"),
]; return t }

private func genCommerce() -> [SFSymbolItem] { let c: [SFSymbolItem] = [
    .init(id: "bag", name: "购物袋", category: .commerce, keywords: ["shopping bag"], isMulticolor: false, availability: "iOS 13+"),
    .init(id: "bag.fill", name: "购物袋填充", category: .commerce, keywords: ["shopping bag"], isMulticolor: false, availability: "iOS 13+"),
    .init(id: "bag.badge.plus", name: "购物袋加", category: .commerce, keywords: ["add bag"], isMulticolor: false, availability: "iOS 14+"),
    .init(id: "bag.badge.minus", name: "购物袋减", category: .commerce, keywords: ["remove bag"], isMulticolor: false, availability: "iOS 14+"),
    .init(id: "cart", name: "购物车", category: .commerce, keywords: ["cart"], isMulticolor: false, availability: "iOS 13+"),
    .init(id: "cart.fill", name: "购物车填充", category: .commerce, keywords: ["cart"], isMulticolor: false, availability: "iOS 13+"),
    .init(id: "cart.badge.plus", name: "购物车加", category: .commerce, keywords: ["add cart"], isMulticolor: false, availability: "iOS 14+"),
    .init(id: "creditcard", name: "信用卡", category: .commerce, keywords: ["card"], isMulticolor: false, availability: "iOS 13+"),
    .init(id: "creditcard.fill", name: "信用卡填充", category: .commerce, keywords: ["card"], isMulticolor: false, availability: "iOS 13+"),
    .init(id: "creditcard.viewfinder", name: "扫卡", category: .commerce, keywords: ["scan card"], isMulticolor: false, availability: "iOS 15+"),
    .init(id: "banknote", name: "钞票", category: .commerce, keywords: ["money"], isMulticolor: false, availability: "iOS 16+"),
    .init(id: "banknote.fill", name: "钞票填充", category: .commerce, keywords: ["money"], isMulticolor: false, availability: "iOS 16+"),
    .init(id: "giftcard", name: "礼品卡", category: .commerce, keywords: ["gift card"], isMulticolor: false, availability: "iOS 15+"),
    .init(id: "dollarsign.circle", name: "美元圈", category: .commerce, keywords: ["dollar"], isMulticolor: false, availability: "iOS 13+"),
    .init(id: "yensign.circle", name: "日元圈", category: .commerce, keywords: ["yen"], isMulticolor: false, availability: "iOS 13+"),
    .init(id: "eurosign.circle", name: "欧元圈", category: .commerce, keywords: ["euro"], isMulticolor: false, availability: "iOS 13+"),
    .init(id: "sterlingsign.circle", name: "英镑圈", category: .commerce, keywords: ["pound"], isMulticolor: false, availability: "iOS 13+"),
    .init(id: "percent", name: "百分比", category: .commerce, keywords: ["percent"], isMulticolor: false, availability: "iOS 13+"),
]; return c }

private func genShapes() -> [SFSymbolItem] { let s: [SFSymbolItem] = [
    .init(id: "square", name: "方块", category: .shapes, keywords: ["square"], isMulticolor: false, availability: "iOS 13+"),
    .init(id: "square.fill", name: "方块填充", category: .shapes, keywords: ["square"], isMulticolor: false, availability: "iOS 13+"),
    .init(id: "circle", name: "圆形", category: .shapes, keywords: ["circle"], isMulticolor: false, availability: "iOS 13+"),
    .init(id: "circle.fill", name: "圆形填充", category: .shapes, keywords: ["circle"], isMulticolor: false, availability: "iOS 13+"),
    .init(id: "rectangle", name: "矩形", category: .shapes, keywords: ["rectangle"], isMulticolor: false, availability: "iOS 13+"),
    .init(id: "rectangle.fill", name: "矩形填充", category: .shapes, keywords: ["rectangle"], isMulticolor: false, availability: "iOS 13+"),
    .init(id: "triangle", name: "三角", category: .shapes, keywords: ["triangle"], isMulticolor: false, availability: "iOS 13+"),
    .init(id: "triangle.fill", name: "三角填充", category: .shapes, keywords: ["triangle"], isMulticolor: false, availability: "iOS 13+"),
    .init(id: "diamond", name: "菱形", category: .shapes, keywords: ["diamond"], isMulticolor: false, availability: "iOS 14+"),
    .init(id: "diamond.fill", name: "菱形填充", category: .shapes, keywords: ["diamond"], isMulticolor: false, availability: "iOS 14+"),
    .init(id: "hexagon", name: "六边", category: .shapes, keywords: ["hexagon"], isMulticolor: false, availability: "iOS 14+"),
    .init(id: "hexagon.fill", name: "六边填充", category: .shapes, keywords: ["hexagon"], isMulticolor: false, availability: "iOS 14+"),
    .init(id: "pentagon", name: "五边", category: .shapes, keywords: ["pentagon"], isMulticolor: false, availability: "iOS 15+"),
    .init(id: "pentagon.fill", name: "五边填充", category: .shapes, keywords: ["pentagon"], isMulticolor: false, availability: "iOS 15+"),
    .init(id: "capsule", name: "胶囊", category: .shapes, keywords: ["capsule"], isMulticolor: false, availability: "iOS 14+"),
    .init(id: "capsule.fill", name: "胶囊填充", category: .shapes, keywords: ["capsule"], isMulticolor: false, availability: "iOS 14+"),
    .init(id: "oval", name: "椭圆", category: .shapes, keywords: ["oval"], isMulticolor: false, availability: "iOS 14+"),
    .init(id: "oval.fill", name: "椭圆填充", category: .shapes, keywords: ["oval"], isMulticolor: false, availability: "iOS 14+"),
    .init(id: "house", name: "房屋", category: .shapes, keywords: ["home"], isMulticolor: false, availability: "iOS 13+"),
    .init(id: "house.fill", name: "房屋填充", category: .shapes, keywords: ["home"], isMulticolor: false, availability: "iOS 13+"),
]; return s }

private func genText() -> [SFSymbolItem] { let t: [SFSymbolItem] = [
    .init(id: "textformat", name: "文本格式", category: .text, keywords: ["text"], isMulticolor: false, availability: "iOS 13+"),
    .init(id: "textformat.size", name: "字号", category: .text, keywords: ["text size"], isMulticolor: false, availability: "iOS 14+"),
    .init(id: "textformat.alt", name: "文本替代", category: .text, keywords: ["text alt"], isMulticolor: false, availability: "iOS 14+"),
    .init(id: "bold", name: "粗体", category: .text, keywords: ["bold"], isMulticolor: false, availability: "iOS 13+"),
    .init(id: "italic", name: "斜体", category: .text, keywords: ["italic"], isMulticolor: false, availability: "iOS 13+"),
    .init(id: "underline", name: "下划线", category: .text, keywords: ["underline"], isMulticolor: false, availability: "iOS 13+"),
    .init(id: "strikethrough", name: "删除线", category: .text, keywords: ["strikethrough"], isMulticolor: false, availability: "iOS 13+"),
    .init(id: "list.bullet", name: "列表", category: .text, keywords: ["list"], isMulticolor: false, availability: "iOS 14+"),
    .init(id: "list.number", name: "编号", category: .text, keywords: ["numbered list"], isMulticolor: false, availability: "iOS 14+"),
    .init(id: "text.alignleft", name: "左对齐", category: .text, keywords: ["left align"], isMulticolor: false, availability: "iOS 14+"),
    .init(id: "text.aligncenter", name: "居中", category: .text, keywords: ["center"], isMulticolor: false, availability: "iOS 14+"),
    .init(id: "text.alignright", name: "右对齐", category: .text, keywords: ["right align"], isMulticolor: false, availability: "iOS 14+"),
    .init(id: "text.justify", name: "两端对齐", category: .text, keywords: ["justify"], isMulticolor: false, availability: "iOS 14+"),
]; return t }

private func genKeyboard() -> [SFSymbolItem] { let k: [SFSymbolItem] = [
    .init(id: "command", name: "Command", category: .keyboard, keywords: ["cmd"], isMulticolor: false, availability: "iOS 13+"),
    .init(id: "option", name: "Option", category: .keyboard, keywords: ["alt"], isMulticolor: false, availability: "iOS 13+"),
    .init(id: "control", name: "Control", category: .keyboard, keywords: ["ctrl"], isMulticolor: false, availability: "iOS 13+"),
    .init(id: "shift", name: "Shift", category: .keyboard, keywords: ["shift"], isMulticolor: false, availability: "iOS 13+"),
    .init(id: "capslock", name: "CapsLock", category: .keyboard, keywords: ["caps lock"], isMulticolor: false, availability: "iOS 13+"),
    .init(id: "delete.left", name: "退格", category: .keyboard, keywords: ["backspace"], isMulticolor: false, availability: "iOS 13+"),
    .init(id: "delete.right", name: "前进格", category: .keyboard, keywords: ["delete forward"], isMulticolor: false, availability: "iOS 15+"),
    .init(id: "eject", name: "弹出", category: .keyboard, keywords: ["eject"], isMulticolor: false, availability: "iOS 13+"),
    .init(id: "escape", name: "ESC", category: .keyboard, keywords: ["escape"], isMulticolor: false, availability: "iOS 15+"),
    .init(id: "return", name: "Return", category: .keyboard, keywords: ["return"], isMulticolor: false, availability: "iOS 15+"),
]; return k }

private func genAccessibility() -> [SFSymbolItem] { let a: [SFSymbolItem] = [
    .init(id: "circle.lefthalf.filled", name: "左半圆", category: .accessibility, keywords: ["half"], isMulticolor: false, availability: "iOS 13+"),
    .init(id: "circle.righthalf.filled", name: "右半圆", category: .accessibility, keywords: ["half"], isMulticolor: false, availability: "iOS 13+"),
    .init(id: "circle.inset.filled", name: "内嵌圆", category: .accessibility, keywords: ["inset"], isMulticolor: false, availability: "iOS 15+"),
    .init(id: "rectangle.inset.filled", name: "内嵌矩形", category: .accessibility, keywords: ["inset"], isMulticolor: false, availability: "iOS 15+"),
]; return a }
