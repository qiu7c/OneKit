import SwiftUI
import CommonCrypto

enum CodecTab: String, CaseIterable {
    case json = "JSON"; case base64 = "Base64"; case url = "URL"; case unicode = "Unicode"; case hash = "Hash"
    var icon: String { switch self { case .json: return "curlybraces"; case .base64: return "lock.shield"; case .url: return "link"; case .unicode: return "character"; case .hash: return "number" } }
}

@MainActor
class CodecViewModel: ObservableObject {
    @Published var inputText = ""; @Published var outputText = ""; @Published var errorMessage: String?; @Published var showError = false; @Published var selectedTab: CodecTab = .json

    func process() {
        switch selectedTab {
        case .json: formatJSON()
        case .base64: base64Encode()
        case .url: urlCodec()
        case .unicode: unicodeCodec()
        case .hash: hashText()
        }
    }

    private func formatJSON() {
        guard let d = inputText.data(using: .utf8), !d.isEmpty else { return showErr("请输入 JSON") }
        do {
            let obj = try JSONSerialization.jsonObject(with: d)
            let pretty = try JSONSerialization.data(withJSONObject: obj, options: [.prettyPrinted, .sortedKeys])
            outputText = String(data: pretty, encoding: .utf8) ?? ""; success()
        } catch { showErr("JSON 错误: \(error.localizedDescription)") }
    }

    private func base64Encode() {
        guard let d = inputText.data(using: .utf8), !d.isEmpty else { return showErr("请输入内容") }
        outputText = d.base64EncodedString(); success()
    }

    func base64Decode() {
        guard !inputText.isEmpty else { return showErr("请输入 Base64") }
        let cleaned = inputText.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: " ", with: "")
        guard let d = Data(base64Encoded: cleaned), let s = String(data: d, encoding: .utf8) else { return showErr("无效的 Base64") }
        outputText = s; success()
    }

    private func urlCodec() {
        guard !inputText.isEmpty else { return showErr("请输入内容") }
        if inputText.contains("%") {
            outputText = inputText.removingPercentEncoding ?? inputText
        } else {
            outputText = inputText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? inputText
        }
        success()
    }

    private func unicodeCodec() {
        guard !inputText.isEmpty else { return showErr("请输入内容") }
        if inputText.contains("\\u") {
            // 解码 \uXXXX → 中文
            var result = ""
            var pos = inputText.startIndex
            let pattern = #"\\u([0-9a-fA-F]{4})"#
            if let regex = try? NSRegularExpression(pattern: pattern) {
                let matches = regex.matches(in: inputText, range: NSRange(location: 0, length: inputText.utf16.count))
                for m in matches {
                    guard let r = Range(m.range, in: inputText), let hr = Range(m.range(at: 1), in: inputText) else { continue }
                    result += inputText[pos..<r.lowerBound]
                    let scalar = UInt32(inputText[hr], radix: 16) ?? 0
                    result += String(UnicodeScalar(scalar) ?? "?")
                    pos = r.upperBound
                }
            }
            result += inputText[pos...]
            outputText = result
        } else {
            // 编码中文 → \uXXXX
            outputText = inputText.unicodeScalars.map { $0.isASCII ? String($0) : String(format: "\\u%04X", $0.value) }.joined()
        }
        success()
    }

    private func hashText() {
        guard let d = inputText.data(using: .utf8), !d.isEmpty else { return showErr("请输入内容") }
        var sha1 = Data(count: Int(CC_SHA1_DIGEST_LENGTH))
        var sha256 = Data(count: Int(CC_SHA256_DIGEST_LENGTH))
        _ = sha1.withUnsafeMutableBytes { b in d.withUnsafeBytes { CC_SHA1($0.baseAddress, CC_LONG(d.count), b.bindMemory(to: UInt8.self).baseAddress) } }
        _ = sha256.withUnsafeMutableBytes { b in d.withUnsafeBytes { CC_SHA256($0.baseAddress, CC_LONG(d.count), b.bindMemory(to: UInt8.self).baseAddress) } }
        outputText = "SHA1:   \(sha1.map { String(format: "%02x", $0) }.joined())\nSHA256: \(sha256.map { String(format: "%02x", $0) }.joined())"
        success()
    }

    func copyOutput() { guard !outputText.isEmpty else { return }; UIPasteboard.general.string = outputText; Haptic.success() }
    func clear() { inputText = ""; outputText = ""; errorMessage = nil; showError = false }
    private func showErr(_ msg: String) { errorMessage = msg; showError = true; Haptic.error() }
    private func success() { errorMessage = nil; showError = false; Haptic.success() }
}
