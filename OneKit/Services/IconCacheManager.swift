import SwiftUI

// MARK: - 图标缓存管理器
actor IconCacheManager {
    static let shared = IconCacheManager()

    private let fileManager = FileManager.default
    private var memoryCache: NSCache<NSURL, NSData>

    private init() {
        self.memoryCache = NSCache<NSURL, NSData>()
        memoryCache.countLimit = 200  // 最多缓存 200 个图标
        memoryCache.totalCostLimit = 50 * 1024 * 1024  // 50MB 限制
    }

    // MARK: - 缓存目录
    private var cacheDirectory: URL? {
        guard let cachesDir = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            return nil
        }
        let iconCache = cachesDir.appendingPathComponent("icon_cache", isDirectory: true)
        try? fileManager.createDirectory(at: iconCache, withIntermediateDirectories: true)
        return iconCache
    }

    // MARK: - 获取图标
    func getIcon(url: URL) async -> UIImage? {
        // 1. 检查内存缓存
        if let cachedData = memoryCache.object(forKey: url as NSURL) {
            return UIImage(data: cachedData as Data)
        }

        // 2. 检查磁盘缓存
        if let diskData = try? Data(contentsOf: diskCacheURL(for: url)),
           let image = UIImage(data: diskData) {
            // 写回内存缓存
            memoryCache.setObject(diskData as NSData, forKey: url as NSURL)
            return image
        }

        return nil
    }

    // MARK: - 缓存图标
    func cacheIcon(url: URL, data: Data) {
        // 内存缓存
        memoryCache.setObject(data as NSData, forKey: url as NSURL)

        // 磁盘缓存
        guard let cacheURL = diskCacheURL(for: url) as URL? else { return }
        try? data.write(to: cacheURL, options: .atomic)
    }

    // MARK: - 清除缓存
    func clearCache() {
        memoryCache.removeAllObjects()
        guard let cacheDir = cacheDirectory else { return }
        try? fileManager.removeItem(at: cacheDir)
    }

    // MARK: - 缓存大小
    func cacheSize() -> UInt64 {
        guard let cacheDir = cacheDirectory else { return 0 }
        guard let contents = try? fileManager.contentsOfDirectory(at: cacheDir,
                              includingPropertiesForKeys: [.fileSizeKey]) else { return 0 }
        return contents.reduce(0) { total, url in
            let size = (try? url.resourceValues(forKeys: [.fileSizeKey]).fileSize) ?? 0
            return total + UInt64(size)
        }
    }

    // MARK: - 磁盘缓存路径
    private func diskCacheURL(for url: URL) -> URL? {
        let fileName = url.absoluteString.data(using: .utf8)?.base64EncodedString()
            .replacingOccurrences(of: "/", with: "_") ?? url.lastPathComponent
        return cacheDirectory?.appendingPathComponent(fileName)
    }
}
