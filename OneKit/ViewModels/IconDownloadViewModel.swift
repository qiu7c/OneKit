import SwiftUI
import Photos

// MARK: - 图标下载 ViewModel
@MainActor
class IconDownloadViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var searchResults: [ITunesApp] = []
    @Published var selectedApp: ITunesApp?
    @Published var isSearching = false
    @Published var errorMessage: String?
    @Published var showError = false
    @Published var downloadedIcons: [Int: [IconSize: UIImage]] = [:]

    private let service = AppStoreService.shared
    private let cacheManager = IconCacheManager.shared

    // MARK: - 搜索 App
    func search() async {
        guard !searchText.trimmingCharacters(in: .whitespaces).isEmpty else {
            searchResults = []
            return
        }

        isSearching = true
        errorMessage = nil

        do {
            let results = try await service.searchApps(query: searchText)
            searchResults = results
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }

        isSearching = false
    }

    // MARK: - 下载指定尺寸图标
    func downloadIcon(for app: ITunesApp, size: IconSize) async -> UIImage? {
        let urlString: String
        switch size {
        case .size60: urlString = app.artworkUrl60
        case .size100: urlString = app.artworkUrl100
        case .size512: urlString = app.artworkUrl512 ?? app.artworkUrl100
        case .size1024: urlString = app.artworkUrl1024 ?? app.artworkUrl512 ?? app.artworkUrl100
        }

        guard let url = URL(string: urlString) else { return nil }

        // 检查缓存
        if let cached = await cacheManager.getIcon(url: url) {
            return cached
        }

        // 下载
        do {
            let data = try await service.downloadIcon(url: url)
            await cacheManager.cacheIcon(url: url, data: data)

            if let image = UIImage(data: data) {
                var appIcons = downloadedIcons[app.id] ?? [:]
                appIcons[size] = image
                downloadedIcons[app.id] = appIcons
                return image
            }
        } catch {
            errorMessage = "下载失败: \(error.localizedDescription)"
            showError = true
        }

        return nil
    }

    // MARK: - 下载所有尺寸图标
    func downloadAllSizes(for app: ITunesApp) async {
        Haptic.medium()

        for size in IconSize.allCases {
            guard downloadedIcons[app.id]?[size] == nil else { continue }
            _ = await downloadIcon(for: app, size: size)
        }

        Haptic.success()
    }

    // MARK: - 保存图标到相册
    func saveIconToPhotoAlbum(_ image: UIImage) {
        let status = PHPhotoLibrary.authorizationStatus(for: .addOnly)
        switch status {
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization(for: .addOnly) { newStatus in
                if newStatus == .authorized || newStatus == .limited {
                    DispatchQueue.main.async {
                        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                        Haptic.success()
                    }
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
        Haptic.light()
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        Haptic.success()
    }

    // MARK: - 清除结果
    func clearResults() {
        searchResults = []
        searchText = ""
        errorMessage = nil
    }
}
