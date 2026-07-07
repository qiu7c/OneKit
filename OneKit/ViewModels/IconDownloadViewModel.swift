import SwiftUI
import Photos

@MainActor
class IconDownloadViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var searchResults: [ITunesApp] = []
    @Published var isSearching = false
    @Published var errorMessage: String?
    @Published var downloadedIcons: [Int: [IconSize: UIImage]] = [:]

    private let service = AppStoreService.shared
    private let cacheManager = IconCacheManager.shared

    func search() async -> Bool {
        guard !searchText.trimmingCharacters(in: .whitespaces).isEmpty else { searchResults = []; return false }
        isSearching = true; errorMessage = nil
        do {
            searchResults = try await service.searchApps(query: searchText)
            isSearching = false; return false
        } catch {
            errorMessage = error.localizedDescription
            if errorMessage?.isEmpty != false { errorMessage = "请求失败" }
            isSearching = false; return true
        }
    }

    func downloadIcon(for app: ITunesApp, size: IconSize) async -> UIImage? {
        let urlString: String
        switch size {
        case .size60: urlString = app.artworkUrl60
        case .size100: urlString = app.artworkUrl100
        case .size512: urlString = app.artworkUrl512 ?? app.artworkUrl100
        case .size1024: urlString = app.artworkUrl1024 ?? app.artworkUrl512 ?? app.artworkUrl100
        }
        guard let url = URL(string: urlString) else { return nil }
        if let cached = await cacheManager.getIcon(url: url) { return cached }
        do {
            let data = try await service.downloadIcon(url: url)
            await cacheManager.cacheIcon(url: url, data: data)
            if let image = UIImage(data: data) {
                var appIcons = downloadedIcons[app.id] ?? [:]; appIcons[size] = image; downloadedIcons[app.id] = appIcons
                return image
            }
        } catch {}
        return nil
    }

    func downloadAllSizes(for app: ITunesApp) async {
        Haptic.medium()
        for size in IconSize.allCases {
            guard downloadedIcons[app.id]?[size] == nil else { continue }
            _ = await downloadIcon(for: app, size: size)
        }
        Haptic.success()
    }

    func saveIconToPhotoAlbum(_ image: UIImage) {
        let status = PHPhotoLibrary.authorizationStatus(for: .addOnly)
        switch status {
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization(for: .addOnly) { s in if s == .authorized || s == .limited { DispatchQueue.main.async { UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil); Haptic.success() } } }
            return
        case .denied, .restricted: Haptic.error(); return
        case .authorized, .limited: break
        @unknown default: return
        }
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil); Haptic.success()
    }

    func clearResults() { searchResults = []; searchText = ""; errorMessage = nil }
}
