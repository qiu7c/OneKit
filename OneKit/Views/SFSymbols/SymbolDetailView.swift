import SwiftUI

// MARK: - Symbol 详情视图
struct SymbolDetailView: View {
    @Environment(\.dismiss) private var dismiss
    let symbol: SFSymbolItem
    @State private var scale: CGFloat = 1.0
    @State private var rotation: Angle = .zero
    @State private var showCopied = false

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

                    // 复制中文名
                    Button {
                        UIPasteboard.general.string = symbol.name
                        showCopied = true
                        Haptic.success()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            showCopied = false
                        }
                    } label: {
                        HStack {
                            Image(systemName: showCopied ? "checkmark" : "doc.text")
                            Text(showCopied ? "已复制!" : "复制中文名称")
                        }
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.appForeground)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.appCard)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    }

                    // 下载图标
                    Button {
                        saveSymbolAsImage()
                    } label: {
                        HStack {
                            Image(systemName: "square.and.arrow.down")
                            Text("保存图标到相册")
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
        guard let symbolImage = UIImage(systemName: symbol.id, withConfiguration: config) else {
            Haptic.error()
            return
        }
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 240, height: 240))
        let finalImage = renderer.image { ctx in
            UIColor.clear.setFill()
            ctx.fill(CGRect(x: 0, y: 0, width: 240, height: 240))
            symbolImage.draw(in: CGRect(x: 20, y: 20, width: 200, height: 200))
        }
        UIImageWriteToSavedPhotosAlbum(finalImage, nil, nil, nil)
        Haptic.success()
    }
}
