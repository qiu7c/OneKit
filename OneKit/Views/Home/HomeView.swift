import SwiftUI

struct HomeView: View {
    @StateObject private var qlManager = QuickLaunchManager.shared
    @State private var isEditing = false

    var body: some View {
        NavigationStack {
            if isEditing { editView } else { normalView }
        }
    }

    private var normalView: some View {
        ScrollView {
            VStack(spacing: 24) {
                headerSection
                if !qlManager.visibleTools.isEmpty { quickToolsSection } else { emptyHint }
            }.padding(.horizontal, 20).padding(.top, 8).padding(.bottom, 24)
        }
        .background(Color.appBackground)
        .navigationTitle("OneKit").navigationBarTitleDisplayMode(.large)
        .toolbar { ToolbarItem(placement: .navigationBarTrailing) { Button("编辑") { withAnimation { isEditing = true } }.foregroundColor(.appForeground) } }
    }

    private var editView: some View {
        List {
            Section(header: Text("已显示 (\(qlManager.visibleTools.count))")) {
                ForEach(qlManager.visibleTools) { tool in
                    HStack(spacing: 12) {
                        Image(systemName: tool.icon).foregroundColor(Color.iconTint(for: tool.color)).frame(width: 28)
                        VStack(alignment: .leading, spacing: 2) { Text(tool.title).font(.body).foregroundColor(.appForeground); Text(tool.subtitle).font(.caption).foregroundColor(.appSecondary) }
                    }
                }
                .onMove { from, to in qlManager.move(from: from, to: to) }
                .onDelete { idx in for i in idx where i < qlManager.visibleTools.count { qlManager.toggleTool(qlManager.visibleTools[i]) } }
            }
            Section(header: Text("未显示")) {
                ForEach(qlManager.allAvailable.filter { t in !qlManager.visibleTools.contains(where: { $0.id == t.id }) }) { tool in
                    HStack(spacing: 12) {
                        Image(systemName: tool.icon).foregroundColor(Color.iconTint(for: tool.color)).frame(width: 28)
                        VStack(alignment: .leading, spacing: 2) { Text(tool.title).font(.body).foregroundColor(.appForeground); Text(tool.subtitle).font(.caption).foregroundColor(.appSecondary) }
                        Spacer(); Image(systemName: "plus.circle").foregroundColor(.appSecondary)
                    }.contentShape(Rectangle()).onTapGesture { qlManager.addTool(tool) }
                }
            }
        }
        .listStyle(.insetGrouped)
        .environment(\.editMode, .constant(.active))
        .navigationTitle("快捷启动").navigationBarTitleDisplayMode(.inline)
        .toolbar { ToolbarItem(placement: .navigationBarTrailing) { Button("完成") { withAnimation { isEditing = false } }.foregroundColor(.appForeground) } }
    }

    private var headerSection: some View {
        VStack(spacing: 6) {
            Text("综合工具集").font(.title2).fontWeight(.bold).foregroundColor(.appForeground)
            Text("SF Symbols · 图标下载 · 更多工具").font(.subheadline).foregroundColor(.appSecondary)
        }.frame(maxWidth: .infinity).padding(.vertical, 16)
    }

    private var quickToolsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("快捷启动").font(.headline).fontWeight(.semibold).foregroundColor(.appForeground)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) { ForEach(qlManager.visibleTools) { tool in NavigationLink { destinationView(for: tool) } label: { QuickToolCard(tool: tool) }.buttonStyle(.plain) } }.padding(.horizontal, 2)
            }
        }
    }

    private var emptyHint: some View {
        VStack(spacing: 12) { Image(systemName: "square.grid.2x2").font(.system(size: 40)).foregroundColor(.appSecondary.opacity(0.5)); Text("点击右上角「编辑」添加工具").font(.body).foregroundColor(.appSecondary) }.frame(maxWidth: .infinity).padding(.vertical, 40)
    }

    @ViewBuilder private func destinationView(for tool: ToolItem) -> some View {
        switch tool.id {
        case "sf-symbols": SFSymbolsListView()
        case "appstore-icon": IconDownloaderView()
        case "color-palette": ColorPaletteView()
        case "delta-force": DeltaForceView()
        default: PlaceholderView(tool: tool)
        }
    }
}

struct QuickToolCard: View {
    let tool: ToolItem
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: tool.icon).font(.title2).foregroundColor(Color.iconTint(for: tool.color)).frame(width: 40, height: 40).background(Color.iconTint(for: tool.color).opacity(0.08)).clipShape(RoundedRectangle(cornerRadius: 10))
            Text(tool.title).font(.caption).fontWeight(.medium).foregroundColor(.appForeground).lineLimit(1)
            Text(tool.subtitle).font(.caption2).foregroundColor(.appSecondary).lineLimit(1)
        }.frame(width: 100).padding(12).background(Color.appCard).clipShape(RoundedRectangle(cornerRadius: 14))
    }
}
