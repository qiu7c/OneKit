import SwiftUI

struct CodecView: View {
    @StateObject private var vm = CodecViewModel()
    @State private var showCopied = false

    var body: some View {
        VStack(spacing: 0) {
            // Tab 切换
            Picker("", selection: $vm.selectedTab) {
                ForEach(CodecTab.allCases, id: \.self) { tab in
                    Text(tab.rawValue).tag(tab)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)

            ScrollView {
                VStack(spacing: 12) {
                    // 输入
                    VStack(alignment: .leading, spacing: 4) {
                        Text("输入").font(.caption).foregroundColor(.appSecondary)
                        TextEditor(text: $vm.inputText)
                            .font(.system(.body, design: .monospaced))
                            .frame(minHeight: 120)
                            .padding(8)
                            .background(Color.appCard)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.appSeparator.opacity(0.3), lineWidth: 0.5))
                    }
                    .padding(.horizontal, 16)

                    // 操作按钮
                    HStack(spacing: 10) {
                        Button { vm.process() } label: {
                            HStack { Image(systemName: "arrow.right"); Text("执行") }.font(.subheadline).fontWeight(.semibold).frame(maxWidth: .infinity).frame(height: 38).foregroundColor(.white).background(Color.appForeground).clipShape(RoundedRectangle(cornerRadius: 8))
                        }

                        if vm.selectedTab == .base64 {
                            Button { vm.base64Decode() } label: {
                                Text("解码").font(.subheadline).fontWeight(.semibold).frame(maxWidth: .infinity).frame(height: 38).foregroundColor(.appForeground).background(Color.appCard).clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                        }

                        Button { vm.clear() } label: {
                            Image(systemName: "trash").font(.body).foregroundColor(.appSecondary).frame(width: 38, height: 38).background(Color.appCard).clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                    }
                    .padding(.horizontal, 16)

                    // 错误
                    if vm.showError, let err = vm.errorMessage {
                        Text(err).font(.caption).foregroundColor(.red).padding(.horizontal, 16)
                    }

                    // 输出
                    if !vm.outputText.isEmpty {
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text("输出").font(.caption).foregroundColor(.appSecondary)
                                Spacer()
                                Button { vm.copyOutput(); showCopied = true; DispatchQueue.main.asyncAfter(deadline: .now()+1.5) { showCopied = false } } label: {
                                    Text(showCopied ? "已复制" : "复制").font(.caption2).foregroundColor(.appForeground).padding(.horizontal, 10).padding(.vertical, 4).background(Color.appCard).clipShape(Capsule())
                                }
                            }
                            Text(vm.outputText)
                                .font(.system(.caption, design: .monospaced))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(8)
                                .background(Color.appCard)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.appSeparator.opacity(0.3), lineWidth: 0.5))
                                .textSelection(.enabled)
                        }
                        .padding(.horizontal, 16)
                    }
                }
                .padding(.vertical, 8)
            }
        }
        .background(Color.appBackground)
        .navigationTitle("编解码").navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
    }
}
