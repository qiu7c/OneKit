import SwiftUI

struct AppSearchResultRow: View {
    let app: ITunesApp
    let onTap: () -> Void

    @State private var iconImage: UIImage?

    var body: some View {
        HStack(spacing: 12) {
            Group {
                if let iconImage {
                    Image(uiImage: iconImage).resizable().frame(width: 56, height: 56).clipShape(RoundedRectangle(cornerRadius: 12))
                } else {
                    RoundedRectangle(cornerRadius: 12).fill(Color.appCard).frame(width: 56, height: 56)
                        .overlay(Image(systemName: "app.dashed").foregroundColor(.appSecondary))
                }
            }
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.appSeparator.opacity(0.3), lineWidth: 0.5))

            VStack(alignment: .leading, spacing: 2) {
                Text(app.trackName).font(.body).fontWeight(.medium).foregroundColor(.appForeground).lineLimit(1)
                Text(app.artistName).font(.caption).foregroundColor(.appSecondary).lineLimit(1)
                HStack(spacing: 6) {
                    if let r = app.averageUserRating {
                        HStack(spacing: 2) { Image(systemName: "star.fill").font(.system(size: 8)).foregroundColor(.appSecondary); Text(String(format: "%.1f", r)).font(.caption2).foregroundColor(.appSecondary) }
                    }
                    Text(app.primaryGenreName).font(.caption2).foregroundColor(.appSecondary)
                    if let v = app.version { Text("v\(v)").font(.caption2).foregroundColor(.appTertiary) }
                }
            }
            Spacer()
        }
        .padding(12).background(Color.appCard).clipShape(RoundedRectangle(cornerRadius: 14)).padding(.horizontal, 16)
        .onAppear { loadIcon() }
        .onTapGesture { onTap() }
        .contentShape(Rectangle())
    }

    private func loadIcon() {
        guard let url = app.lowResIconURL else { return }
        Task {
            if let cached = await IconCacheManager.shared.getIcon(url: url) { iconImage = cached; return }
            if let data = try? await URLSession.shared.data(from: url).0, let img = UIImage(data: data) {
                iconImage = img; await IconCacheManager.shared.cacheIcon(url: url, data: data)
            }
        }
    }
}
