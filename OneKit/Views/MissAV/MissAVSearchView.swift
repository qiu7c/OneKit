import SwiftUI

struct MissAVSearchView: View {
    @StateObject private var vm = MissAVViewModel.shared
    @State private var searchQuery = ""
    @State private var showPlayer = false
    @State private var playerURL: String?

    private let columns = [
        GridItem(.adaptive(minimum: 155), spacing: 12)
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
                    ProgressView()
                        .scaleEffect(1.2)
                    Text("正在搜索...")
                        .font(.subheadline)
                        .foregroundColor(.appSecondary)
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
                    if case .extracting = vm.state {
                        HStack(spacing: 6) {
                            ProgressView().scaleEffect(0.7)
                            Text("解析视频地址...").font(.caption).foregroundColor(.appSecondary)
                        }
                    }
                    Spacer()
                    Text("共 \(vm.videos.count) 部")
                        .font(.caption)
                        .foregroundColor(.appSecondary)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 6)

                // 视频网格
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 14) {
                        ForEach(vm.videos) { video in
                            VideoCardView(video: video)
                                .onTapGesture {
                                    Task { await playVideo(video) }
                                }
                                .opacity(isSelected(video) ? 0.6 : 1)
                        }
                    }
                    .padding(.horizontal, 14)
                    .padding(.bottom, 20)
                }
                .refreshable {
                    await refresh()
                }
            }
        }
        .background(Color.appBackground)
        .navigationTitle("影视探索")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
        .fullScreenCover(isPresented: $showPlayer) {
            if let url = playerURL {
                MissAVPlayerView(m3u8URL: url)
            }
        }
        .onSubmit(of: .search) {
            Task { await performSearch() }
        }
    }

    // MARK: - 搜索栏
    private var searchBar: some View {
        HStack(spacing: 10) {
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                    .font(.subheadline)
                    .foregroundColor(.appSecondary)
                TextField("番号 / 演员名 / 关键词", text: $searchQuery)
                    .font(.body)
                    .foregroundColor(.appForeground)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .submitLabel(.search)
                if !searchQuery.isEmpty {
                    Button {
                        searchQuery = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.subheadline)
                            .foregroundColor(.appSecondary)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(Color.appCard)
            .clipShape(RoundedRectangle(cornerRadius: 10))

            Button {
                Task { await performSearch() }
            } label: {
                Text("搜索")
                    .font(.subheadline).fontWeight(.semibold)
                    .foregroundColor(Color.appBackground)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
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
                .font(.body)
                .foregroundColor(.appSecondary)
            Text("例如: MIDV-XXX 或 美谷朱里")
                .font(.caption)
                .foregroundColor(.appTertiary)
            // 快捷搜索示例
            HStack(spacing: 8) {
                ForEach(["FC2", "MIDV", "SSIS"], id: \.self) { tag in
                    Button(tag) {
                        searchQuery = tag
                        Task { await performSearch() }
                    }
                    .font(.caption).fontWeight(.medium)
                    .foregroundColor(Color.appBackground)
                    .padding(.horizontal, 14).padding(.vertical, 6)
                    .background(Color.appForeground)
                    .clipShape(Capsule())
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
            Text(msg)
                .font(.body)
                .foregroundColor(.appSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            Button("重试") {
                Task { await performSearch() }
            }
            .fontWeight(.semibold)
            .foregroundColor(Color.appBackground)
            .padding(.horizontal, 32)
            .padding(.vertical, 10)
            .background(Color.appForeground)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .buttonStyle(.plain)
        }
    }

    // MARK: - 操作
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
            await MainActor.run {
                vm.state = .error(error.localizedDescription)
            }
        }
    }

    private func playVideo(_ video: MissAVMedia) async {
        if let existing = video.m3u8URL {
            playerURL = existing
            showPlayer = true
            return
        }
        do {
            let m3u8 = try await vm.extractM3U8(for: video)
            await MainActor.run {
                if let idx = vm.videos.firstIndex(where: { $0.id == video.id }) {
                    vm.videos[idx].m3u8URL = m3u8
                }
                playerURL = m3u8
                showPlayer = true
            }
        } catch {
            await MainActor.run {
                vm.state = .error("获取播放地址失败: \(error.localizedDescription)")
            }
        }
    }

    private func refresh() async {
        if !vm.videos.isEmpty {
            await performSearch()
        }
    }

    private func isSelected(_ video: MissAVMedia) -> Bool {
        guard vm.selectedVideo?.id == video.id else { return false }
        if case .extracting = vm.state { return true }
        return false
    }

    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

// MARK: - 视频卡片
struct VideoCardView: View {
    let video: MissAVMedia

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            // 封面
            ZStack(alignment: .topTrailing) {
                AsyncImage(url: URL(string: video.coverURL)) { phase in
                    switch phase {
                    case .success(let img):
                        img.resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 155, height: 210)
                            .clipped()
                    case .failure:
                        Rectangle()
                            .fill(Color.appCard)
                            .frame(width: 155, height: 210)
                            .overlay(
                                Image(systemName: "photo")
                                    .foregroundColor(.appSecondary)
                            )
                    case .empty:
                        Rectangle()
                            .fill(Color.appCard)
                            .frame(width: 155, height: 210)
                            .overlay(ProgressView())
                    @unknown default:
                        Rectangle()
                            .fill(Color.appCard)
                            .frame(width: 155, height: 210)
                    }
                }

                // 标签
                Text(video.tag.rawValue)
                    .font(.system(size: 9, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 3)
                    .background(Color(hex: video.tag.color))
                    .clipShape(Capsule())
                    .padding(6)
            }
            .clipShape(RoundedRectangle(cornerRadius: 10))

            // 番号
            Text(video.id)
                .font(.caption2)
                .fontWeight(.semibold)
                .foregroundColor(.appSecondary)
                .lineLimit(1)

            // 标题
            Text(video.title)
                .font(.caption)
                .foregroundColor(.appForeground)
                .lineLimit(2)
        }
        .frame(width: 155)
    }
}

// MARK: - 预览
#Preview {
    NavigationStack {
        MissAVSearchView()
    }
}
