import SwiftUI
import AVKit

struct MissAVDetailView: View {
    let video: MissAVMedia
    @StateObject private var vm = MissAVViewModel.shared
    @State private var m3u8URL: String?
    @State private var isLoading = false
    @State private var errorMsg: String?
    @State private var showPlayer = false
    @State private var showDebug = false
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // 封面大图
                ZStack(alignment: .topTrailing) {
                    AsyncImage(url: URL(string: video.coverURL)) { phase in
                        switch phase {
                        case .success(let img):
                            img.resizable().aspectRatio(contentMode: .fill)
                                .frame(maxWidth: .infinity)
                                .frame(height: 280)
                                .clipped()
                        case .failure:
                            Rectangle().fill(Color.appCard).frame(height: 280)
                                .overlay(Image(systemName: "photo").foregroundColor(.appSecondary))
                        case .empty:
                            Rectangle().fill(Color.appCard).frame(height: 280)
                                .overlay(ProgressView())
                        @unknown default:
                            Rectangle().fill(Color.appCard).frame(height: 280)
                        }
                    }

                    Text(video.tag.rawValue)
                        .font(.system(size: 10, weight: .bold)).foregroundColor(.white)
                        .padding(.horizontal, 8).padding(.vertical, 4)
                        .background(Color(hex: video.tag.color)).clipShape(Capsule())
                        .padding(10)
                }
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal, 16)
                .padding(.top, 8)

                // 信息
                VStack(alignment: .leading, spacing: 8) {
                    Text(video.code)
                        .font(.title3).fontWeight(.bold)
                        .foregroundColor(.appForeground)

                    Text(video.title)
                        .font(.body)
                        .foregroundColor(.appSecondary)
                        .lineLimit(4)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 16)

                // 解析状态 / 结果
                VStack(spacing: 12) {
                    if isLoading {
                        HStack(spacing: 10) {
                            ProgressView().scaleEffect(1.1)
                            Text("正在解析视频地址...")
                                .font(.subheadline).foregroundColor(.appSecondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 30)
                        .background(Color.appCard)
                        .clipShape(RoundedRectangle(cornerRadius: 12))

                    } else if let err = errorMsg {
                        VStack(spacing: 10) {
                            Image(systemName: "exclamationmark.triangle").font(.title2).foregroundColor(.orange)
                            Text(err).font(.subheadline).foregroundColor(.appSecondary).multilineTextAlignment(.center)
                            Button("重试") { startExtract() }
                                .fontWeight(.semibold).foregroundColor(Color.appBackground)
                                .padding(.horizontal, 32).padding(.vertical, 10)
                                .background(Color.appForeground).clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 24)
                        .background(Color.appCard)
                        .clipShape(RoundedRectangle(cornerRadius: 12))

                    } else if let url = m3u8URL {
                        VStack(spacing: 14) {
                            // 播放按钮
                            Button {
                                showPlayer = true
                            } label: {
                                HStack(spacing: 8) {
                                    Image(systemName: "play.fill")
                                    Text("播放")
                                }
                                .font(.headline).fontWeight(.semibold)
                                .foregroundColor(Color.appBackground)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(Color.appForeground)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                            }

                            // m3u8 链接
                            VStack(alignment: .leading, spacing: 6) {
                                Text("视频流地址")
                                    .font(.caption).fontWeight(.semibold)
                                    .foregroundColor(.appSecondary)

                                HStack {
                                    Text(url)
                                        .font(.system(size: 10, design: .monospaced))
                                        .foregroundColor(.appSecondary)
                                        .lineLimit(2)
                                        .textSelection(.enabled)

                                    Spacer()

                                    Button {
                                        UIPasteboard.general.string = url
                                        Haptic.success()
                                    } label: {
                                        Image(systemName: "doc.on.doc")
                                            .font(.subheadline)
                                            .foregroundColor(.appForeground)
                                    }
                                }
                                .padding(10)
                                .background(Color.appCard)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                        }
                        .padding(14)
                        .background(Color.appCard)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
                .padding(.horizontal, 16)
            }
        }
        .background(Color.appBackground)
        .navigationTitle("详情")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
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
                self.m3u8URL = m3u8
                self.isLoading = false
            } catch {
                self.errorMsg = error.localizedDescription
                self.isLoading = false
            }
        }
    }
}
