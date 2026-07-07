import SwiftUI
import Photos

// MARK: - Symbol 详情视图
struct SymbolDetailView: View {
    @Environment(\.dismiss) private var dismiss
    let symbol: SFSymbolItem
    @State private var showSaved = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Spacer()

                Image(systemName: symbol.id)
                    .font(.system(size: 80))
                    .symbolRenderingMode(.monochrome)
                    .foregroundColor(.appForeground)

                VStack(spacing: 8) {
                    Text(symbol.id)
                        .font(.system(.body, design: .monospaced))
                        .foregroundColor(.appSecondary)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.appCard)
                        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                }

                Spacer()

                VStack(spacing: 12) {
                    Button {
                        UIPasteboard.general.string = symbol.id
                        Haptic.success()
                    } label: {
                        HStack {
                            Image(systemName: "doc.on.doc")
                            Text("复制名称")
                        }
                        .modernButtonStyle()
                    }

                    Button {
                        saveSymbolAsImage()
                    } label: {
                        HStack {
                            Image(systemName: showSaved ? "checkmark" : "square.and.arrow.down")
                            Text(showSaved ? "已保存!" : "保存到相册")
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
                }
            }
        }
    }

    @MainActor
    private func saveSymbolAsImage() {
        let status = PHPhotoLibrary.authorizationStatus(for: .addOnly)
        switch status {
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization(for: .addOnly) { newStatus in
                if newStatus == .authorized || newStatus == .limited {
                    Task { self.renderAndSave() }
                }
            }
            return
        case .denied, .restricted:
            Haptic.error()
            return
        case .authorized, .limited:
            break
        @unknown default: return
        }
        renderAndSave()
    }

    private func renderAndSave() {
        let imageView = Image(systemName: symbol.id)
            .font(.system(size: 180))
            .foregroundColor(.primary)
            .frame(width: 240, height: 240)
        let renderer = ImageRenderer(content: imageView)
        renderer.scale = 3.0
        if let finalImage = renderer.uiImage {
            UIImageWriteToSavedPhotosAlbum(finalImage, nil, nil, nil)
            showSaved = true
            Haptic.success()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { showSaved = false }
        } else {
            Haptic.error()
        }
    }
}
