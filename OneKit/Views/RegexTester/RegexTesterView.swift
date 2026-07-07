import SwiftUI

struct RegexTesterView: View {
    @State private var pattern = ""
    @State private var testText = ""
    @State private var matches: [(String, NSRange)] = []
    @State private var errorMsg: String?
    @State private var caseInsensitive = false
    @State private var multiline = false

    var body: some View {
        ScrollView {
            VStack(spacing: 14) {
                // 模式输入
                VStack(alignment: .leading, spacing: 4) {
                    Text("正则表达式").font(.caption).fontWeight(.semibold).foregroundColor(.appSecondary)
                    TextField("输入正则...", text: $pattern)
                        .font(.system(.body, design: .monospaced)).textFieldStyle(.plain).padding(10)
                        .background(Color.appCard).clipShape(RoundedRectangle(cornerRadius: 8))
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(errorMsg != nil ? Color.red.opacity(0.5) : Color.appSeparator.opacity(0.3), lineWidth: 0.5))
                        .onChange(of: pattern) { _, _ in parse() }
                }.padding(.horizontal, 16)

                // 选项
                HStack(spacing: 10) {
                    Toggle("忽略大小写", isOn: $caseInsensitive).font(.caption).foregroundColor(.appSecondary).toggleStyle(.button).tint(.appForeground)
                    Toggle("多行模式", isOn: $multiline).font(.caption).foregroundColor(.appSecondary).toggleStyle(.button).tint(.appForeground)
                    Spacer()
                    Text("\(matches.count) 个匹配").font(.caption).foregroundColor(.appSecondary)
                }.padding(.horizontal, 16).onChange(of: caseInsensitive) { _, _ in parse() }.onChange(of: multiline) { _, _ in parse() }

                // 测试文本
                VStack(alignment: .leading, spacing: 4) {
                    Text("测试文本").font(.caption).fontWeight(.semibold).foregroundColor(.appSecondary)
                    TextEditor(text: $testText)
                        .font(.system(.body, design: .monospaced)).frame(minHeight: 120).padding(8)
                        .scrollContentBackground(.hidden).background(Color.appCard)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.appSeparator.opacity(0.3), lineWidth: 0.5))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .onChange(of: testText) { _, _ in parse() }
                }.padding(.horizontal, 16)

                // 错误
                if let err = errorMsg {
                    HStack(spacing: 6) { Image(systemName: "exclamationmark.triangle.fill").font(.caption).foregroundColor(.red); Text(err).font(.caption).foregroundColor(.red) }.padding(.horizontal, 16)
                }

                // 匹配结果
                if !matches.isEmpty {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("匹配结果").font(.caption).fontWeight(.semibold).foregroundColor(.appSecondary)
                        ForEach(Array(matches.enumerated()), id: \.offset) { i, m in
                            HStack(spacing: 6) {
                                Text("\(i+1)").font(.caption2).foregroundColor(.appTertiary).frame(width: 20)
                                Text(m.0).font(.system(.body, design: .monospaced)).foregroundColor(.green).lineLimit(1)
                                Spacer()
                                Text("位置 \(m.1.location)").font(.caption2).foregroundColor(.appTertiary)
                                Button { UIPasteboard.general.string = m.0; Haptic.success() } label: { Image(systemName: "doc.on.doc").font(.caption2).foregroundColor(.appSecondary) }
                            }
                            .padding(8).background(Color.appCard).clipShape(RoundedRectangle(cornerRadius: 6))
                        }
                    }.padding(.horizontal, 16)
                }
            }.padding(.vertical, 8)
        }
        .background(Color.appBackground)
        .navigationTitle("正则测试").navigationBarTitleDisplayMode(.inline).toolbar(.hidden, for: .tabBar)
    }

    private func parse() -> Bool {
        guard !pattern.isEmpty else { matches = []; errorMsg = nil; return true }
        guard !testText.isEmpty else { matches = []; errorMsg = nil; return true }
        do {
            var opts = NSRegularExpression.Options()
            if caseInsensitive { opts.insert(.caseInsensitive) }
            if multiline { opts.insert(.anchorsMatchLines) }
            let regex = try NSRegularExpression(pattern: pattern, options: opts)
            let nsStr = testText as NSString
            let results = regex.matches(in: testText, range: NSRange(location: 0, length: nsStr.length))
            matches = results.map { (nsStr.substring(with: $0.range), $0.range) }
            errorMsg = nil
            return true
        } catch {
            matches = []
            errorMsg = "\(error.localizedDescription)"
            return false
        }
    }
}
