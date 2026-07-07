import SwiftUI

// MARK: - Symbol 详情视图
struct SymbolDetailView: View {
    @Environment(\.dismiss) private var dismiss
    let symbol: SFSymbolItem
    @State private var scale: CGFloat = 1.0
    @State private var rotation: Angle = .zero
    @State private var showCopied = false
    @State private var showSaved = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Spacer()

                // 大图标预览
                Image(systemName: symbol.id)
                    .font(.system(size: 80))
                    .symbolRenderingMode(symbol.isMulticolor ? .multicolor : .monochrome)
                    .foregroundColor(.appForeground)
                    .scaleEffect(scale)
                    .rotationEffect(rotation)
                    .animation(.interpolatingSpring(mass: 1, stiffness: 100, damping: 10), value: scale)
                    .animation(.interpolatingSpring(mass: 1, stiffness: 100, damping: 10), value: rotation)

                // 信息
                VStack(spacing: 8) {
                    Text(symbol.name)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.appForeground)

                    Text(symbol.id)
                        .font(.system(.body, design: .monospaced))
                        .foregroundColor(.appSecondary)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.appCard)
                        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))

                    Text("可用性: \(symbol.availability)")
                        .font(.caption)
                        .foregroundColor(.appTertiary)

                    if symbol.isMulticolor {
                        HStack(spacing: 4) {
                            Circle()
                                .fill(Color.red)
                                .frame(width: 8, height: 8)
                            Text("支持多色渲染")
                                .font(.caption)
                                .foregroundColor(.appSecondary)
                        }
                    }
                }

                Spacer()

                // 操作按钮
                VStack(spacing: 12) {
                    // 复制名称
                    Button {
                        UIPasteboard.general.string = symbol.id
                        showCopied = true
                        Haptic.success()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            showCopied = false
                        }
                    } label: {
                        HStack {
                            Image(systemName: showCopied ? "checkmark" : "doc.on.doc")
                            Text(showCopied ? "已复制!" : "复制 Symbol 名称")
                        }
                        .modernButtonStyle()
                    }

                    // 保存图标到相册
                    Button {
                        saveSymbolAsImage()
                    } label: {
                        HStack {
                            Image(systemName: showSaved ? "checkmark" : "square.and.arrow.down")
                            Text(showSaved ? "已保存!" : "保存图标到相册")
                        }
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.appForeground)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.appCard)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    }
                }
                .padding(.bottom, 16)
            }
            .padding()
            .background(Color.appBackground)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("关闭") { dismiss() }
                        .foregroundColor(.appForeground)
                }
            }
        }
    }

    // MARK: - 保存 SF Symbol 为图片
    private func saveSymbolAsImage() {
        let config = UIImage.SymbolConfiguration(pointSize: 200, weight: .regular)
        guard UIImage(systemName: symbol.id, withConfiguration: config) != nil else {
            Haptic.error()
            return
        }

        // 用 SwiftUI ImageRenderer 渲染 (iOS 16+)
        let imageView = Text(symbol.id)
            .font(.system(size: 180))
            .foregroundColor(.primary)
            .frame(width: 240, height: 240)

        let renderer = ImageRenderer(content: imageView)
        renderer.scale = 3.0

        if let finalImage = renderer.uiImage {
            UIImageWriteToSavedPhotosAlbum(finalImage, nil, nil, nil)
            showSaved = true
            Haptic.success()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                showSaved = false
            }
        } else {
            Haptic.error()
        }
    }
}
