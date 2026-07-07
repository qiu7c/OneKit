import SwiftUI

struct HttpRequestView: View {
    @StateObject private var vm = HttpRequestViewModel()

    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                // URL + Method
                HStack(spacing: 8) {
                    Picker("", selection: $vm.method) {
                        ForEach(HttpMethod.allCases, id: \.self) { m in Text(m.rawValue).tag(m) }
                    }
                    .pickerStyle(.menu).frame(width: 80)

                    TextField("URL", text: $vm.url)
                        .font(.system(.body, design: .monospaced))
                        .textFieldStyle(.plain).padding(10)
                        .background(Color.appCard).clipShape(RoundedRectangle(cornerRadius: 8))
                        .keyboardType(.URL).autocapitalization(.none)
                }
                .padding(.horizontal, 16)

                // Headers
                VStack(alignment: .leading, spacing: 4) {
                    Text("Headers (Key:Value, 换行分隔)").font(.caption).foregroundColor(.appSecondary).padding(.horizontal, 16)
                    TextEditor(text: $vm.headersText)
                        .font(.system(.caption, design: .monospaced)).frame(minHeight: 60).padding(6)
                        .scrollContentBackground(.hidden).background(Color.appCard)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.appSeparator.opacity(0.3), lineWidth: 0.5))
                        .clipShape(RoundedRectangle(cornerRadius: 8)).padding(.horizontal, 16)
                }

                // Body
                if vm.method != .GET {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Body").font(.caption).foregroundColor(.appSecondary).padding(.horizontal, 16)
                        TextEditor(text: $vm.bodyText)
                            .font(.system(.caption, design: .monospaced)).frame(minHeight: 80).padding(6)
                            .scrollContentBackground(.hidden).background(Color.appCard)
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.appSeparator.opacity(0.3), lineWidth: 0.5))
                            .clipShape(RoundedRectangle(cornerRadius: 8)).padding(.horizontal, 16)
                    }
                }

                // Send
                HStack(spacing: 10) {
                    Button { vm.send() } label: {
                        HStack(spacing: 6) {
                            if vm.isLoading { ProgressView().scaleEffect(0.7).tint(Color.appBackground) }
                            else { Image(systemName: "paperplane.fill").font(.caption) }
                            Text(vm.isLoading ? "请求中..." : "发送").fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity).frame(height: 40)
                        .foregroundColor(Color.appBackground).background(Color.appForeground)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }.disabled(vm.isLoading)

                    Button { vm.clear() } label: {
                        Image(systemName: "trash").font(.body).foregroundColor(.appSecondary)
                            .frame(width: 40, height: 40).background(Color.appCard).clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
                .padding(.horizontal, 16)

                // Status
                if let code = vm.statusCode {
                    HStack {
                        Text("状态: \(code)").font(.caption).fontWeight(.semibold)
                            .foregroundColor(code < 400 ? .green : .red)
                        Spacer()
                        Button { UIPasteboard.general.string = vm.responseText; Haptic.success() } label: {
                            Text("复制").font(.caption2).foregroundColor(.appForeground).padding(.horizontal, 10).padding(.vertical, 4).background(Color.appCard).clipShape(Capsule())
                        }
                    }.padding(.horizontal, 16)
                }

                // Error
                if vm.showError, let err = vm.errorMessage {
                    HStack(spacing: 6) { Image(systemName: "exclamationmark.triangle.fill").font(.caption).foregroundColor(.orange); Text(err).font(.caption).foregroundColor(.orange) }
                        .padding(.horizontal, 16).frame(maxWidth: .infinity, alignment: .leading)
                }

                // Response
                if !vm.responseText.isEmpty {
                    ScrollView(.horizontal, showsIndicators: true) {
                        Text(vm.responseText).font(.system(.caption, design: .monospaced)).foregroundColor(.appForeground).padding(12).textSelection(.enabled)
                    }
                    .background(Color.appCard)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.appSeparator.opacity(0.3), lineWidth: 0.5))
                    .clipShape(RoundedRectangle(cornerRadius: 10)).padding(.horizontal, 16)
                }
            }
            .padding(.vertical, 8)
        }
        .background(Color.appBackground)
        .navigationTitle("HTTP 请求").navigationBarTitleDisplayMode(.inline).toolbar(.hidden, for: .tabBar)
    }
}
