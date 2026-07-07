import SwiftUI

// MARK: - 图标预览视图
struct IconPreviewView: View {
    let app: ITunesApp
    @ObservedObject var viewModel: IconDownloadViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var previewImage: UIImage?
    @State private var selectedSize: IconSize = .size1024
    @State private var isDownloading = false
    @State private var savedImage: UIImage?
    @State private var showSavedAlert = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Spacer()

                // 图标预览
                Group {
                    if let savedImage {
                        Image(uiImage: savedImage)
                            .resizable()
                            .frame(width: 200, height: 200)
                            .clipShape(RoundedRectangle(cornerRadius: 40, style: .continuous))
                    } else if let previewImage {
                        Image(uiImage: previewImage)
                            .resizable()
                            .frame(width: 200, height: 200)
                            .clipShape(RoundedRectangle(cornerRadius: 40, style: .continuous))
                    } else {
                        RoundedRectangle(cornerRadius: 40, style: .continuous)
                            .fill(Color.appCard)
                            .frame(width: 200, height: 200)
                            .overlay {
                                ProgressView()
                            }
                    }
                }
                .shadow(color: .black.opacity(0.1), radius: 20, x: 0, y: 8)

                // App 信息
                VStack(spacing: 4) {
                    Text(app.trackName)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.appForeground)

                    Text(app.artistName)
                        .font(.body)
                        .foregroundColor(.appSecondary)
                }

                // 尺寸选择
                VStack(spacing: 8) {
                    Text("选择尺寸")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.appForeground)

                    Picker("尺寸", selection: $selectedSize) {
                        ForEach(IconSize.allCases) { size in
                            Text(size.rawValue).tag(size)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                .padding(.horizontal)

                // 操作按钮
                VStack(spacing: 10) {
                    // 下载选中尺寸
                    Button {
                        Task {
                            isDownloading = true
                            if let image = await viewModel.downloadIcon(for: app, size: selectedSize) {
                                previewImage = image
                                savedImage = image
                                Haptic.success()
                            }
                            isDownloading = false
                        }
                    } label: {
                        HStack {
                            if isDownloading {
                                ProgressView()
                                    .tint(.white)
                            } else {
                                Image(systemName: "arrow.down.circle")
                            }
                            Text("下载 \(selectedSize.rawValue)")
                        }
                        .modernButtonStyle()
                    }
                    .disabled(isDownloading)

                    // 下载全部尺寸
                    Button {
                        Task {
                            await viewModel.downloadAllSizes(for: app)
                        }
                    } label: {
                        HStack {
                            Image(systemName: "arrow.down.to.line")
                            Text("下载全部尺寸")
                        }
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.appForeground)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.appCard)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    }

                    // 保存到相册
                    if savedImage != nil {
                        Button {
                            if let image = savedImage {
                                viewModel.saveIconToPhotoAlbum(image)
                                showSavedAlert = true
                            }
                        } label: {
                            HStack {
                                Image(systemName: "photo.badge.arrow.down")
                                Text("保存到相册")
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
                }
                .padding(.horizontal)

                Spacer()
            }
            .padding()
            .background(Color.appBackground)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("关闭") { dismiss() }
                }
            }
            .alert("保存成功", isPresented: $showSavedAlert) {
                Button("确定", role: .cancel) {}
            } message: {
                Text("图标已保存到相册")
            }
            .task {
                // 自动下载 1024 尺寸
                if let image = await viewModel.downloadIcon(for: app, size: .size1024) {
                    previewImage = image
                    savedImage = image
                }
            }
        }
    }
}
