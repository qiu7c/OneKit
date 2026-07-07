import SwiftUI
import UniformTypeIdentifiers

struct ContentView: View {
    @State private var selectedTab: Tab = .home
    enum Tab: String, CaseIterable { case home = "主页"; case tools = "工具"; case settings = "设置"
        var icon: String { switch self { case .home: return "square.grid.2x2"; case .tools: return "wrench.and.screwdriver"; case .settings: return "gearshape" } }
        var activeIcon: String { switch self { case .home: return "square.grid.2x2.fill"; case .tools: return "wrench.and.screwdriver.fill"; case .settings: return "gearshape.fill" } }
    }
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView().tabItem { Label(Tab.home.rawValue, systemImage: selectedTab == .home ? Tab.home.activeIcon : Tab.home.icon) }.tag(Tab.home)
            ToolsListView().tabItem { Label(Tab.tools.rawValue, systemImage: selectedTab == .tools ? Tab.tools.activeIcon : Tab.tools.icon) }.tag(Tab.tools)
            SettingsView().tabItem { Label(Tab.settings.rawValue, systemImage: selectedTab == .settings ? Tab.settings.activeIcon : Tab.settings.icon) }.tag(Tab.settings)
        }.tint(.primary)
    }
}

struct ToolsListView: View {
    private let tools = ToolItem.builtInTools.filter { $0.isBuiltIn }
    var body: some View {
        NavigationStack {
            List {
                ForEach(ToolCategory.allCases, id: \.self) { cat in
                    let items = tools.filter { $0.category == cat }
                    if !items.isEmpty { Section { ForEach(items) { tool in NavigationLink(value: tool) { ToolRowView(tool: tool) } } } header: { Label(cat.rawValue, systemImage: cat.icon).font(.subheadline).foregroundColor(.appSecondary) } }
                }
            }
            .listStyle(.insetGrouped).navigationTitle("所有工具").navigationBarTitleDisplayMode(.large)
            .navigationDestination(for: ToolItem.self) { tool in
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
    }
}

struct ToolRowView: View {
    let tool: ToolItem
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: tool.icon).font(.title3).foregroundColor(Color.iconTint(for: tool.color)).frame(width: 32)
            VStack(alignment: .leading, spacing: 2) { Text(tool.title).font(.body).fontWeight(.medium).foregroundColor(.appForeground); Text(tool.subtitle).font(.caption).foregroundColor(.appSecondary) }
            Spacer()
            if !tool.isBuiltIn { Text("即将推出").font(.caption2).foregroundColor(.appSecondary).padding(.horizontal, 8).padding(.vertical, 3).background(Color.appCard).clipShape(Capsule()) }
        }.padding(.vertical, 4)
    }
}

struct PlaceholderView: View {
    let tool: ToolItem
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: tool.icon).font(.system(size: 60)).foregroundColor(.appSecondary)
            Text(tool.title).font(.title2).fontWeight(.bold)
            Text(tool.subtitle).font(.body).foregroundColor(.appSecondary).multilineTextAlignment(.center).padding(.horizontal)
            Text("⚒️ 开发中").font(.caption).foregroundColor(.appSecondary).padding(.horizontal, 16).padding(.vertical, 8).background(Color.appCard).clipShape(Capsule())
        }.frame(maxWidth: .infinity, maxHeight: .infinity).background(Color.appBackground).navigationTitle(tool.title).navigationBarTitleDisplayMode(.inline)
    }
}

struct SettingsView: View {
    @StateObject private var themeManager = ThemeManager.shared
    @State private var showExporter = false; @State private var showImporter = false; @State private var configDoc = ConfigDoc(data: Data())

    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack(spacing: 12) {
                        AsyncImage(url: URL(string: "https://q1.qlogo.cn/g?b=qq&nk=921569084&s=100")) { p in if let img = p.image { img.resizable().frame(width: 44, height: 44).clipShape(Circle()) } else { Circle().fill(Color.appCard).frame(width: 44, height: 44).overlay(Image(systemName: "person.fill").font(.body).foregroundColor(.appSecondary)) } }
                        VStack(alignment: .leading, spacing: 2) { Text("cc").font(.body).fontWeight(.semibold).foregroundColor(.appForeground); Text("开发者").font(.caption).foregroundColor(.appSecondary) }
                        Spacer(); Image(systemName: "square.3.layers.3d").font(.title2).foregroundColor(.appSecondary)
                    }.padding(.vertical, 4)
                }
                Section("主题") { Picker("主题", selection: $themeManager.currentTheme) { ForEach(AppTheme.allCases) { t in HStack { Image(systemName: t.icon); Text(t.rawValue) }.tag(t) } }.pickerStyle(.menu) }
                Section("关于") { LabeledContent("版本", value: "1.0.0"); LabeledContent("平台", value: "iOS 16+") }
                Section("配置") {
                    Button { if let d = ConfigManager.shared.exportConfig() { configDoc = ConfigDoc(data: d); showExporter = true } } label: { Label("导出配置", systemImage: "square.and.arrow.up") }
                    Button { showImporter = true } label: { Label("导入配置", systemImage: "square.and.arrow.down") }
                }.fileExporter(isPresented: $showExporter, document: configDoc, contentType: .json, defaultFilename: "OneKit_Config") { _ in Haptic.success() }
                    .fileImporter(isPresented: $showImporter, allowedContentTypes: [.json]) { result in if case .success(let url) = result, let d = try? Data(contentsOf: url) { if ConfigManager.shared.importConfig(data: d) { Haptic.success() } } }
                Section { Link(destination: URL(string: "https://github.com/qiu7c/OneKit")!) { Label("GitHub 仓库", systemImage: "chevron.left.forwardslash.chevron.right") } }
            }.listStyle(.insetGrouped).navigationTitle("设置").navigationBarTitleDisplayMode(.large)
        }
    }
}

struct ConfigDoc: FileDocument {
    static var readableContentTypes: [UTType] { [.json] }; var data: Data
    init(data: Data) { self.data = data }
    init(configuration: ReadConfiguration) throws { data = configuration.file.regularFileContents ?? Data() }
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper { FileWrapper(regularFileWithContents: data) }
}
