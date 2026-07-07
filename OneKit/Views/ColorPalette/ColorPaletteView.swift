import SwiftUI

// MARK: - 调色板主页
struct ColorPaletteView: View {
    @StateObject private var viewModel = ColorPaletteViewModel()
    @State private var showCopied = false

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // 当前颜色大预览
                currentColorSection

                // 颜色信息
                colorInfoSection

                // 操作按钮
                actionButtonsSection

                // 自定义调色
                customColorSection

                // 预设色板
                presetSection

                // 色彩和谐
                ColorHarmoniesView(
                    color: viewModel.selectedColor,
                    selectedType: $viewModel.selectedHarmony
                )

                // 已保存颜色
                SavedColorsView(viewModel: viewModel)
            }
            .padding(20)
        }
        .background(Color.appBackground)
        .navigationTitle("调色板")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
    }

    // MARK: - 当前颜色预览
    private var currentColorSection: some View {
        VStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(viewModel.selectedColor.color)
                .frame(height: 120)
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .stroke(Color.appSeparator.opacity(0.3), lineWidth: 0.5)
                )
                .overlay {
                    Text(viewModel.selectedColor.hexString)
                        .font(.system(.title2, design: .monospaced))
                        .fontWeight(.bold)
                        .foregroundColor(viewModel.selectedColor.textColor)
                        .opacity(0.8)
                }
        }
    }

    // MARK: - 颜色信息
    private var colorInfoSection: some View {
        HStack(spacing: 12) {
            infoChip(title: "HEX", value: viewModel.selectedColor.hexString)
            infoChip(title: "RGB", value: viewModel.selectedColor.rgbString)
            infoChip(title: "HSL", value: viewModel.selectedColor.hslString)
        }
    }

    private func infoChip(title: String, value: String) -> some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.system(size: 9))
                .fontWeight(.semibold)
                .foregroundColor(.appTertiary)

            Text(value)
                .font(.system(size: 11, design: .monospaced))
                .foregroundColor(.appForeground)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
        }
        .frame(maxWidth: .infinity)
        .padding(10)
        .background(Color.appCard)
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
    }

    // MARK: - 操作按钮
    private var actionButtonsSection: some View {
        HStack(spacing: 10) {
            // 复制 HEX
            Button {
                viewModel.copyHex(viewModel.selectedColor)
                showCopied = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    showCopied = false
                }
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: showCopied ? "checkmark" : "doc.on.doc")
                    Text(showCopied ? "已复制" : "复制 HEX")
                }
                .font(.subheadline)
                .fontWeight(.medium)
                .frame(maxWidth: .infinity)
                .frame(height: 40)
                .foregroundColor(.white)
                .background(Color.appForeground)
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            }

            // 复制 RGB
            Button {
                viewModel.copyRGB(viewModel.selectedColor)
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "doc.on.doc")
                    Text("复制 RGB")
                }
                .font(.subheadline)
                .fontWeight(.medium)
                .frame(maxWidth: .infinity)
                .frame(height: 40)
                .foregroundColor(.appForeground)
                .background(Color.appCard)
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            }

            // 保存颜色
            Button {
                withAnimation { viewModel.saveCurrentColor() }
            } label: {
                Image(systemName: "heart")
                    .font(.body)
                    .foregroundColor(.appForeground)
                    .frame(width: 40, height: 40)
                    .background(Color.appCard)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            }
        }
    }

    // MARK: - 自定义调色
    private var customColorSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("自定义调色")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.appForeground)

            VStack(spacing: 10) {
                colorSlider(value: $viewModel.customRed, label: "红", color: .red)
                colorSlider(value: $viewModel.customGreen, label: "绿", color: .green)
                colorSlider(value: $viewModel.customBlue, label: "蓝", color: .blue)
                colorSlider(value: $viewModel.customOpacity, label: "透明度", color: .gray)
            }
            .onChange(of: viewModel.customRed) { _ in viewModel.updateCustomColor() }
            .onChange(of: viewModel.customGreen) { _ in viewModel.updateCustomColor() }
            .onChange(of: viewModel.customBlue) { _ in viewModel.updateCustomColor() }
            .onChange(of: viewModel.customOpacity) { _ in viewModel.updateCustomColor() }
        }
        .padding(16)
        .background(Color.appCard)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    private func colorSlider(value: Binding<Double>, label: String, color: Color) -> some View {
        VStack(spacing: 2) {
            HStack {
                Text(label)
                    .font(.caption)
                    .foregroundColor(.appSecondary)
                    .frame(width: 40, alignment: .leading)
                Slider(value: value, in: 0...1)
                    .tint(color)
                Text("\(Int(value.wrappedValue * 255))")
                    .font(.system(size: 11, design: .monospaced))
                    .foregroundColor(.appSecondary)
                    .frame(width: 36, alignment: .trailing)
            }
        }
    }

    // MARK: - 预设色板
    private var presetSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("预设颜色")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.appForeground)

            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 8), spacing: 8) {
                ForEach(PaletteColor.presets) { color in
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(color.color)
                        .frame(height: 40)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .stroke(Color.appSeparator.opacity(0.3), lineWidth: 0.5)
                        )
                        .overlay(
                            Image(systemName: "checkmark")
                                .font(.caption2)
                                .foregroundColor(color.textColor)
                                .opacity(viewModel.selectedColor.hex == color.hex ? 1 : 0)
                        )
                        .onTapGesture {
                            viewModel.selectPreset(color)
                        }
                }
            }
        }
    }
}
