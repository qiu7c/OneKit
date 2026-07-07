import SwiftUI

struct HttpRequestView: View {
    @StateObject private var vm = HttpRequestViewModel()
    @State private var showHeaders = false; @State private var showBody = false

    var body: some View {
        ScrollView {
            VStack(spacing: 14) {
                VStack(spacing: 8) {
                    HStack(spacing: 4) {
                        ForEach(HttpMethod.allCases, id: \.self) { m in
                            Button { vm.method = m; Haptic.light() } label: {
                                Text(m.rawValue).font(.system(size: 11, design: .monospaced)).fontWeight(.bold).padding(.horizontal, 10).padding(.vertical, 6)
                                    .foregroundColor(vm.method == m ? Color.appBackground : methodColor(m))
                                    .background(vm.method == m ? methodColor(m) : Color.appCard).clipShape(Capsule())
                            }
                        }
                    }
                    HStack(spacing: 6) {
                        Image(systemName: "link").font(.caption).foregroundColor(.appTertiary)
                        TextField("https://api.example.com", text: $vm.url).font(.system(.body, design: .monospaced)).textFieldStyle(.plain).keyboardType(.URL).autocapitalization(.none)
                        Button { if let s = UIPasteboard.general.string { vm.url = s } } label: { Image(systemName: "doc.on.clipboard").font(.caption).foregroundColor(.appSecondary) }
                    }.padding(10).background(Color.appCard).clipShape(RoundedRectangle(cornerRadius: 10))
                }.padding(.horizontal, 16)

                HStack(spacing: 8) {
                    Button { vm.send() } label: {
                        HStack(spacing: 6) { if vm.isLoading { ProgressView().scaleEffect(0.7).tint(Color.appBackground) } else { Image(systemName: "paperplane.fill").font(.caption) }; Text(vm.isLoading ? "请求中..." : "发送 \(vm.method.rawValue)").fontWeight(.semibold) }.frame(maxWidth: .infinity).frame(height: 42).foregroundColor(Color.appBackground).background(methodColor(vm.method)).clipShape(RoundedRectangle(cornerRadius: 10))
                    }.disabled(vm.isLoading)
                    Button { vm.clear() } label: { Image(systemName: "trash").font(.body).foregroundColor(.appSecondary).frame(width: 42, height: 42).background(Color.appCard).clipShape(RoundedRectangle(cornerRadius: 10)) }
                }.padding(.horizontal, 16)

                VStack(spacing: 6) {
                    Button { withAnimation { showHeaders.toggle() } } label: {
                        HStack { Image(systemName: "list.bullet").font(.caption).foregroundColor(.appSecondary); Text("Headers").font(.subheadline).foregroundColor(.appForeground); Spacer(); Text(vm.headersText.isEmpty ? "选填" : "已填").font(.caption).foregroundColor(.appSecondary); Image(systemName: showHeaders ? "chevron.down" : "chevron.right").font(.caption2).foregroundColor(.appTertiary) }.padding(10).background(Color.appCard).clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    if showHeaders { TextEditor(text: $vm.headersText).font(.system(.caption, design: .monospaced)).frame(minHeight: 60).padding(6).scrollContentBackground(.hidden).background(Color.appCard).overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.appSeparator.opacity(0.3), lineWidth: 0.5)).clipShape(RoundedRectangle(cornerRadius: 8)) }
                }.padding(.horizontal, 16)

                if vm.method != .GET {
                    VStack(spacing: 6) {
                        Button { withAnimation { showBody.toggle() } } label: {
                            HStack { Image(systemName: "doc.text").font(.caption).foregroundColor(.appSecondary); Text("Body").font(.subheadline).foregroundColor(.appForeground); Spacer(); if !vm.bodyText.isEmpty { Button { vm.bodyText = tryPeekFormat(vm.bodyText) } label: { Text("格式化").font(.caption2).foregroundColor(.appSecondary).padding(.horizontal, 6).padding(.vertical, 2).background(Color.appCard).clipShape(Capsule()) } }; Image(systemName: showBody ? "chevron.down" : "chevron.right").font(.caption2).foregroundColor(.appTertiary) }.padding(10).background(Color.appCard).clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        if showBody { TextEditor(text: $vm.bodyText).font(.system(.caption, design: .monospaced)).frame(minHeight: 80).padding(6).scrollContentBackground(.hidden).background(Color.appCard).overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.appSeparator.opacity(0.3), lineWidth: 0.5)).clipShape(RoundedRectangle(cornerRadius: 8)) }
                    }.padding(.horizontal, 16)
                }

                if let code = vm.statusCode {
                    HStack { Circle().fill(code < 400 ? Color.green : Color.red).frame(width: 6, height: 6); Text("\(code)").font(.system(.body, design: .monospaced)).fontWeight(.bold).foregroundColor(.appForeground); Text(statusText(code)).font(.caption).foregroundColor(.appSecondary); Spacer(); Button { UIPasteboard.general.string = vm.responseText; Haptic.success() } label: { Text("复制全部").font(.caption2).foregroundColor(Color.appBackground).padding(.horizontal, 10).padding(.vertical, 4).background(Color.appForeground).clipShape(Capsule()) } }.padding(.horizontal, 16)
                }

                if vm.showError, let err = vm.errorMessage { HStack(spacing: 6) { Image(systemName: "exclamationmark.triangle.fill").font(.caption).foregroundColor(.orange); Text(err).font(.caption).foregroundColor(.orange) }.padding(.horizontal, 16).frame(maxWidth: .infinity, alignment: .leading) }

                if !vm.responseText.isEmpty {
                    VStack(alignment: .leading, spacing: 4) {
                        HStack { Text("响应").font(.caption).fontWeight(.semibold).foregroundColor(.appSecondary); Spacer(); Text("\(vm.responseText.count) bytes").font(.caption2).foregroundColor(.appTertiary) }.padding(.horizontal, 16)
                        if let d = vm.responseText.data(using: .utf8), let obj = try? JSONSerialization.jsonObject(with: d) { jsonView(obj, indent: 0) } else { ScrollView(.horizontal) { Text(vm.responseText).font(.system(.caption, design: .monospaced)).foregroundColor(.appForeground).padding(12).textSelection(.enabled) }.background(Color.appCard).clipShape(RoundedRectangle(cornerRadius: 10)).padding(.horizontal, 16) }
                    }
                }
            }.padding(.vertical, 8)
        }
        .background(Color.appBackground)
        .navigationTitle("HTTP 请求").navigationBarTitleDisplayMode(.inline).toolbar(.hidden, for: .tabBar)
    }

    private func jsonView(_ value: Any, indent: Int) -> AnyView {
        if let dict = value as? [String: Any] {
            let rows = dict.keys.sorted().map { k -> AnyView in
                let v = jsonView(dict[k]!, indent: indent + 1)
                return AnyView(VStack(alignment: .leading, spacing: 1) {
                    HStack(spacing: 4) { Text(String(repeating: "  ", count: indent)).font(.system(size: 8)); Text(k).font(.system(.caption, design: .monospaced)).fontWeight(.semibold).foregroundColor(.blue); Text(":").font(.caption).foregroundColor(.appSecondary) }
                    v
                })
            }
            return AnyView(VStack(alignment: .leading, spacing: 1) { ForEach(Array(rows.enumerated()), id: \.offset) { $0.element } })
        } else if let arr = value as? [Any] {
            let rows = arr.enumerated().map { i, v -> AnyView in
                return AnyView(HStack(spacing: 4) {
                    Text("[\(i)]").font(.system(.caption, design: .monospaced)).foregroundColor(.appTertiary)
                    jsonView(v, indent: indent + 1)
                }.padding(.leading, CGFloat(indent) * 8))
            }
            return AnyView(VStack(alignment: .leading, spacing: 1) { ForEach(Array(rows.enumerated()), id: \.offset) { $0.element } })
        } else {
            let str = "\(value)"
            let color: Color = value is Int || value is Double ? .orange : value is Bool ? .purple : value is NSNull ? .gray : .green
            return AnyView(HStack(spacing: 4) {
                Text(str).font(.system(.caption, design: .monospaced)).foregroundColor(color).textSelection(.enabled).lineLimit(1)
                Button { UIPasteboard.general.string = str; Haptic.light() } label: { Image(systemName: "doc.on.doc").font(.system(size: 8)).foregroundColor(.appTertiary) }
            }.padding(.leading, CGFloat(indent) * 8))
        }
    }

    private func methodColor(_ m: HttpMethod) -> Color { switch m { case .GET: return .green; case .POST: return .blue; case .PUT: return .orange; case .DELETE: return .red; case .PATCH: return .purple } }
    private func statusText(_ c: Int) -> String { switch c { case 200: return "OK"; case 201: return "Created"; case 204: return "No Content"; case 301: return "Moved"; case 400: return "Bad Request"; case 401: return "Unauthorized"; case 403: return "Forbidden"; case 404: return "Not Found"; case 500: return "Server Error"; default: return "" } }
    private func tryPeekFormat(_ s: String) -> String { guard let d = s.data(using: .utf8), let o = try? JSONSerialization.jsonObject(with: d), let p = try? JSONSerialization.data(withJSONObject: o, options: [.prettyPrinted, .sortedKeys]) else { return s }; return String(data: p, encoding: .utf8) ?? s }
}
