import SwiftUI

// MARK: - Symbol 网格单元
struct SymbolGridCell: View {
    let symbol: SFSymbolItem
    let onTap: () -> Void
    let onCopy: () -> Void

    @State private var isPressed = false

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 8) {
                // 图标渲染
                Image(systemName: symbol.id)
                    .font(.title)
                    .symbolRenderingMode(symbol.isMulticolor ? .multicolor : .monochrome)
                    .foregroundColor(.appForeground)
                    .frame(height: 36)

                // 名称
                Text(symbol.name)
                    .font(.caption2)
                    .foregroundColor(.appSecondary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)

                // Symbol 系统名称
                Text(symbol.id)
                    .font(.system(size: 7))
                    .foregroundColor(.appTertiary)
                    .lineLimit(1)
            }
            .padding(8)
            .frame(minHeight: 80)
            .frame(maxWidth: .infinity)
            .background(Color.appCard)
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            .contentShape(.contextMenuPreview, RoundedRectangle(cornerRadius: 10))
            .contextMenu {
                Button {
                    onCopy()
                } label: {
                    Label("复制名称", systemImage: "doc.on.doc")
                }

                Button {
                    UIPasteboard.general.string = symbol.name
                } label: {
                    Label("复制中文名", systemImage: "doc.on.doc")
                }
            }
        }
        .buttonStyle(.plain)
    }
}
