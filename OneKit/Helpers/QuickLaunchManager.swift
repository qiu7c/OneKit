import SwiftUI

final class QuickLaunchManager: ObservableObject {
    static let shared = QuickLaunchManager()

    @Published var visibleTools: [ToolItem] = []

    private init() {
        load()
    }

    private func load() {
        let allTools = ToolItem.builtInTools.filter { $0.isBuiltIn }
        guard let data = UserDefaults.standard.data(forKey: "ql_tools"),
              let ids = try? JSONDecoder().decode([String].self, from: data),
              !ids.isEmpty else {
            visibleTools = allTools
            return
        }
        let ordered = ids.compactMap { id in allTools.first { $0.id == id } }
        let remaining = allTools.filter { t in !ids.contains(t.id) }
        visibleTools = ordered + remaining
        // 验证是否成功加载
        print("[QL] Loaded \(visibleTools.count) tools from UserDefaults")
    }

    func toggleTool(_ tool: ToolItem) {
        visibleTools.removeAll { $0.id == tool.id }
        save()
    }

    func addTool(_ tool: ToolItem) {
        guard !visibleTools.contains(where: { $0.id == tool.id }) else { return }
        visibleTools.append(tool)
        save()
    }

    func move(from source: IndexSet, to destination: Int) {
        visibleTools.move(fromOffsets: source, toOffset: destination)
        save()
    }

    var allAvailable: [ToolItem] {
        ToolItem.builtInTools.filter { $0.isBuiltIn }
    }

    private func save() {
        let ids = visibleTools.map { $0.id }
        guard let data = try? JSONEncoder().encode(ids) else { return }
        UserDefaults.standard.set(data, forKey: "ql_tools")
        print("[QL] Saved \(ids.count) tools")
    }
}
