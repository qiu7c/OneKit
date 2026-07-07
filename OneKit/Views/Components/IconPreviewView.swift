import SwiftUI
import Photos

struct IconPreviewView: View {
    let app: ITunesApp
    @ObservedObject var viewModel: IconDownloadViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var previewImage: UIImage?
    @State private var selectedSize: IconSize = .size1024
    @State private var isDownloading = false
    @State private var showSavedAlert = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Spacer()
                Group {
                    if let previewImage {
                        Image(uiImage: previewImage).resizable().frame(width: 180, height: 180).clipShape(RoundedRectangle(cornerRadius: 36))
                    } else {
                        RoundedRectangle(cornerRadius: 36).fill(Color.appCard).frame(width: 180, height: 180).overlay(ProgressView())
                    }
                }
                .shadow(color: .black.opacity(0.1), radius: 20, x: 0, y: 8)

                Text(app.trackName).font(.title2).fontWeight(.bold).foregroundColor(.appForeground)
                Text(app.artistName).font(.body).foregroundColor(.appSecondary)

                Picker("尺寸", selection: $selectedSize) {
                    ForEach(IconSize.allCases) { size in Text(size.rawValue).tag(size) }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)

                VStack(spacing: 10) {
                    Button {
                        Task {
                            isDownloading = true
                            if let img = await viewModel.downloadIcon(for: app, size: selectedSize) {
                                previewImage = img; Haptic.success()
                            }
                            isDownloading = false
                        }
                    } label: {
                        HStack {
                            if isDownloading { ProgressView().tint(.white) } else { Image(systemName: "arrow.down.circle") }
                            Text("下载 \(selectedSize.rawValue)")
                        }.modernButtonStyle()
                    }
                    .disabled(isDownloading)

                    Button {
                        Task { await viewModel.downloadAllSizes(for: app) }
                    } label: {
                        HStack { Image(systemName: "arrow.down.to.line"); Text("下载全部尺寸") }
                            .font(.headline).fontWeight(.semibold).foregroundColor(.appForeground)
                            .frame(maxWidth: .infinity).frame(height: 50).background(Color.appCard).clipShape(RoundedRectangle(cornerRadius: 12))
                    }

                    if previewImage != nil {
                        Button {
                            let status = PHPhotoLibrary.authorizationStatus(for: .addOnly)
                            switch status {
                            case .notDetermined:
                                PHPhotoLibrary.requestAuthorization(for: .addOnly) { s in
                                    if s == .authorized || s == .limited { saveImage() }
                                }
                            case .denied, .restricted: Haptic.error()
                            case .authorized, .limited: saveImage()
                            @unknown default: return
                            }
                        } label: {
                            HStack { Image(systemName: "photo.badge.arrow.down"); Text("保存到相册") }
                                .font(.headline).fontWeight(.semibold).foregroundColor(.appForeground)
                                .frame(maxWidth: .infinity).frame(height: 50).background(Color.appCard).clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                    }
                }
                .padding(.horizontal)
                Spacer()
            }
            .padding()
            .background(Color.appBackground)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { ToolbarItem(placement: .navigationBarTrailing) { Button("关闭") { dismiss() } } }
            .alert("已保存", isPresented: $showSavedAlert) { Button("确定", role: .cancel) {} }
        }
    }

    private func saveImage() {
        guard let img = previewImage else { return }
        UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil)
        showSavedAlert = true; Haptic.success()
    }
}
