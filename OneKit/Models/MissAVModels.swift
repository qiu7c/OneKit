import Foundation

// MARK: - 视频分类标签
enum MissAVTag: String, CaseIterable, Codable {
    case chinese = "中文字幕"
    case english = "英文字幕"
    case uncensored = "无码流出"
    case normal = "普通"

    var color: String {
        switch self {
        case .chinese: return "#22C55E"   // 绿色
        case .english: return "#3B82F6"   // 蓝色
        case .uncensored: return "#EF4444" // 红色
        case .normal: return "#8B5CF6"    // 紫色
        }
    }
}

// MARK: - 视频条目
struct MissAVMedia: Identifiable, Codable, Equatable {
    let code: String       // 番号 MIDV-XXX
    let title: String      // 完整标题
    let coverURL: String   // 封面图 URL
    let detailURL: String  // 详情页 URL
    var tag: MissAVTag     // 分类标签
    var m3u8URL: String?   // 视频流地址（抓取后填充）
    private var uid = UUID()

    var id: String { uid.uuidString }

    static func == (lhs: MissAVMedia, rhs: MissAVMedia) -> Bool {
        lhs.uid == rhs.uid
    }
}

// MARK: - JS 桥接模型（WKWebView → Swift）
struct MissAVScrapedItem: Codable {
    let title: String
    let coverURL: String
    let detailURL: String
    let tags: [String]
}

struct MissAVM3U8Result: Codable {
    let m3u8: String
}

// MARK: - 搜索结果
struct MissAVSearchResult: Codable {
    let items: [MissAVScrapedItem]
    let hasNext: Bool
}
