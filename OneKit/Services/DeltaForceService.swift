import Foundation

// MARK: - 模型
struct DailyPwdResponse: Codable { let ok: Bool; let cached: Bool?; let data: DailyPwdData }
struct DailyPwdData: Codable { let codes: [PwdCode]; let updateTime: String; let total: Int; let source: String?; let fetchTime: String? }
struct PwdCode: Codable, Identifiable { let name: String; let code: String; var id: String { name } }
struct ActivityResponse: Codable { let ok: Bool; let cached: Bool?; let data: ActivityData }
struct ActivityData: Codable { let time: String; let items: [ActivityItem]; let total: Int; let fetchTime: String? }
struct ActivityItem: Codable, Identifiable { let name: String; let image: String; let imageProxy: String?; let backgroundColor: String?; let backgroundStyle: String?; var id: String { name } }
struct ManufacturingResponse: Codable { let ok: Bool; let cached: Bool?; let data: ManufacturingData }
struct ManufacturingData: Codable { let items: [ManufacturingItem]; let updateTime: String; let total: Int; let fetchTime: String? }
struct ManufacturingItem: Codable, Identifiable { let name: String; let workshop: String; let hourlyProfit: String; let icon: String; let iconProxy: String?; let backgroundColor: String?; let backgroundStyle: String?; var id: String { name } }

// MARK: - 服务 (含缓存)
actor DeltaForceService {
    static let shared = DeltaForceService()
    private let baseURL = "https://sjz.upx8.com/api.php"
    private let session: URLSession

    private static var pwdCache: (data: DailyPwdData, date: Date)?

    private init() {
        let config = URLSessionConfiguration.default; config.timeoutIntervalForRequest = 15
        self.session = URLSession(configuration: config)
    }

    func fetchDailyPasswords() async throws -> DailyPwdData {
        if let c = Self.pwdCache, Calendar.current.isDateInToday(c.date) { return c.data }
        let (data, _) = try await session.data(from: URL(string: "\(baseURL)?action=daily_pwd")!)
        let r = try JSONDecoder().decode(DailyPwdResponse.self, from: data); guard r.ok else { throw DeltaForceError.apiError }
        Self.pwdCache = (r.data, Date())
        return r.data
    }

    func fetchActivityItems() async throws -> ActivityData {
        let (data, _) = try await session.data(from: URL(string: "\(baseURL)?action=activity")!)
        let r = try JSONDecoder().decode(ActivityResponse.self, from: data); guard r.ok else { throw DeltaForceError.apiError }; return r.data
    }

    func fetchManufacturing() async throws -> ManufacturingData {
        let (data, _) = try await session.data(from: URL(string: "\(baseURL)?action=manufacturing")!)
        let r = try JSONDecoder().decode(ManufacturingResponse.self, from: data); guard r.ok else { throw DeltaForceError.apiError }; return r.data
    }
}

enum DeltaForceError: LocalizedError { case invalidURL; case apiError; case networkError
    var errorDescription: String? { switch self { case .invalidURL: return "无效的 URL"; case .apiError: return "API 返回错误"; case .networkError: return "网络请求失败" } }
}
