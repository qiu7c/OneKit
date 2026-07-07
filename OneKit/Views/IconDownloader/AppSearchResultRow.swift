import SwiftUI

// MARK: - App 搜索结果行
struct AppSearchResultRow: View {
    let app: ITunesApp
    let onTap: () -> Void
    let onDownload: (IconSize) -> Void

    @State private var iconImage: UIImage?

    var body: some View {
        HStack(spacing: 12) {
            // App 图标
            Group {
                if let iconImage {
                    Image(uiImage: iconImage)
                        .resizable()
                        .frame(width: 56, height: 56)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                } else {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(Color.appCard)
                        .frame(width: 56, height: 56)
                        .overlay {
                            Image(systemName: "app.dashed")
                                .foregroundColor(.appSecondary)
                        }
                }
            }
            .overlay(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(Color.appSeparator.opacity(0.3), lineWidth: 0.5)
            )

            // 信息
            VStack(alignment: .leading, spacing: 2) {
                Text(app.trackName)
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundColor(.appForeground)
                    .lineLimit(1)

                Text(app.artistName)
                    .font(.caption)
                    .foregroundColor(.appSecondary)
                    .lineLimit(1)

                HStack(spacing: 6) {
                    if let rating = app.averageUserRating {
                        HStack(spacing: 2) {
                            Image(systemName: "star.fill")
                                .font(.system(size: 8))
                                .foregroundColor(.appSecondary)
                            Text(String(format: "%.1f", rating))
                                .font(.caption2)
                                .foregroundColor(.appSecondary)
                        }
                    }

                    Text(app.primaryGenreName)
                        .font(.caption2)
                        .foregroundColor(.appSecondary)

                    if let version = app.version {
                        Text("v\(version)")
                            .font(.caption2)
                            .foregroundColor(.appTertiary)
                    }
                }
            }

            Spacer()

            // 下载按钮
            Menu {
                ForEach(IconSize.allCases) { size in
                    Button {
                        onDownload(size)
                    } label: {
                        Label("\(size.rawValue)", systemImage: "arrow.down.circle")
                    }
                }
            } label: {
                Image(systemName: "ellipsis.circle")
                    .font(.title3)
                    .foregroundColor(.appSecondary)
            }
        }
        .padding(12)
        .background(Color.appCard)
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .padding(.horizontal, 16)
        .onAppear { loadIcon() }
        .onTapGesture { onTap() }
        .contentShape(Rectangle())
    }

    // MARK: - 加载图标
    private func loadIcon() {
        guard let url = app.lowResIconURL else { return }
        Task {
            if let cached = await IconCacheManager.shared.getIcon(url: url) {
                iconImage = cached
                return
            }
            do {
                let data = try await URLSession.shared.data(from: url).0
                if let img = UIImage(data: data) {
                    iconImage = img
                    await IconCacheManager.shared.cacheIcon(url: url, data: data)
                }
            } catch {}
        }
    }
}
