import SwiftUI
import Combine

// MARK: - 调色板 ViewModel
@MainActor
class ColorPaletteViewModel: ObservableObject {
    @Published var selectedColor: PaletteColor = PaletteColor.presets[0]
    @Published var savedColors: [PaletteColor] = []
    @Published var selectedHarmony: ColorHarmonyType = .complementary
    @Published var showColorPicker = false
    @Published var customRed: Double = 0.5
    @Published var customGreen: Double = 0.5
    @Published var customBlue: Double = 0.5
    @Published var customOpacity: Double = 1.0

    private let saveKey = "saved_palette_colors"

    init() {
        loadSavedColors()
    }

    // MARK: - 预设颜色选择
    func selectPreset(_ color: PaletteColor) {
        selectedColor = color
        updateCustomSliders(from: color)
        Haptic.selection()
    }

    // MARK: - 自定义颜色更新
    func updateCustomColor() {
        let hex = String(format: "#%02X%02X%02X",
            Int(customRed * 255), Int(customGreen * 255), Int(customBlue * 255))
        selectedColor = PaletteColor(
            name: "自定义",
            hex: hex,
            red: customRed,
            green: customGreen,
            blue: customBlue,
            alpha: customOpacity
        )
    }

    // MARK: - 从预设更新滑块
    private func updateCustomSliders(from color: PaletteColor) {
        customRed = color.red
        customGreen = color.green
        customBlue = color.blue
        customOpacity = color.alpha
    }

    // MARK: - 保存颜色
    func saveCurrentColor() {
        var color = selectedColor
        if color.name == "自定义" || color.name.isEmpty {
            color = PaletteColor(
                name: "颜色 \(savedColors.count + 1)",
                hex: color.hex,
                red: color.red,
                green: color.green,
                blue: color.blue,
                alpha: color.alpha
            )
        }
        if !savedColors.contains(where: { $0.hex == color.hex }) {
            savedColors.insert(color, at: 0)
            saveColors()
            Haptic.success()
        }
    }

    // MARK: - 删除保存的颜色
    func deleteColor(_ color: PaletteColor) {
        savedColors.removeAll { $0.id == color.id }
        saveColors()
    }

    // MARK: - 复制颜色值
    func copyHex(_ color: PaletteColor) {
        UIPasteboard.general.string = color.hexString
        Haptic.success()
    }

    func copyRGB(_ color: PaletteColor) {
        UIPasteboard.general.string = color.rgbString
        Haptic.success()
    }

    // MARK: - 持久化存储
    private func saveColors() {
        if let data = try? JSONEncoder().encode(savedColors) {
            UserDefaults.standard.set(data, forKey: saveKey)
        }
    }

    private func loadSavedColors() {
        guard let data = UserDefaults.standard.data(forKey: saveKey),
              let colors = try? JSONDecoder().decode([PaletteColor].self, from: data) else {
            return
        }
        savedColors = colors
    }
}
