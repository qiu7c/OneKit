import SwiftUI

struct MissAVDetailView: View {
    let video: MissAVMedia
    @StateObject private var vm = MissAVViewModel.shared
    @State private var m3u8URL: String?
    @State private var isLoading = false
    @State private var errorMsg: String?
    @State private var showPlayer = false
    @State private var showDebug = false

    var body: some View {
        VStack(spacing: 0) {
            // 封面
            ZStack(alignment: .topTrailing) {
                AsyncImage(url: URL(string: video.coverURL)) { phase in
                    switch phase {
                    case .success(let img):
                        img.resizable().aspectRatio(contentMode: .fill)
                            .frame(maxWidth: .infinity)
                            .frame(height: 300)
                            .clipped()
                    case .failure:
                        Rectangle().fill(Color.appCard).frame(height: 300)
                    case .empty:
                        Rectangle().fill(Color.appCard).frame(height: 300)
                            .overlay(ProgressView())
                    @unknown default:
                        Rectangle().fill(Color.appCard).frame(height: 300)
                    }
                }

                Text(video.tag.rawValue)
                    .font(.system(size: 10, weight: .bold)).foregroundColor(.white)
                    .padding(.horizontal, 8).padding(.vertical, 4)
                    .background(Color(hex: video.tag.color)).clipShape(Capsule())
                    .padding(10)
            }

            // 信息
            VStack(alignment: .leading, spacing: 4) {
                Text(video.code)
                    .font(.title3).fontWeight(.bold)
                    .foregroundColor(.appForeground)
                Text(video.title)
                    .font(.subheadline)
                    .foregroundColor(.appSecondary)
                    .lineLimit(2)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 16)
            .padding(.top, 12)
            .padding(.bottom, 8)

            // 操作区域
            VStack(spacing: 0) {
                Divider()

                if isLoading {
                    HStack(spacing: 10) {
                        ProgressView().scaleEffect(0.9)
                        Text("正在解析...")
                            .font(.subheadline).foregroundColor(.appSecondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)

                } else if let err = errorMsg {
                    VStack(spacing: 8) {
                        Text(err).font(.caption).foregroundColor(.appSecondary)
                            .multilineTextAlignment(.center)
                        Button("重试") { startExtract() }
                            .font(.caption).fontWeight(.semibold)
                            .foregroundColor(Color.appBackground)
                            .padding(.horizontal, 24).padding(.vertical, 8)
                            .background(Color.appForeground).clipShape(Capsule())
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)

                } else if let url = m3u8URL {
                    VStack(spacing: 10) {
                        Button {
                            showPlayer = true
                        } label: {
                            HStack(spacing: 6) {
                                Image(systemName: "play.fill")
                                Text("播放")
                            }
                            .font(.headline).fontWeight(.semibold)
                            .foregroundColor(Color.appBackground)
                            .frame(maxWidth: .infinity)
                            .frame(height: 44)
                            .background(Color.appForeground)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        .padding(.horizontal, 16)

                        HStack {
                            Text(url)
                                .font(.system(size: 9, design: .monospaced))
                                .foregroundColor(.appTertiary)
                                .lineLimit(1)
                                .textSelection(.enabled)
                            Button {
                                UIPasteboard.general.string = url
                                Haptic.success()
                            } label: {
                                Image(systemName: "doc.on.doc")
                                    .font(.caption2).foregroundColor(.appSecondary)
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                    .padding(.vertical, 12)
                }
            }
            .background(Color.appCard)

            Spacer()
        }
        .background(Color.appBackground)
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button { showDebug = true } label: {
                    Image(systemName: "ladybug").font(.subheadline).foregroundColor(.appSecondary)
                }
            }
        }
        .sheet(isPresented: $showDebug) { debugView }
        .fullScreenCover(isPresented: $showPlayer) {
            if let url = m3u8URL {
                MissAVPlayerView(m3u8URL: url, referer: video.detailURL)
            }
        }
        .onAppear { startExtract() }
    }

    private func startExtract() {
        guard m3u8URL == nil else { return }
        isLoading = true
        errorMsg = nil
        Task { @MainActor in
            do {
                let m3u8 = try await vm.extractM3U8(for: video)
                m3u8URL = m3u8; isLoading = false
            } catch {
                errorMsg = error.localizedDescription; isLoading = false
            }
        }
    }

    // MARK: - 调试面板
    private var debugView: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 2) {
                    ForEach(vm.debugLog.suffix(50).reversed(), id: \.self) { line in
                        Text(line)
                            .font(.system(size: 9, design: .monospaced))
                            .foregroundColor(.green)
                            .textSelection(.enabled)
                            .padding(.horizontal, 8).padding(.vertical, 1)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, 4)
            }
            .background(Color.black)
            .navigationTitle("日志")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("关闭") { showDebug = false }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("复制") { UIPasteboard.general.string = vm.debugLog.joined(separator: "\n"); Haptic.success() }
                }
            }
        }
    }
}
