import SwiftUI

struct HttpRequestView: View {
    @StateObject private var vm = HttpRequestViewModel()
    @State private var showHeaders = false
    @State private var showBody = false
    @State private var copiedKey: String?

    var body: some View {
        ScrollView {
            VStack(spacing: 14) {
                // Method + URL
                VStack(spacing: 8) {
                    HStack(spacing: 4) {
                        ForEach(HttpMethod.allCases, id: \.self) { m in
                            Button { vm.method = m; Haptic.light() } label: {
                                Text(m.rawValue).font(.system(size: 11, design: .monospaced)).fontWeight(.bold)
                                    .padding(.horizontal, 10).padding(.vertical, 6)
                                    .foregroundColor(vm.method == m ? Color.appBackground : methodColor(m))
                                    .background(vm.method == m ? methodColor(m) : Color.appCard)
                                    .clipShape(Capsule())
                            }
                        }
                    }

                    HStack(spacing: 6) {
                        Image(systemName: "link").font(.caption).foregroundColor(.appTertiary)
                        TextField("https://api.example.com", text: $vm.url)
                            .font(.system(.body, design: .monospaced)).textFieldStyle(.plain)
                            .keyboardType(.URL).autocapitalization(.none)
                        Button { UIPasteboard.general.string?.map { vm.url = $0 } } label: { Image(systemName: "doc.on.clipboard").font(.caption).foregroundColor(.appSecondary) }
                    }
                    .padding(10).background(Color.appCard).clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .padding(.horizontal, 16)

                // Send + Clear
                HStack(spacing: 8) {
                    Button { vm.send() } label: {
                        HStack(spacing: 6) {
                            if vm.isLoading { ProgressView().scaleEffect(0.7).tint(Color.appBackground) }
                            else { Image(systemName: "paperplane.fill").font(.caption) }
                            Text(vm.isLoading ? "请求中..." : "发送 \(vm.method.rawValue)").fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity).frame(height: 42)
                        .foregroundColor(Color.appBackground).background(methodColor(vm.method))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }.disabled(vm.isLoading)

                    Button { vm.clear() } label: {
                        Image(systemName: "trash").font(.body).foregroundColor(.appSecondary).frame(width: 42, height: 42).background(Color.appCard).clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
                .padding(.horizontal, 16)

                // Headers (折叠)
                VStack(spacing: 6) {
                    Button { withAnimation { showHeaders.toggle() } } label: {
                        HStack {
                            Image(systemName: "list.bullet").font(.caption).foregroundColor(.appSecondary)
                            Text("Headers").font(.subheadline).foregroundColor(.appForeground)
                            Spacer()
                            Text(vm.headersText.isEmpty ? "选填" : "已填").font(.caption).foregroundColor(.appSecondary)
                            Image(systemName: showHeaders ? "chevron.down" : "chevron.right").font(.caption2).foregroundColor(.appTertiary)
                        }.padding(10).background(Color.appCard).clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    if showHeaders {
                        TextEditor(text: $vm.headersText)
                            .font(.system(.caption, design: .monospaced)).frame(minHeight: 60).padding(6)
                            .scrollContentBackground(.hidden).background(Color.appCard)
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.appSeparator.opacity(0.3), lineWidth: 0.5))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }
                .padding(.horizontal, 16)

                // Body (折叠, POST/PUT/PATCH)
                if vm.method != .GET {
                    VStack(spacing: 6) {
                        Button { withAnimation { showBody.toggle() } } label: {
                            HStack {
                                Image(systemName: "doc.text").font(.caption).foregroundColor(.appSecondary)
                                Text("Body").font(.subheadline).foregroundColor(.appForeground)
                                Spacer()
                                if !vm.bodyText.isEmpty {
                                    Button { vm.bodyText = tryPeekFormat(vm.bodyText) } label: { Text("格式化").font(.caption2).foregroundColor(.appSecondary).padding(.horizontal, 6).padding(.vertical, 2).background(Color.appCard).clipShape(Capsule()) }
                                }
                                Image(systemName: showBody ? "chevron.down" : "chevron.right").font(.caption2).foregroundColor(.appTertiary)
                            }.padding(10).background(Color.appCard).clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        if showBody {
                            TextEditor(text: $vm.bodyText)
                                .font(.system(.caption, design: .monospaced)).frame(minHeight: 80).padding(6)
                                .scrollContentBackground(.hidden).background(Color.appCard)
                                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.appSeparator.opacity(0.3), lineWidth: 0.5))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                    }
                    .padding(.horizontal, 16)
                }

                // Status
                if let code = vm.statusCode {
                    HStack {
                        Circle().fill(code < 400 ? Color.green : Color.red).frame(width: 6, height: 6)
                        Text("\(code)").font(.system(.body, design: .monospaced)).fontWeight(.bold).foregroundColor(.appForeground)
                        Text(statusText(code)).font(.caption).foregroundColor(.appSecondary)
                        Spacer()
                        Button { UIPasteboard.general.string = vm.responseText; Haptic.success() } label: { Text("复制全部").font(.caption2).foregroundColor(Color.appBackground).padding(.horizontal, 10).padding(.vertical, 4).background(Color.appForeground).clipShape(Capsule()) }
                    }.padding(.horizontal, 16)
                }

                // Error
                if vm.showError, let err = vm.errorMessage {
                    HStack(spacing: 6) { Image(systemName: "exclamationmark.triangle.fill").font(.caption).foregroundColor(.orange); Text(err).font(.caption).foregroundColor(.orange) }.padding(.horizontal, 16).frame(maxWidth: .infinity, alignment: .leading)
                }

                // Response
                if !vm.responseText.isEmpty {
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text("响应").font(.caption).fontWeight(.semibold).foregroundColor(.appSecondary)
                            Spacer()
                            Text("\(vm.responseText.count) bytes").font(.caption2).foregroundColor(.appTertiary)
                        }.padding(.horizontal, 16)

                        if let jsonData = vm.responseText.data(using: .utf8), let obj = try? JSONSerialization.jsonObject(with: jsonData) {
                            jsonTreeView(obj, key: nil)
                        } else {
                            ScrollView(.horizontal, showsIndicators: true) {
                                Text(vm.responseText).font(.system(.caption, design: .monospaced)).foregroundColor(.appForeground).padding(12).textSelection(.enabled)
                            }
                            .background(Color.appCard).clipShape(RoundedRectangle(cornerRadius: 10)).padding(.horizontal, 16)
                        }
                    }
                }
            }
            .padding(.vertical, 8)
        }
        .background(Color.appBackground)
        .navigationTitle("HTTP 请求").navigationBarTitleDisplayMode(.inline).toolbar(.hidden, for: .tabBar)
    }

    // MARK: - JSON 树
    @ViewBuilder
    private func jsonTreeView(_ value: Any, key: String?) -> some View {
        if let dict = value as? [String: Any] {
            VStack(alignment: .leading, spacing: 2) {
                if let k = key { keyLabel(k) }
                VStack(spacing: 2) { ForEach(Array(dict.keys.sorted()), id: \.self) { k in jsonTreeView(dict[k] as Any, key: k) } }.padding(.leading, 12)
            }
        } else if let arr = value as? [Any] {
            VStack(alignment: .leading, spacing: 2) {
                if let k = key { keyLabel(k) }
                Text("[\(arr.count)]").font(.caption).foregroundColor(.appSecondary).padding(.leading, 12)
                ForEach(Array(arr.enumerated()), id: \.offset) { i, v in jsonTreeView(v, key: "[\(i)]") }.padding(.leading, 12)
            }
        } else {
            HStack(spacing: 4) {
                if let k = key { keyLabel(k) }
                Text("\(value)").font(.system(.caption, design: .monospaced)).foregroundColor(valueColor(value)).textSelection(.enabled).lineLimit(1)
                Button { UIPasteboard.general.string = "\(value)"; copiedKey = key; Haptic.success(); DispatchQueue.main.asyncAfter(deadline: .now()+1) { copiedKey = nil } } label: {
                    Image(systemName: copiedKey == key ? "checkmark" : "doc.on.doc").font(.system(size: 8)).foregroundColor(.appTertiary)
                }
            }.padding(.leading, 12)
        }
    }

    private func keyLabel(_ k: String) -> some View {
        Text(k).font(.system(.caption, design: .monospaced)).fontWeight(.semibold).foregroundColor(.blue)
    }

    private func valueColor(_ v: Any) -> Color {
        if v is Int || v is Double { return .orange }
        if v is Bool { return .purple }
        if v is NSNull { return .gray }
        return .green
    }

    private func methodColor(_ m: HttpMethod) -> Color {
        switch m { case .GET: return .green; case .POST: return .blue; case .PUT: return .orange; case .DELETE: return .red; case .PATCH: return .purple }
    }

    private func statusText(_ c: Int) -> String {
        switch c { case 200: return "OK"; case 201: return "Created"; case 204: return "No Content"; case 301: return "Moved"; case 400: return "Bad Request"; case 401: return "Unauthorized"; case 403: return "Forbidden"; case 404: return "Not Found"; case 500: return "Server Error"; default: return "" }
    }

    private func tryPeekFormat(_ s: String) -> String {
        guard let d = s.data(using: .utf8), let obj = try? JSONSerialization.jsonObject(with: d), let pretty = try? JSONSerialization.data(withJSONObject: obj, options: [.prettyPrinted, .sortedKeys]) else { return s }
        return String(data: pretty, encoding: .utf8) ?? s
    }
}
