import SwiftUI

// MARK: - 色彩和谐视图
struct ColorHarmoniesView: View {
    let color: PaletteColor
    @Binding var selectedType: ColorHarmonyType

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("色彩和谐")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.appForeground)

            // 和谐类型选择
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 6) {
                    ForEach(ColorHarmonyType.allCases) { type in
                        Button {
                            selectedType = type
                            Haptic.light()
                        } label: {
                            HStack(spacing: 4) {
                                Image(systemName: type.icon)
                                    .font(.caption2)
                                Text(type.rawValue)
                                    .font(.caption)
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .foregroundColor(selectedType == type ? .white : .appForeground)
                            .background(selectedType == type ? Color.appForeground : Color.appCard)
                            .clipShape(Capsule())
                        }
                    }
                }
            }

            // 和谐色展示
            let harmonies = selectedType.harmonies(for: color)
            HStack(spacing: 10) {
                // 原始色
                harmonySwatch(color: color, label: "基础")

                Image(systemName: "arrow.right")
                    .font(.caption)
                    .foregroundColor(.appTertiary)

                ForEach(harmonies) { harmonyColor in
                    harmonySwatch(color: harmonyColor, label: harmonyColor.name)
                }
            }
        }
    }

    private func harmonySwatch(color: PaletteColor, label: String) -> some View {
        VStack(spacing: 4) {
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(color.color)
                .frame(width: 44, height: 44)
                .overlay(
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .stroke(Color.appSeparator.opacity(0.3), lineWidth: 0.5)
                )

            Text(label)
                .font(.caption2)
                .foregroundColor(.appSecondary)
                .lineLimit(1)

            Text(color.hexString)
                .font(.system(size: 7))
                .foregroundColor(.appTertiary)
                .lineLimit(1)
        }
        .frame(width: 56)
    }
}
