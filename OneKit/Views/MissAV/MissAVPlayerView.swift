import SwiftUI
import AVKit

// MARK: - HLS 播放器
struct MissAVPlayerView: View {
    let m3u8URL: String
    @State private var player: AVPlayer?
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)

            if let player = player {
                VideoPlayer(player: player)
                    .edgesIgnoringSafeArea(.all)
                    .onAppear {
                        player.play()
                    }
                    .onDisappear {
                        player.pause()
                    }
            } else {
                VStack(spacing: 16) {
                    ProgressView()
                        .scaleEffect(1.5)
                        .tint(.white)
                    Text("加载视频流...")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.7))
                }
            }
        }
        .overlay(alignment: .topTrailing) {
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.title2)
                    .foregroundColor(.white.opacity(0.8))
                    .padding(12)
            }
        }
        .onAppear {
            setupPlayer()
        }
    }

    private func setupPlayer() {
        guard let url = URL(string: m3u8URL) else { return }

        // 使用 AVURLAsset + 自定义请求头
        let asset = AVURLAsset(url: url)

        // 加载并观察状态
        let playerItem = AVPlayerItem(asset: asset)
        let player = AVPlayer(playerItem: playerItem)

        // 支持后台音频播放
        try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
        try? AVAudioSession.sharedInstance().setActive(true)

        self.player = player
    }
}

// MARK: - 预览
#Preview {
    MissAVPlayerView(m3u8URL: "https://example.com/playlist.m3u8")
}
