import SwiftUI

// MARK: - 颜色模型
struct PaletteColor: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var hex: String
    var red: Double
    var green: Double
    var blue: Double
    var alpha: Double
    let createdAt: Date

    init(id: UUID = UUID(), name: String, hex: String, red: Double, green: Double, blue: Double, alpha: Double = 1.0, createdAt: Date = Date()) {
        self.id = id
        self.name = name
        self.hex = hex
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
        self.createdAt = createdAt
    }

    var color: Color {
        Color(red: red, green: green, blue: blue, opacity: alpha)
    }

    var uiColor: UIColor {
        UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }

    var hexString: String {
        let r = Int(red * 255)
        let g = Int(green * 255)
        let b = Int(blue * 255)
        return String(format: "#%02X%02X%02X", r, g, b)
    }

    var rgbString: String {
        "RGB(\(Int(red * 255)), \(Int(green * 255)), \(Int(blue * 255)))"
    }

    var hslString: String {
        let r = red, g = green, b = blue
        let maxVal = max(r, g, b), minVal = min(r, g, b)
        let l = (maxVal + minVal) / 2
        var h: Double = 0, s: Double = 0

        if maxVal != minVal {
            let d = maxVal - minVal
            s = l > 0.5 ? d / (2 - maxVal - minVal) : d / (maxVal + minVal)

            if maxVal == r { h = (g - b) / d + (g < b ? 6 : 0) }
            else if maxVal == g { h = (b - r) / d + 2 }
            else { h = (r - g) / d + 4 }
            h /= 6
        }

        return "HSL(\(Int(h * 360))°, \(Int(s * 100))%, \(Int(l * 100))%)"
    }

    // 亮度判断 (用于文字颜色)
    var isLight: Bool {
        let luminance = 0.299 * red + 0.587 * green + 0.114 * blue
        return luminance > 0.5
    }

    var textColor: Color {
        isLight ? .black : .white
    }
}

// MARK: - 色彩和谐类型
enum ColorHarmonyType: String, CaseIterable, Identifiable {
    case complementary = "互补色"
    case analogous = "类似色"
    case triadic = "三角色"
    case tetradic = "四角色"
    case splitComplementary = "分裂互补"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .complementary: return "circle.dashed"
        case .analogous: return "circle.hexagongrid"
        case .triadic: return "triangle"
        case .tetradic: return "square.on.square"
        case .splitComplementary: return "circle.dotted"
        }
    }

    func harmonies(for color: PaletteColor) -> [PaletteColor] {
        let hue = color.hue
        switch self {
        case .complementary:
            return [makeHarmony(hue: hue, offset: 0.5, name: "互补")]
        case .analogous:
            return [
                makeHarmony(hue: hue, offset: -0.08, name: "左类似"),
                makeHarmony(hue: hue, offset: 0.08, name: "右类似")
            ]
        case .triadic:
            return [
                makeHarmony(hue: hue, offset: 1/3, name: "三角一"),
                makeHarmony(hue: hue, offset: 2/3, name: "三角二")
            ]
        case .tetradic:
            return [
                makeHarmony(hue: hue, offset: 0.25, name: "四色一"),
                makeHarmony(hue: hue, offset: 0.5, name: "四色二"),
                makeHarmony(hue: hue, offset: 0.75, name: "四色三")
            ]
        case .splitComplementary:
            return [
                makeHarmony(hue: hue, offset: 0.5 - 0.15, name: "左分裂"),
                makeHarmony(hue: hue, offset: 0.5 + 0.15, name: "右分裂")
            ]
        }
    }

    private func makeHarmony(hue: Double, offset: Double, name: String) -> PaletteColor {
        var newHue = hue + offset
        if newHue > 1 { newHue -= 1 }
        if newHue < 0 { newHue += 1 }

        // Convert HSL back to RGB
        let (r, g, b) = hslToRgb(h: newHue, s: 0.7, l: 0.5)
        let hex = String(format: "#%02X%02X%02X", Int(r * 255), Int(g * 255), Int(b * 255))

        return PaletteColor(
            name: name,
            hex: hex,
            red: r,
            green: g,
            blue: b
        )
    }
}

// MARK: - HSL 转换
extension PaletteColor {
    var hue: Double {
        let r = red, g = green, b = blue
        let maxVal = max(r, g, b), minVal = min(r, g, b)
        let d = maxVal - minVal
        guard d != 0 else { return 0 }

        var h: Double = 0
        if maxVal == r { h = (g - b) / d + (g < b ? 6 : 0) }
        else if maxVal == g { h = (b - r) / d + 2 }
        else { h = (r - g) / d + 4 }
        h /= 6
        return h
    }

    var saturation: Double {
        let r = red, g = green, b = blue
        let maxVal = max(r, g, b), minVal = min(r, g, b)
        let l = (maxVal + minVal) / 2
        guard maxVal != minVal else { return 0 }
        return l > 0.5 ? (maxVal - minVal) / (2 - maxVal - minVal) : (maxVal - minVal) / (maxVal + minVal)
    }

    var lightness: Double {
        return (max(red, green, blue) + min(red, green, blue)) / 2
    }
}

// MARK: - HSL → RGB
func hslToRgb(h: Double, s: Double, l: Double) -> (Double, Double, Double) {
    if s == 0 { return (l, l, l) }

    let hue2rgb = { (p: Double, q: Double, t: Double) -> Double in
        var t = t
        if t < 0 { t += 1 }
        if t > 1 { t -= 1 }
        if t < 1/6 { return p + (q - p) * 6 * t }
        if t < 1/2 { return q }
        if t < 2/3 { return p + (q - p) * (2/3 - t) * 6 }
        return p
    }

    let q = l < 0.5 ? l * (1 + s) : l + s - l * s
    let p = 2 * l - q

    return (
        hue2rgb(p, q, h + 1/3),
        hue2rgb(p, q, h),
        hue2rgb(p, q, h - 1/3)
    )
}

// MARK: - 预置颜色
extension PaletteColor {
    static let presets: [PaletteColor] = [
        .init(name: "红色", hex: "#FF3B30", red: 1.0, green: 0.231, blue: 0.188),
        .init(name: "橙色", hex: "#FF9500", red: 1.0, green: 0.584, blue: 0.0),
        .init(name: "黄色", hex: "#FFCC00", red: 1.0, green: 0.8, blue: 0.0),
        .init(name: "绿色", hex: "#34C759", red: 0.204, green: 0.78, blue: 0.349),
        .init(name: "薄荷", hex: "#00C7BE", red: 0.0, green: 0.78, blue: 0.745),
        .init(name: "青色", hex: "#30B0C7", red: 0.188, green: 0.69, blue: 0.78),
        .init(name: "蓝色", hex: "#007AFF", red: 0.0, green: 0.478, blue: 1.0),
        .init(name: "紫色", hex: "#AF52DE", red: 0.686, green: 0.322, blue: 0.871),
        .init(name: "粉色", hex: "#FF2D55", red: 1.0, green: 0.176, blue: 0.333),
        .init(name: "深蓝", hex: "#5856D6", red: 0.345, green: 0.337, blue: 0.839),
        .init(name: "灰色", hex: "#8E8E93", red: 0.557, green: 0.557, blue: 0.576),
        .init(name: "深灰", hex: "#48484A", red: 0.282, green: 0.282, blue: 0.29),
        .init(name: "棕色", hex: "#A2845E", red: 0.635, green: 0.518, blue: 0.369),
        .init(name: "靛蓝", hex: "#4F46E5", red: 0.31, green: 0.275, blue: 0.898),
        .init(name: "玫红", hex: "#E11D48", red: 0.882, green: 0.114, blue: 0.282),
        .init(name: "琥珀", hex: "#F59E0B", red: 0.961, green: 0.62, blue: 0.043),
    ]
}
