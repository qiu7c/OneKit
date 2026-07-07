import SwiftUI

// MARK: - 主页
struct HomeView: View {
    @StateObject private var qlManager = QuickLaunchManager.shared
    @State private var showEdit = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    headerSection

                    if !qlManager.visibleTools.isEmpty {
                        quickToolsSection
                    } else {
                        emptySection
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
                .padding(.bottom, 24)
            }
            .background(Color.appBackground)
            .navigationTitle("OneKit")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(showEdit ? "完成" : "编辑") {
                        withAnimation { showEdit.toggle() }
                    }
                    .foregroundColor(.appForeground)
                }
            }
            .sheet(isPresented: $showEdit) {
                EditQuickLaunchView()
            }
        }
    }

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

    private var quickToolsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("快捷启动")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.appForeground)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(qlManager.visibleTools) { tool in
                        NavigationLink {
                            destinationView(for: tool)
                        } label: {
                            QuickToolCard(tool: tool)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 2)
            }
        }
    }

    private var emptySection: some View {
        VStack(spacing: 12) {
            Image(systemName: "square.grid.2x2")
                .font(.system(size: 40))
                .foregroundColor(.appSecondary.opacity(0.5))
            Text("点击右上角「编辑」添加工具")
                .font(.body)
                .foregroundColor(.appSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
    }

    @ViewBuilder
    private func destinationView(for tool: ToolItem) -> some View {
        switch tool.id {
        case "sf-symbols": SFSymbolsListView()
        case "appstore-icon": IconDownloaderView()
        case "color-palette": ColorPaletteView()
        default: PlaceholderView(tool: tool)
        }
    }
}

// MARK: - 编辑快捷启动
struct EditQuickLaunchView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var qlManager = QuickLaunchManager.shared

    var body: some View {
        NavigationStack {
            List {
                Section("显示的工具（拖拽排序）") {
                    ForEach(qlManager.visibleTools) { tool in
                        HStack(spacing: 12) {
                            Image(systemName: tool.icon)
                                .foregroundColor(Color.iconTint(for: tool.color))
                                .frame(width: 28)

                            VStack(alignment: .leading, spacing: 2) {
                                Text(tool.title)
                                    .font(.body)
                                    .foregroundColor(.appForeground)
                                Text(tool.subtitle)
                                    .font(.caption)
                                    .foregroundColor(.appSecondary)
                            }
                        }
                    }
                    .onMove { source, dest in
                        qlManager.move(from: source, to: destination)
                    }
                }

                Section("添加更多工具") {
                    ForEach(qlManager.allAvailable.filter { t in !qlManager.visibleTools.contains(where: { $0.id == t.id }) }) { tool in
                        Button {
                            qlManager.addTool(tool)
                        } label: {
                            HStack(spacing: 12) {
                                Image(systemName: tool.icon)
                                    .foregroundColor(Color.iconTint(for: tool.color))
                                    .frame(width: 28)
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(tool.title)
                                        .font(.body)
                                        .foregroundColor(.appForeground)
                                    Text(tool.subtitle)
                                        .font(.caption)
                                        .foregroundColor(.appSecondary)
                                }
                                Spacer()
                                Image(systemName: "plus.circle")
                                    .foregroundColor(.appSecondary)
                            }
                        }
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("编辑快捷启动")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("完成") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
            }
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
