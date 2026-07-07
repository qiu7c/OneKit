import SwiftUI

// MARK: - 主页
struct HomeView: View {
    private let tools = ToolItem.builtInTools

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // 头部区域
                    headerSection

                    // 快捷工具
                    if !tools.isEmpty {
                        quickToolsSection
                    }

                    // 工具分类网格
                    toolsGridSection
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
                .padding(.bottom, 24)
            }
            .background(Color.appBackground)
            .navigationTitle("OneKit")
            .navigationBarTitleDisplayMode(.large)
        }
    }

    // MARK: - 头部
    private var headerSection: some View {
        VStack(spacing: 6) {
            Text("综合工具集")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.appForeground)

            Text("SF Symbols · 图标下载 · 更多工具")
                .font(.subheadline)
                .foregroundColor(.appSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
    }

    // MARK: - 快捷工具
    private var quickToolsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("快捷启动")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.appForeground)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(tools.filter { $0.isBuiltIn }) { tool in
                        NavigationLink {
                            destinationView(for: tool)
                        } label: {
                            QuickToolCard(tool: tool)
                        }
                        .buttonStyle(ScaleButtonStyle())
                    }
                }
                .padding(.horizontal, 2)
            }
        }
    }

    // MARK: - 工具分类网格
    private var toolsGridSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("所有工具")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.appForeground)

            LazyVGrid(
                columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 2),
                spacing: 10
            ) {
                ForEach(tools) { tool in
                    NavigationLink {
                        destinationView(for: tool)
                    } label: {
                        ToolCardView(tool: tool)
                    }
                    .buttonStyle(ScaleButtonStyle())
                }
            }
        }
    }

    // MARK: - 目标视图
    @ViewBuilder
    private func destinationView(for tool: ToolItem) -> some View {
        switch tool.id {
        case "sf-symbols":
            SFSymbolsListView()
        case "appstore-icon":
            IconDownloaderView()
        case "color-palette":
            ColorPaletteView()
        default:
            PlaceholderView(tool: tool)
        }
    }
}

// MARK: - 快捷工具卡片
struct QuickToolCard: View {
    let tool: ToolItem

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: tool.icon)
                .font(.title2)
                .foregroundColor(Color.iconTint(for: tool.color))
                .frame(width: 40, height: 40)
                .background(Color.iconTint(for: tool.color).opacity(0.08))
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))

            Text(tool.title)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.appForeground)
                .lineLimit(1)

            Text(tool.subtitle)
                .font(.caption2)
                .foregroundColor(.appSecondary)
                .lineLimit(1)
        }
        .frame(width: 100)
        .padding(12)
        .background(Color.appCard)
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
    }
}
