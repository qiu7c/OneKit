import SwiftUI
import AVKit

struct VideoPreviewView: View {
    @State private var urlText = ""
    @State private var player: AVPlayer?
    @State private var showPlayer = false
    @State private var errorMsg: String?

    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 12) {
                HStack(spacing: 8) {
                    Image(systemName: "link").font(.caption).foregroundColor(.appTertiary)
                    TextField("粘贴视频直链 (mp4/m3u8)...", text: $urlText)
                        .font(.system(.body, design: .monospaced)).textFieldStyle(.plain).autocapitalization(.none)
                        .keyboardType(.URL)
                    Button { if let s = UIPasteboard.general.string { urlText = s } } label: { Image(systemName: "doc.on.clipboard").font(.caption).foregroundColor(.appSecondary) }
                }
                .padding(10).background(Color.appCard).clipShape(RoundedRectangle(cornerRadius: 10))

                Button {
                    playVideo()
                } label: {
                    HStack(spacing: 6) { Image(systemName: "play.fill").font(.caption); Text("预览").fontWeight(.semibold) }
                        .frame(maxWidth: .infinity).frame(height: 42).foregroundColor(Color.appBackground).background(Color.appForeground).clipShape(RoundedRectangle(cornerRadius: 10))
                }

                if let err = errorMsg {
                    HStack(spacing: 6) { Image(systemName: "exclamationmark.triangle.fill").font(.caption).foregroundColor(.orange); Text(err).font(.caption).foregroundColor(.orange) }.frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding(16)

            if showPlayer, let player {
                VideoPlayer(player: player)
                    .ignoresSafeArea(edges: .bottom)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(.horizontal, 12)
            } else {
                Spacer()
                VStack(spacing: 12) {
                    Image(systemName: "video.fill").font(.system(size: 44)).foregroundColor(.appSecondary.opacity(0.4))
                    Text("输入视频直链开始预览").font(.body).foregroundColor(.appSecondary)
                    Text("支持 mp4 / m4v / mov / m3u8").font(.caption).foregroundColor(.appTertiary)
                }
                Spacer()
            }
        }
        .background(Color.appBackground)
        .navigationTitle("视频预览").navigationBarTitleDisplayMode(.inline).toolbar(.hidden, for: .tabBar)
        .onDisappear { player?.pause(); player = nil }
    }

    private func playVideo() {
        errorMsg = nil
        let urlStr = urlText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !urlStr.isEmpty, let url = URL(string: urlStr) else {
            errorMsg = "无效的 URL"; return
        }
        guard ["mp4", "m4v", "mov", "m3u8"].contains(url.pathExtension.lowercased()) || urlStr.contains(".m3u8") else {
            errorMsg = "不支持的视频格式，支持 mp4/m4v/mov/m3u8"
            return
        }
        player = AVPlayer(url: url)
        showPlayer = true
        player?.play()
        Haptic.success()
    }
}
