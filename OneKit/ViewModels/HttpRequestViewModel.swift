import SwiftUI

enum HttpMethod: String, CaseIterable { case GET, POST, PUT, DELETE, PATCH }

@MainActor
class HttpRequestViewModel: ObservableObject {
    @Published var url = "https://"
    @Published var method: HttpMethod = .GET
    @Published var headersText = ""
    @Published var bodyText = ""
    @Published var responseText = ""
    @Published var statusCode: Int?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showError = false

    func send() {
        guard let urlObj = URL(string: url), urlObj.host != nil else {
            errorMessage = "无效的 URL"; showError = true; return
        }

        isLoading = true; responseText = ""; statusCode = nil; errorMessage = nil

        Task {
            do {
                var req = URLRequest(url: urlObj)
                req.httpMethod = method.rawValue
                req.timeoutInterval = 30

                // 解析 Headers
                if !headersText.isEmpty {
                    let lines = headersText.split(separator: "\n")
                    for line in lines {
                        let parts = line.split(separator: ":", maxSplits: 1).map(String.init)
                        if parts.count == 2 { req.setValue(parts[1].trimmingCharacters(in: .whitespaces), forHTTPHeaderField: parts[0].trimmingCharacters(in: .whitespaces)) }
                    }
                }

                // Body (POST/PUT/PATCH)
                if method != .GET, !bodyText.isEmpty {
                    req.httpBody = bodyText.data(using: .utf8)
                    if req.value(forHTTPHeaderField: "Content-Type") == nil {
                        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
                    }
                }

                let (data, resp) = try await URLSession.shared.data(for: req)
                let httpResp = resp as? HTTPURLResponse
                statusCode = httpResp?.statusCode

                if let json = try? JSONSerialization.jsonObject(with: data),
                   let pretty = try? JSONSerialization.data(withJSONObject: json, options: [.prettyPrinted, .sortedKeys]) {
                    responseText = String(data: pretty, encoding: .utf8) ?? ""
                } else {
                    responseText = String(data: data, encoding: .utf8) ?? "(二进制数据)"
                }
                isLoading = false; Haptic.success()
            } catch {
                errorMessage = error.localizedDescription; showError = true; isLoading = false; Haptic.error()
            }
        }
    }

    func clear() { url = "https://"; headersText = ""; bodyText = ""; responseText = ""; statusCode = nil; errorMessage = nil }
}
