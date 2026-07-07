import Foundation

// MARK: - iTunes Search API 响应模型
struct ITunesSearchResponse: Codable {
    let resultCount: Int
    let results: [ITunesApp]
}

struct ITunesApp: Codable, Identifiable {
    let trackId: Int
    let trackName: String
    let artistName: String
    let artworkUrl60: String
    let artworkUrl100: String
    let artworkUrl512: String?
    let artworkUrl1024: String?
    let primaryGenreName: String
    let genres: [String]?
    let trackViewUrl: String?
    let description: String?
    let screenshotUrls: [String]?
    let averageUserRating: Double?
    let userRatingCount: Int?
    let minimumOsVersion: String?
    let fileSizeBytes: String?
    let version: String?
    let releaseNotes: String?
    let sellerName: String?
    let languageCodesISO2A: [String]?
    let bundleId: String?

    var id: Int { trackId }

    // 高清图标 URL
    var highResIconURL: URL? {
        URL(string: artworkUrl1024 ?? artworkUrl512 ?? artworkUrl100)
    }

    // 中清图标 URL
    var midResIconURL: URL? {
        URL(string: artworkUrl512 ?? artworkUrl100)
    }

    // 低清图标 URL
    var lowResIconURL: URL? {
        URL(string: artworkUrl100)
    }
}

// MARK: - 下载尺寸
enum IconSize: String, CaseIterable, Identifiable {
    case size60 = "60×60"
    case size100 = "100×100"
    case size512 = "512×512"
    case size1024 = "1024×1024"

    var id: String { rawValue }

    var pixelSize: Int {
        switch self {
        case .size60: return 60
        case .size100: return 100
        case .size512: return 512
        case .size1024: return 1024
        }
    }

    var urlSuffix: String {
        switch self {
        case .size60: return "60"
        case .size100: return "100"
        case .size512: return "512"
        case .size1024: return "1024"
        }
    }
}
