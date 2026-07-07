import SwiftUI

@MainActor
class ColorPaletteViewModel: ObservableObject {
    @Published var selectedColor: PaletteColor = PaletteColor.presets[0]
    @Published var savedColors: [PaletteColor] = []
    @Published var selectedHarmony: ColorHarmonyType = .complementary
    @Published var customRed: Double = 0.5
    @Published var customGreen: Double = 0.5
    @Published var customBlue: Double = 0.5
    @Published var customOpacity: Double = 1.0
    @Published var hexInput: String = "#4F46E5"

    private let saveKey = "saved_palette_colors"

    init() { loadSavedColors() }

    var currentColor: Color { Color(red: customRed, green: customGreen, blue: customBlue, opacity: customOpacity) }

    func selectPreset(_ color: PaletteColor) {
        selectedColor = color
        customRed = color.red; customGreen = color.green; customBlue = color.blue; customOpacity = color.alpha
        hexInput = color.hexString
        Haptic.selection()
    }

    func updateFromSliders() {
        selectedColor = PaletteColor(name: "自定义", hex: hexFromRGB(), red: customRed, green: customGreen, blue: customBlue, alpha: customOpacity)
        hexInput = selectedColor.hexString
    }

    func applyHexInput() {
        let hex = hexInput.trimmingCharacters(in: .whitespacesAndNewlines)
        guard hex.hasPrefix("#"), hex.count == 7, let rgb = Int(hex.dropFirst(), radix: 16) else { return }
        let r = Double((rgb >> 16) & 0xFF) / 255
        let g = Double((rgb >> 8) & 0xFF) / 255
        let b = Double(rgb & 0xFF) / 255
        customRed = r; customGreen = g; customBlue = b
        selectedColor = PaletteColor(name: "自定义", hex: hex, red: r, green: g, blue: b, alpha: customOpacity)
    }

    private func hexFromRGB() -> String { String(format: "#%02X%02X%02X", Int(customRed*255), Int(customGreen*255), Int(customBlue*255)) }

    func saveCurrentColor() {
        let c = PaletteColor(name: "颜色 \(savedColors.count + 1)", hex: selectedColor.hexString, red: selectedColor.red, green: selectedColor.green, blue: selectedColor.blue, alpha: selectedColor.alpha)
        if !savedColors.contains(where: { $0.hex == c.hex }) { savedColors.insert(c, at: 0); saveColors(); Haptic.success() }
    }

    func deleteColor(_ color: PaletteColor) { savedColors.removeAll { $0.id == color.id }; saveColors() }
    func copyHex(_ color: PaletteColor) { UIPasteboard.general.string = color.hexString; Haptic.success() }
    func copyRGB(_ color: PaletteColor) { UIPasteboard.general.string = color.rgbString; Haptic.success() }

    private func saveColors() { if let d = try? JSONEncoder().encode(savedColors) { UserDefaults.standard.set(d, forKey: saveKey) } }
    private func loadSavedColors() { guard let d = UserDefaults.standard.data(forKey: saveKey), let c = try? JSONDecoder().decode([PaletteColor].self, from: d) else { return }; savedColors = c }
}
