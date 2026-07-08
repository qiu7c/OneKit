import SwiftUI

struct MissAVSearchView: View {
    @StateObject private var vm = MissAVViewModel.shared
    @State private var searchQuery = ""
    @State private var showDebug = false
    @State private var selectedVideo: MissAVMedia?
    @State private var navigateToDetail = false

    private let columns = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10)
    ]

    var body: some View {
        VStack(spacing: 0) {
            // 搜索栏
            searchBar
                .padding(.horizontal, 16)
                .padding(.vertical, 10)

            // 状态提示
            if case .searching = vm.state {
                Spacer()
                VStack(spacing: 16) {
                    ProgressView().scaleEffect(1.2)
                    Text("正在搜索...")
                        .font(.subheadline).foregroundColor(.appSecondary)
                }
                Spacer()
            } else if case .error(let e) = vm.state {
                Spacer()
                errorView(e)
                Spacer()
            } else if vm.videos.isEmpty {
                Spacer()
                emptyView
                Spacer()
            } else {
                // 结果统计
                HStack {
                    Spacer()
                    Text("共 \(vm.videos.count) 部")
                        .font(.caption).foregroundColor(.appSecondary)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 6)

                // 视频网格
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 12) {
                        ForEach(vm.videos) { video in
                            VideoCardView(video: video)
                                .onTapGesture {
                                    selectedVideo = video
                                    navigateToDetail = true
                                }
                        }
                    }
                    .navigationDestination(isPresented: $navigateToDetail) {
                        if let video = selectedVideo {
                            MissAVDetailView(video: video)
                        }
                    }
                    .padding(.horizontal, 14)
                    .padding(.bottom, 20)
                }
                .refreshable {
                    if !vm.videos.isEmpty { await performSearch() }
            }
        }
        .background(Color.appBackground)
        .navigationTitle("影视探索")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button { showDebug = true } label: {
                    Image(systemName: "ladybug")
                        .font(.subheadline).foregroundColor(.appSecondary)
                }
            }
        }
        .sheet(isPresented: $showDebug) { debugView }
        .onSubmit(of: .search) { Task { await performSearch() } }
        .onAppear {
            vm.ensureWebView()
            vm.attachToWindow()
        }
        .onDisappear { vm.detachFromWindow() }
    }

    // MARK: - 搜索栏
    private var searchBar: some View {
        HStack(spacing: 10) {
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                    .font(.subheadline).foregroundColor(.appSecondary)
                TextField("番号 / 演员名 / 关键词", text: $searchQuery)
                    .font(.body).foregroundColor(.appForeground)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .submitLabel(.search)
                if !searchQuery.isEmpty {
                    Button { searchQuery = "" } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.subheadline).foregroundColor(.appSecondary)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(Color.appCard)
            .clipShape(RoundedRectangle(cornerRadius: 10))

            Button { Task { await performSearch() } } label: {
                Text("搜索")
                    .font(.subheadline).fontWeight(.semibold)
                    .foregroundColor(Color.appBackground)
                    .padding(.horizontal, 16).padding(.vertical, 10)
                    .background(Color.appForeground)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .buttonStyle(.plain)
            .disabled(searchQuery.trimmingCharacters(in: .whitespaces).isEmpty)
        }
    }

    // MARK: - 空状态
    private var emptyView: some View {
        VStack(spacing: 16) {
            Image(systemName: "film.stack")
                .font(.system(size: 48))
                .foregroundColor(.appSecondary.opacity(0.4))
            Text("搜索番号或演员名")
                .font(.body).foregroundColor(.appSecondary)
            Text("例如: MIDV-XXX 或 美谷朱里")
                .font(.caption).foregroundColor(.appTertiary)
            HStack(spacing: 8) {
                ForEach(["FC2", "MIDV", "SSIS"], id: \.self) { tag in
                    Button(tag) {
                        searchQuery = tag
                        Task { await performSearch() }
                    }
                    .font(.caption).fontWeight(.medium)
                    .foregroundColor(Color.appBackground)
                    .padding(.horizontal, 14).padding(.vertical, 6)
                    .background(Color.appForeground).clipShape(Capsule())
                    .buttonStyle(.plain)
                }
            }
        }
    }

    // MARK: - 错误状态
    private func errorView(_ msg: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 40))
                .foregroundColor(.orange.opacity(0.7))
            Text(msg).font(.body).foregroundColor(.appSecondary)
                .multilineTextAlignment(.center).padding(.horizontal, 40)
            Button("重试") { Task { await performSearch() } }
                .fontWeight(.semibold)
                .foregroundColor(Color.appBackground)
                .padding(.horizontal, 32).padding(.vertical, 10)
                .background(Color.appForeground)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .buttonStyle(.plain)
        }
    }

    // MARK: - 搜索
    private func performSearch() async {
        let q = searchQuery.trimmingCharacters(in: .whitespaces)
        guard !q.isEmpty else { return }
        hideKeyboard()
        do {
            let results = try await vm.search(query: q)
            await MainActor.run {
                vm.videos = results
                vm.state = .loaded(count: results.count)
            }
        } catch {
            await MainActor.run { vm.state = .error(error.localizedDescription) }
        }
    }

    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

// MARK: - 视频卡片
struct VideoCardView: View {
    let video: MissAVMedia

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            // 封面 - 用 Color.clear 占位强制 3:4
            ZStack(alignment: .topTrailing) {
                Color.clear
                    .overlay(
                        AsyncImage(url: URL(string: video.coverURL)) { phase in
                            switch phase {
                            case .success(let img):
                                img.resizable().aspectRatio(contentMode: .fill)
                            case .failure:
                                Color.appCard.overlay(
                                    Image(systemName: "photo").foregroundColor(.appSecondary)
                                )
                            case .empty:
                                Color.appCard.overlay(ProgressView())
                            @unknown default:
                                Color.appCard
                            }
                        }
                    )
                    .clipped()

                Text(video.tag.rawValue)
                    .font(.system(size: 9, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 6).padding(.vertical, 3)
                    .background(Color(hex: video.tag.color))
                    .clipShape(Capsule())
                    .padding(6)
            }
            .frame(maxWidth: .infinity)
            .aspectRatio(2/3, contentMode: .fit)
            .clipShape(RoundedRectangle(cornerRadius: 10))

            Text(video.code)
                .font(.caption2).fontWeight(.semibold)
                .foregroundColor(.appSecondary)
                .lineLimit(1)

            Text(video.title)
                .font(.caption)
                .foregroundColor(.appForeground)
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - 调试面板
extension MissAVSearchView {
    private var debugView: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 2) {
                    ForEach(vm.debugLog.reversed(), id: \.self) { line in
                        Text(line)
                            .font(.system(size: 9, design: .monospaced))
                            .foregroundColor(.green)
                            .lineLimit(nil)
                            .textSelection(.enabled)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, 4)
            }
            .background(Color.black)
            .navigationTitle("调试日志")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("关闭") { showDebug = false }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    HStack(spacing: 4) {
                        Button("清空") { vm.debugLog.removeAll() }
                        Button("复制") { UIPasteboard.general.string = vm.debugLog.joined(separator: "\n"); Haptic.success() }
                    }
                }
            }
        }
    }
}
