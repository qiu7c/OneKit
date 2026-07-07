import SwiftUI

struct HomeView: View {
    @StateObject private var qlManager = QuickLaunchManager.shared
    @State private var isEditing = false
    @AppStorage("show_delta_pwd") private var showPwd = true
    @State private var pwdData: DailyPwdData?
    @State private var pwdLoading = true

    var body: some View {
        if isEditing {
            NavigationStack {
                editView
                .navigationTitle("编辑").navigationBarTitleDisplayMode(.inline)
                .toolbar { ToolbarItem(placement: .navigationBarTrailing) { Button("完成") { withAnimation { isEditing = false } }.foregroundColor(.appForeground) } }
            }
        } else {
            NavigationStack {
                normalView
                .navigationTitle("OneKit").navigationBarTitleDisplayMode(.large)
                .toolbar { ToolbarItem(placement: .navigationBarTrailing) { Button("编辑") { withAnimation { isEditing = true } }.foregroundColor(.appForeground) } }
            }
        }
    }

    private var normalView: some View {
        ScrollView {
            VStack(spacing: 16) {
                if showPwd { pwdCard }
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                    ForEach(qlManager.visibleTools) { tool in
                        NavigationLink { dest(tool) } label: { ToolCardView(tool: tool) }.buttonStyle(.plain)
                    }
                }.padding(.horizontal, 16)
                if qlManager.visibleTools.isEmpty {
                    VStack(spacing: 12) { Image(systemName: "square.grid.2x2").font(.system(size: 40)).foregroundColor(.appSecondary.opacity(0.5)); Text("点击右上角「编辑」添加工具").font(.body).foregroundColor(.appSecondary) }.frame(maxWidth: .infinity).padding(.vertical, 40)
                }
            }.padding(.top, 8).padding(.bottom, 24)
        }
        .background(Color.appBackground)
        .task { pwdLoading = true; if let d = try? await DeltaForceService.shared.fetchDailyPasswords() { pwdData = d }; pwdLoading = false }
    }

    private var pwdCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "lock.shield").font(.caption).foregroundColor(.orange)
                Text("三角洲今日密码").font(.subheadline).fontWeight(.semibold).foregroundColor(.appForeground)
                Spacer()
                if pwdLoading { ProgressView().scaleEffect(0.7) }
                Button { showPwd = false } label: { Image(systemName: "xmark").font(.caption2).foregroundColor(.appSecondary).frame(width: 24, height: 24).background(Color.appCard).clipShape(Circle()) }
            }
            if let d = pwdData {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 6) {
                    ForEach(d.codes) { p in
                        VStack(spacing: 2) { Text(p.name).font(.system(size: 8)).foregroundColor(.appSecondary).lineLimit(1); Text(p.code).font(.system(size: 16, design: .monospaced)).fontWeight(.bold).foregroundColor(.appForeground) }
                            .padding(6).frame(maxWidth: .infinity).background(Color.appCard).clipShape(RoundedRectangle(cornerRadius: 6)).onTapGesture { UIPasteboard.general.string = p.code; Haptic.success() }
                    }
                }
            }
        }.padding(12).background(Color.appCard).clipShape(RoundedRectangle(cornerRadius: 14)).padding(.horizontal, 16)
    }

    private var editView: some View {
        List {
            Section { Toggle(isOn: $showPwd) { HStack { Image(systemName: "lock.shield").foregroundColor(.orange); Text("显示三角洲密码") } } }
            Section(header: Text("已显示 (\(qlManager.visibleTools.count))")) {
                ForEach(qlManager.visibleTools) { tool in
                    HStack(spacing: 12) { Image(systemName: tool.icon).foregroundColor(Color.iconTint(for: tool.color)).frame(width: 28); VStack(alignment: .leading, spacing: 2) { Text(tool.title).font(.body).foregroundColor(.appForeground); Text(tool.subtitle).font(.caption).foregroundColor(.appSecondary) } }
                }.onMove { from, to in qlManager.move(from: from, to: to) }.onDelete { idx in
                    let toRemove = idx.map { qlManager.visibleTools[$0] }
                    for tool in toRemove { qlManager.toggleTool(tool) }
                }
            }
            Section(header: Text("未显示")) {
                ForEach(qlManager.allAvailable.filter { t in !qlManager.visibleTools.contains(where: { $0.id == t.id }) }) { tool in
                    HStack(spacing: 12) { Image(systemName: tool.icon).foregroundColor(Color.iconTint(for: tool.color)).frame(width: 28); VStack(alignment: .leading, spacing: 2) { Text(tool.title).font(.body).foregroundColor(.appForeground); Text(tool.subtitle).font(.caption).foregroundColor(.appSecondary) }; Spacer(); Image(systemName: "plus.circle").foregroundColor(.appSecondary) }.contentShape(Rectangle()).onTapGesture { qlManager.addTool(tool) }
                }
            }
        }.listStyle(.insetGrouped).environment(\.editMode, .constant(.active))
    }

    struct ToolCardView: View {
        let tool: ToolItem
        var body: some View {
            VStack(alignment: .leading, spacing: 8) {
                Image(systemName: tool.icon).font(.title2).foregroundColor(Color.iconTint(for: tool.color)).frame(width: 32, height: 32).background(Color.iconTint(for: tool.color).opacity(0.08)).clipShape(RoundedRectangle(cornerRadius: 8))
                Text(tool.title).font(.body).fontWeight(.semibold).foregroundColor(.appForeground).lineLimit(1)
                Text(tool.subtitle).font(.caption).foregroundColor(.appSecondary).lineLimit(2)
            }.padding(12).frame(maxWidth: .infinity, alignment: .leading).frame(height: 110).background(Color.appCard).clipShape(RoundedRectangle(cornerRadius: 14)).overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.appSeparator.opacity(0.3), lineWidth: 0.5))
        }
    }

    @ViewBuilder func dest(_ tool: ToolItem) -> some View {
        switch tool.id {
        case "sf-symbols": SFSymbolsListView()
        case "appstore-icon": IconDownloaderView()
        case "color-palette": ColorPaletteView()
        case "codec": CodecView()
        case "http-request": HttpRequestView()
        case "delta-force": DeltaForceView()
        default: PlaceholderView(tool: tool)
        }
    }
}
