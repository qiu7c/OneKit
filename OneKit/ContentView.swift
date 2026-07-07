import SwiftUI

struct ContentView: View {
    @State private var selectedTab: Tab = .home

    enum Tab: String, CaseIterable {
        case home = "主页"
        case tools = "工具"
        case settings = "设置"

        var icon: String {
            switch self {
            case .home: return "square.grid.2x2"
            case .tools: return "wrench.and.screwdriver"
            case .settings: return "gearshape"
            }
        }

        var activeIcon: String {
            switch self {
            case .home: return "square.grid.2x2.fill"
            case .tools: return "wrench.and.screwdriver.fill"
            case .settings: return "gearshape.fill"
            }
        }
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Label(Tab.home.rawValue,
                          systemImage: selectedTab == .home ? Tab.home.activeIcon : Tab.home.icon)
                }
                .tag(Tab.home)

            ToolsListView()
                .tabItem {
                    Label(Tab.tools.rawValue,
                          systemImage: selectedTab == .tools ? Tab.tools.activeIcon : Tab.tools.icon)
                }
                .tag(Tab.tools)

            SettingsView()
                .tabItem {
                    Label(Tab.settings.rawValue,
                          systemImage: selectedTab == .settings ? Tab.settings.activeIcon : Tab.settings.icon)
                }
                .tag(Tab.settings)
        }
        .tint(.primary)
    }
}

// MARK: - 工具列表
struct ToolsListView: View {
    private let tools = ToolItem.builtInTools.filter { $0.isBuiltIn }
    @State private var selectedTool: ToolItem?

    var body: some View {
        NavigationStack {
            List {
                ForEach(ToolCategory.allCases, id: \.self) { category in
                    let categoryTools = tools.filter { $0.category == category }
                    if !categoryTools.isEmpty {
                        Section {
                            ForEach(categoryTools) { tool in
                                Button {
                                    selectedTool = tool
                                } label: {
                                    ToolRowView(tool: tool)
                                }
                                .buttonStyle(.plain)
                            }
                        } header: {
                            Label(category.rawValue, systemImage: category.icon)
                                .font(.subheadline)
                                .foregroundColor(.appSecondary)
                        }
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("所有工具")
            .navigationBarTitleDisplayMode(.large)
            .navigationDestination(item: $selectedTool) { tool in
                destinationView(for: tool)
            }
        }
    }

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

// MARK: - 工具行
struct ToolRowView: View {
    let tool: ToolItem

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: tool.icon)
                .font(.title3)
                .foregroundColor(Color.iconTint(for: tool.color))
                .frame(width: 32)

            VStack(alignment: .leading, spacing: 2) {
                Text(tool.title)
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundColor(.appForeground)

                Text(tool.subtitle)
                    .font(.caption)
                    .foregroundColor(.appSecondary)
            }

            Spacer()

            if !tool.isBuiltIn {
                Text("即将推出")
                    .font(.caption2)
                    .foregroundColor(.appSecondary)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(Color.appCard)
                    .clipShape(Capsule())
            }
        }
        .padding(.vertical, 4)
    }
}

// MARK: - 占位视图
struct PlaceholderView: View {
    let tool: ToolItem

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: tool.icon)
                .font(.system(size: 60))
                .foregroundColor(.appSecondary)

            Text(tool.title)
                .font(.title2)
                .fontWeight(.bold)

            Text(tool.subtitle)
                .font(.body)
                .foregroundColor(.appSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Text("⚒️ 开发中，敬请期待")
                .font(.caption)
                .foregroundColor(.appSecondary)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Color.appCard)
                .clipShape(Capsule())
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.appBackground)
        .navigationTitle(tool.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - 设置页
struct SettingsView: View {
    @StateObject private var themeManager = ThemeManager.shared

    var body: some View {
        NavigationStack {
            List {
                Section {
                    VStack(spacing: 8) {
                        Image(systemName: "square.3.layers.3d")
                            .font(.system(size: 40))
                            .foregroundColor(.appForeground)

                        Text("OneKit")
                            .font(.title2)
                            .fontWeight(.bold)

                        Text("v1.0.0")
                            .font(.caption)
                            .foregroundColor(.appSecondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                }
                .listRowBackground(Color.clear)

                // MARK: - 主题切换
                Section("主题") {
                    ForEach(AppTheme.allCases) { theme in
                        Button {
                            themeManager.currentTheme = theme
                            Haptic.selection()
                        } label: {
                            HStack(spacing: 12) {
                                Image(systemName: theme.icon)
                                    .font(.body)
                                    .foregroundColor(.appForeground)
                                    .frame(width: 24)

                                Text(theme.rawValue)
                                    .font(.body)
                                    .foregroundColor(.appForeground)

                                Spacer()

                                if themeManager.currentTheme == theme {
                                    Image(systemName: "checkmark")
                                        .font(.caption)
                                        .foregroundColor(.appForeground)
                                }
                            }
                        }
                    }
                }

                Section("关于") {
                    LabeledContent("包名", value: "com.cc.OneKit")
                    LabeledContent("平台", value: "iOS 16+")
                    LabeledContent("技术栈", value: "SwiftUI")
                }

                Section {
                    Link(destination: URL(string: "https://github.com/qiu7c/OneKit")!) {
                        Label("GitHub 仓库", systemImage: "chevron.left.forwardslash.chevron.right")
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("设置")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}
