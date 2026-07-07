import SwiftUI

final class QuickLaunchManager: ObservableObject {
    static let shared = QuickLaunchManager()
    private let saveKey = "quick_launch_tools_v2"

    @Published var visibleTools: [ToolItem] = []

    private init() {
        let allTools = ToolItem.builtInTools.filter { $0.isBuiltIn }
        if let data = UserDefaults.standard.data(forKey: saveKey),
           let ids = try? JSONDecoder().decode([String].self, from: data),
           !ids.isEmpty {
            let ordered = ids.compactMap { id in allTools.first { $0.id == id } }
            let remaining = allTools.filter { t in !ids.contains(t.id) }
            visibleTools = ordered + remaining
        } else {
            visibleTools = allTools
        }
    }

    func toggleTool(_ tool: ToolItem) {
        visibleTools.removeAll { $0.id == tool.id }
        saveToDisk()
    }

    func addTool(_ tool: ToolItem) {
        if !visibleTools.contains(where: { $0.id == tool.id }) {
            visibleTools.append(tool)
            saveToDisk()
        }
    }

    func move(from source: IndexSet, to destination: Int) {
        visibleTools.move(fromOffsets: source, toOffset: destination)
        saveToDisk()
    }

    var allAvailable: [ToolItem] {
        ToolItem.builtInTools.filter { $0.isBuiltIn }
    }

    private func saveToDisk() {
        let ids = visibleTools.map { $0.id }
        if let data = try? JSONEncoder().encode(ids) {
            UserDefaults.standard.set(data, forKey: saveKey)
        }
    }
}
