import SwiftUI

struct SymbolGridCell: View {
    let symbol: SFSymbolItem
    let isFavorite: Bool
    let onTap: () -> Void
    let onCopy: () -> Void
    let onFavorite: () -> Void

    var body: some View {
        Button(action: onTap) {
            ZStack(alignment: .topTrailing) {
                VStack(spacing: 6) {
                    Image(systemName: symbol.id)
                        .font(.title2)
                        .symbolRenderingMode(symbol.isMulticolor ? .multicolor : .monochrome)
                        .foregroundColor(.appForeground)
                        .frame(height: 32)

                    Text(symbol.id)
                        .font(.system(size: 7))
                        .foregroundColor(.appTertiary)
                        .lineLimit(1)
                }
                .padding(8).frame(maxWidth: .infinity).frame(minHeight: 60)
                .background(Color.appCard)
                .clipShape(RoundedRectangle(cornerRadius: 10))

                // 收藏心形
                Button {
                    onFavorite(); Haptic.light()
                } label: {
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                        .font(.system(size: 10))
                        .foregroundColor(isFavorite ? .red : .appTertiary.opacity(0.5))
                        .padding(4)
                }
            }
        }
        .buttonStyle(.plain)
        .contextMenu {
            Button { onCopy() } label: { Label("复制名称", systemImage: "doc.on.doc") }
            Button { onFavorite() } label: { Label(isFavorite ? "取消收藏" : "收藏", systemImage: isFavorite ? "heart.slash" : "heart") }
        }
    }
}
