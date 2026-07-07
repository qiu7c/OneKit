import SwiftUI
import CommonCrypto

enum CodecTab: String, CaseIterable {
    case json = "JSON"
    case base64 = "Base64"
    case url = "URL"
    case unicode = "Unicode"
    case hash = "Hash"

    var icon: String {
        switch self {
        case .json: return "curlybraces"
        case .base64: return "lock.shield"
        case .url: return "link"
        case .unicode: return "character"
        case .hash: return "number"
        }
    }
}

@MainActor
class CodecViewModel: ObservableObject {
    @Published var inputText = ""
    @Published var outputText = ""
    @Published var errorMessage: String?
    @Published var showError = false
    @Published var selectedTab: CodecTab = .json

    func process() {
        switch selectedTab {
        case .json: formatJSON()
        case .base64: base64()
        case .url: urlCodec()
        case .unicode: unicodeCodec()
        case .hash: hashText()
        }
    }

    // MARK: - JSON
    private func formatJSON() {
        guard let data = inputText.data(using: .utf8), !data.isEmpty else {
            showError(msg: "请输入 JSON")
            return
        }
        do {
            let obj = try JSONSerialization.jsonObject(with: data)
            let pretty = try JSONSerialization.data(withJSONObject: obj, options: [.prettyPrinted, .sortedKeys])
            outputText = String(data: pretty, encoding: .utf8) ?? ""
            success()
        } catch {
            showError(msg: "JSON 错误: \(error.localizedDescription)")
        }
    }

    // MARK: - Base64
    private func base64() {
        guard let data = inputText.data(using: .utf8), !data.isEmpty else {
            showError(msg: "请输入内容"); return
        }
        outputText = data.base64EncodedString()
        success()
    }

    func base64Decode() {
        guard !inputText.isEmpty else { showError(msg: "请输入 Base64"); return }
        guard let data = Data(base64Encoded: inputText) ?? Data(base64Encoded: inputText.replacingOccurrences(of: "\n", with: "")),
              let str = String(data: data, encoding: .utf8) else {
            showError(msg: "无效的 Base64"); return
        }
        outputText = str; success()
    }

    // MARK: - URL
    private func urlCodec() {
        guard !inputText.isEmpty else { showError(msg: "请输入内容"); return }
        if inputText.contains("%") {
            outputText = inputText.removingPercentEncoding ?? inputText
        } else {
            outputText = inputText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? inputText
        }
        success()
    }

    // MARK: - Unicode
    private func unicodeCodec() {
        guard !inputText.isEmpty else { showError(msg: "请输入内容"); return }
        // 检测是 \\u 编码还是中文
        if inputText.contains("\\u") {
            // 解码: 中文 → 中文
            let decoded = inputText.replacingOccurrences(of: "\\u", with: "\\u")
            if let data = decoded.data(using: .utf8),
               let str = String(data: data, encoding: .nonLossyASCII) {
                outputText = str
            } else {
                // 手动解析
                var result = inputText
                let pattern = #"\\u([0-9a-fA-F]{4})"#
                if let regex = try? NSRegularExpression(pattern: pattern) {
                    result = regex.stringByReplacingMatches(in: result, range: NSRange(location: 0, length: result.utf16.count), withTemplate: { match in
                        let code = (result as NSString).substring(with: match.range(at: 1))
                        let scalar = UInt32(code, radix: 16) ?? 0
                        return String(UnicodeScalar(scalar) ?? "?")
                    })
                }
                outputText = result
            }
        } else {
            // 编码: 中文 → 中文
            if let data = inputText.data(using: .nonLossyASCII),
               let str = String(data: data, encoding: .utf8) {
                outputText = str
            } else {
                outputText = inputText.unicodeScalars.map { String(format: "\\u%04X", $0.value) }.joined()
            }
        }
        success()
    }

    // MARK: - Hash
    private func hashText() {
        guard let data = inputText.data(using: .utf8), !data.isEmpty else {
            showError(msg: "请输入内容"); return
        }
        var md5 = Data(count: Int(CC_MD5_DIGEST_LENGTH))
        var sha1 = Data(count: Int(CC_SHA1_DIGEST_LENGTH))
        var sha256 = Data(count: Int(CC_SHA256_DIGEST_LENGTH))

        _ = md5.withUnsafeMutableBytes { md5Bytes in
            data.withUnsafeBytes { dataBytes in
                CC_MD5(dataBytes.baseAddress, CC_LONG(data.count), md5Bytes.bindMemory(to: UInt8.self).baseAddress)
            }
        }
        _ = sha1.withUnsafeMutableBytes { sha1Bytes in
            data.withUnsafeBytes { dataBytes in
                CC_SHA1(dataBytes.baseAddress, CC_LONG(data.count), sha1Bytes.bindMemory(to: UInt8.self).baseAddress)
            }
        }
        _ = sha256.withUnsafeMutableBytes { sha256Bytes in
            data.withUnsafeBytes { dataBytes in
                CC_SHA256(dataBytes.baseAddress, CC_LONG(data.count), sha256Bytes.bindMemory(to: UInt8.self).baseAddress)
            }
        }

        outputText = """
        MD5:    \(md5.map { String(format: "%02x", $0) }.joined())
        SHA1:   \(sha1.map { String(format: "%02x", $0) }.joined())
        SHA256: \(sha256.map { String(format: "%02x", $0) }.joined())
        """
        success()
    }

    func copyOutput() {
        guard !outputText.isEmpty else { return }
        UIPasteboard.general.string = outputText
        Haptic.success()
    }

    func clear() { inputText = ""; outputText = ""; errorMessage = nil; showError = false }

    private func showError(msg: String) { errorMessage = msg; showError = true; Haptic.error() }
    private func success() { errorMessage = nil; showError = false; Haptic.success() }
}
