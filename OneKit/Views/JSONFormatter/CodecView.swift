import SwiftUI

struct CodecView: View {
    @StateObject private var vm = CodecViewModel()
    @State private var showCopied = false

    var btnLabel: String { switch vm.selectedTab { case .json: return "格式化"; case .base64: return "编码"; case .url: return "编码"; case .unicode: return "转换"; case .hash: return "计算" } }

    var body: some View {
        VStack(spacing: 0) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 4) {
                    ForEach(CodecTab.allCases, id: \.self) { tab in
                        Button { vm.selectedTab = tab; Haptic.light() } label: {
                            HStack(spacing: 4) {
                                Image(systemName: tab.icon).font(.caption)
                                Text(tab.rawValue).font(.subheadline).fontWeight(.medium)
                            }.padding(.horizontal, 14).padding(.vertical, 7)
                                .foregroundColor(vm.selectedTab == tab ? Color.appBackground : .appForeground)
                                .background(vm.selectedTab == tab ? Color.appForeground : Color.appCard)
                                .clipShape(Capsule())
                        }
                    }
                }.padding(.horizontal, 16)
            }.padding(.vertical, 10)

            Divider()

            ScrollView {
                VStack(spacing: 14) {
                    // Input card
                    VStack(alignment: .leading, spacing: 6) {
                        HStack { Text("输入").font(.caption).fontWeight(.semibold).foregroundColor(.appSecondary); Spacer(); Button { vm.clear() } label: { Text("清空").font(.caption2).foregroundColor(.appSecondary) } }
                        ZStack(alignment: .topLeading) {
                            if vm.inputText.isEmpty { Text("粘贴内容到这里...").font(.system(.body, design: .monospaced)).foregroundColor(.appTertiary).padding(.horizontal, 12).padding(.vertical, 10) }
                            TextEditor(text: $vm.inputText).font(.system(.body, design: .monospaced)).frame(minHeight: 100).padding(8).scrollContentBackground(.hidden).background(Color.appCard)
                        }
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.appSeparator.opacity(0.3), lineWidth: 0.5))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    .padding(.horizontal, 16)

                    // Buttons row
                    HStack(spacing: 8) {
                        Button { vm.process() } label: {
                            HStack(spacing: 6) { Image(systemName: "play.fill").font(.caption); Text(btnLabel).fontWeight(.semibold) }
                                .frame(maxWidth: .infinity).frame(height: 40).foregroundColor(Color.appBackground).background(Color.appForeground).clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        if vm.selectedTab == .base64 {
                            Button { vm.base64Decode() } label: { Text("解码").fontWeight(.semibold).frame(maxWidth: .infinity).frame(height: 40).foregroundColor(.appForeground).background(Color.appCard).clipShape(RoundedRectangle(cornerRadius: 10)) }
                        }
                        Button { vm.clear() } label: { Image(systemName: "trash").font(.body).foregroundColor(.appSecondary).frame(width: 40, height: 40).background(Color.appCard).clipShape(RoundedRectangle(cornerRadius: 10)) }
                    }
                    .padding(.horizontal, 16)

                    // Error
                    if vm.showError, let err = vm.errorMessage {
                        HStack(spacing: 6) { Image(systemName: "exclamationmark.triangle.fill").font(.caption).foregroundColor(.orange); Text(err).font(.caption).foregroundColor(.orange) }.padding(.horizontal, 16)
                    }

                    // Output card
                    if !vm.outputText.isEmpty {
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text("输出").font(.caption).fontWeight(.semibold).foregroundColor(.appSecondary)
                                Spacer()
                                Button { vm.copyOutput(); showCopied = true; DispatchQueue.main.asyncAfter(deadline: .now()+1.5) { showCopied = false } } label: {
                                    HStack(spacing: 3) { Image(systemName: showCopied ? "checkmark" : "doc.on.doc").font(.caption2); Text(showCopied ? "已复制" : "复制").font(.caption2) }
                                        .foregroundColor(Color.appBackground).padding(.horizontal, 10).padding(.vertical, 4).background(Color.appForeground).clipShape(Capsule())
                                }
                                Button { vm.inputText = vm.outputText; vm.outputText = ""; Haptic.light() } label: {
                                    HStack(spacing: 3) { Image(systemName: "arrow.up.square").font(.caption2); Text("置入").font(.caption2) }
                                        .foregroundColor(.appForeground).padding(.horizontal, 10).padding(.vertical, 4).background(Color.appCard).clipShape(Capsule())
                                }
                            }

                            ScrollView(.horizontal) {
                                Text(vm.outputText).font(.system(.caption, design: .monospaced)).foregroundColor(.appForeground).padding(12).textSelection(.enabled)
                            }
                            .background(Color.appCard)
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.appSeparator.opacity(0.3), lineWidth: 0.5))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        .padding(.horizontal, 16)

                        // Hash 结果特殊显示
                        if vm.selectedTab == .hash {
                            VStack(alignment: .leading, spacing: 6) {
                                ForEach(vm.outputText.split(separator: "\n").map(String.init), id: \.self) { line in
                                    HStack(spacing: 6) {
                                        let parts = line.split(separator: ":", maxSplits: 1).map(String.init)
                                        if parts.count == 2 {
                                            Text(parts[0]).font(.caption).foregroundColor(.appSecondary).frame(width: 56, alignment: .trailing)
                                            Text(parts[1].trimmingCharacters(in: .whitespaces)).font(.system(.caption, design: .monospaced)).fontWeight(.bold).foregroundColor(.appForeground).lineLimit(1)
                                            Spacer()
                                            Button { UIPasteboard.general.string = parts[1].trimmingCharacters(in: .whitespaces); Haptic.success() } label: { Image(systemName: "doc.on.doc").font(.caption2).foregroundColor(.appSecondary) }
                                        }
                                    }.padding(8).background(Color.appCard).clipShape(RoundedRectangle(cornerRadius: 6))
                                }
                            }.padding(.horizontal, 16)
                        }
                    }
                }.padding(.vertical, 8)
            }
        }
        .background(Color.appBackground)
        .navigationTitle("编解码").navigationBarTitleDisplayMode(.inline).toolbar(.hidden, for: .tabBar)
    }
}
