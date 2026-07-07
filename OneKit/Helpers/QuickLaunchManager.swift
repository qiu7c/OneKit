import SwiftUI

// MARK: - 快捷启动管理器
final class QuickLaunchManager: ObservableObject {
    static let shared = QuickLaunchManager()

    @Published var visibleTools: [ToolItem] {
        didSet {
            save()
        }
    }

    private let saveKey = "quick_launch_tools"

    private init() {
        // 初始值：所有内置工具
        let allTools = ToolItem.builtInTools.filter { $0.isBuiltIn }

        if let data = UserDefaults.standard.data(forKey: saveKey),
           let ids = try? JSONDecoder().decode([String].self, from: data) {
            // 按存储的顺序恢复，过滤掉不存在的工具
            let idSet = Set(ids)
            let ordered = ids.compactMap { id in allTools.first { $0.id == id } }
            let remaining = allTools.filter { !idSet.contains($0.id) }
            visibleTools = ordered + remaining
        } else {
            visibleTools = allTools
        }
    }

    func toggleTool(_ tool: ToolItem) {
        if let idx = visibleTools.firstIndex(where: { $0.id == tool.id }) {
            visibleTools.remove(at: idx)
        }
    }

    func addTool(_ tool: ToolItem) {
        if !visibleTools.contains(where: { $0.id == tool.id }) {
            visibleTools.append(tool)
        }
    }

    func move(from source: IndexSet, to destination: Int) {
        visibleTools.move(fromOffsets: source, toOffset: destination)
    }

    var allAvailable: [ToolItem] {
        ToolItem.builtInTools.filter { $0.isBuiltIn }
    }

    private func save() {
        let ids = visibleTools.map { $0.id }
        if let data = try? JSONEncoder().encode(ids) {
            UserDefaults.standard.set(data, forKey: saveKey)
        }
    }
}
