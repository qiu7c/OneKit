import SwiftUI

// MARK: - 已保存颜色
struct SavedColorsView: View {
    @ObservedObject var viewModel: ColorPaletteViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("已保存")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.appForeground)

                Spacer()

                if !viewModel.savedColors.isEmpty {
                    Text("\(viewModel.savedColors.count) 个颜色")
                        .font(.caption)
                        .foregroundColor(.appSecondary)
                }
            }

            if viewModel.savedColors.isEmpty {
                HStack {
                    Spacer()
                    VStack(spacing: 6) {
                        Image(systemName: "heart")
                            .font(.title2)
                            .foregroundColor(.appTertiary)
                        Text("点击 ❤️ 保存颜色")
                            .font(.caption)
                            .foregroundColor(.appTertiary)
                    }
                    .padding(.vertical, 20)
                    Spacer()
                }
                .background(Color.appCard)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(viewModel.savedColors) { color in
                            savedColorCell(color)
                        }
                    }
                }
            }
        }
    }

    private func savedColorCell(_ color: PaletteColor) -> some View {
        VStack(spacing: 4) {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(color.color)
                .frame(width: 52, height: 52)
                .overlay(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .stroke(Color.appSeparator.opacity(0.3), lineWidth: 0.5)
                )
                .contextMenu {
                    Button { viewModel.copyHex(color) } label: {
                        Label("复制 Hex", systemImage: "doc.on.doc")
                    }
                    Button { viewModel.copyRGB(color) } label: {
                        Label("复制 RGB", systemImage: "doc.on.doc")
                    }
                    Divider()
                    Button(role: .destructive) {
                        withAnimation { viewModel.deleteColor(color) }
                    } label: {
                        Label("删除", systemImage: "trash")
                    }
                }
                .onTapGesture {
                    viewModel.selectPreset(color)
                }

            Text(color.name)
                .font(.system(size: 8))
                .foregroundColor(.appSecondary)
                .lineLimit(1)
                .frame(width: 52)

            Text(color.hexString)
                .font(.system(size: 6))
                .foregroundColor(.appTertiary)
                .lineLimit(1)
                .frame(width: 52)
        }
    }
}
