import SwiftUI
import Photos

struct SymbolDetailView: View {
    @Environment(\.dismiss) private var dismiss
    let symbol: SFSymbolItem
    @State private var showSaved = false
    @State private var symbolSize: CGFloat = 80

    let sizes: [(name: String, value: CGFloat)] = [("小", 40), ("中", 80), ("大", 120), ("特大", 200)]

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Spacer()

                Image(systemName: symbol.id)
                    .font(.system(size: symbolSize))
                    .symbolRenderingMode(.monochrome)
                    .foregroundColor(.appForeground)

                Text(symbol.id).font(.system(.body, design: .monospaced)).foregroundColor(.appSecondary)
                    .padding(.horizontal, 16).padding(.vertical, 8).background(Color.appCard).clipShape(RoundedRectangle(cornerRadius: 8))

                // 尺寸选择
                Picker("尺寸", selection: $symbolSize) {
                    ForEach(sizes, id: \.value) { size in Text(size.name).tag(size.value) }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal, 40)

                Spacer()

                VStack(spacing: 12) {
                    Button {
                        UIPasteboard.general.string = symbol.id; Haptic.success()
                    } label: {
                        HStack { Image(systemName: "doc.on.doc"); Text("复制名称") }.modernButtonStyle()
                    }

                    Button { saveSymbolAsImage() } label: {
                        HStack { Image(systemName: showSaved ? "checkmark" : "square.and.arrow.down"); Text(showSaved ? "已保存!" : "保存到相册") }
                            .font(.headline).fontWeight(.semibold).foregroundColor(.appForeground)
                            .frame(maxWidth: .infinity).frame(height: 50).background(Color.appCard).clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
                .padding(.bottom, 16)
            }
            .padding()
            .background(Color.appBackground)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { ToolbarItem(placement: .navigationBarTrailing) { Button("关闭") { dismiss() } } }
        }
    }

    @MainActor
    private func saveSymbolAsImage() {
        let status = PHPhotoLibrary.authorizationStatus(for: .addOnly)
        switch status {
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization(for: .addOnly) { s in if s == .authorized || s == .limited { Task { self.renderAndSave() } } }
            return
        case .denied, .restricted: Haptic.error(); return
        case .authorized, .limited: break
        @unknown default: return
        }
        renderAndSave()
    }

    @MainActor
    private func renderAndSave() {
        let img = Image(systemName: symbol.id).font(.system(size: 200)).foregroundColor(.primary).frame(width: 240, height: 240)
        let r = ImageRenderer(content: img)
        r.scale = 3.0
        if let final = r.uiImage { UIImageWriteToSavedPhotosAlbum(final, nil, nil, nil); showSaved = true; Haptic.success();
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { showSaved = false }
        } else { Haptic.error() }
    }
}
