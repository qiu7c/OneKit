import Foundation

// MARK: - AppStore 搜索服务
actor AppStoreService {
    static let shared = AppStoreService()

    private let session: URLSession
    private let decoder: JSONDecoder

    private init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 15
        config.timeoutIntervalForResource = 30
        self.session = URLSession(configuration: config)
        self.decoder = JSONDecoder()
    }

    // MARK: - 搜索 App
    func searchApps(query: String, limit: Int = 20) async throws -> [ITunesApp] {
        guard let encoded = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://itunes.apple.com/search?term=\(encoded)&entity=software&limit=\(limit)&country=cn") else {
            throw AppStoreError.invalidURL
        }

        let (data, response) = try await session.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw AppStoreError.httpError
        }

        let searchResponse = try decoder.decode(ITunesSearchResponse.self, from: data)
        return searchResponse.results
    }

    // MARK: - 通过 ID 查询 App
    func lookupApp(id: Int) async throws -> ITunesApp? {
        guard let url = URL(string: "https://itunes.apple.com/lookup?id=\(id)&country=cn") else {
            throw AppStoreError.invalidURL
        }

        let (data, response) = try await session.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw AppStoreError.httpError
        }

        let lookupResponse = try decoder.decode(ITunesSearchResponse.self, from: data)
        return lookupResponse.results.first
    }

    // MARK: - 通过 Bundle ID 查询
    func lookupApp(bundleId: String) async throws -> ITunesApp? {
        guard let url = URL(string: "https://itunes.apple.com/lookup?bundleId=\(bundleId)&country=cn") else {
            throw AppStoreError.invalidURL
        }

        let (data, response) = try await session.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw AppStoreError.httpError
        }

        let lookupResponse = try decoder.decode(ITunesSearchResponse.self, from: data)
        return lookupResponse.results.first
    }

    // MARK: - 下载图标数据
    func downloadIcon(url: URL) async throws -> Data {
        let (data, response) = try await session.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw AppStoreError.downloadFailed
        }

        return data
    }
}

// MARK: - 错误类型
enum AppStoreError: LocalizedError {
    case invalidURL
    case httpError
    case downloadFailed
    case noResults

    var errorDescription: String? {
        switch self {
        case .invalidURL: return "无效的 URL"
        case .httpError: return "网络请求失败"
        case .downloadFailed: return "下载失败"
        case .noResults: return "未找到结果"
        }
    }
}
