import SwiftUI

final class QuickLaunchManager: ObservableObject {
    static let shared = QuickLaunchManager()
    @Published var visibleTools: [ToolItem] = []
    private let fileName = "ql_tools.json"

    private init() { load() }

    private var fileURL: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(fileName)
    }

    private func load() {
        let allTools = ToolItem.builtInTools.filter { $0.isBuiltIn }
        guard let data = try? Data(contentsOf: fileURL),
              let ids = try? JSONDecoder().decode([String].self, from: data),
              !ids.isEmpty else {
            visibleTools = allTools
            return
        }
        // 只显示保存的工具，不加回已隐藏的
        visibleTools = ids.compactMap { id in allTools.first { $0.id == id } }
    }

    func toggleTool(_ tool: ToolItem) {
        visibleTools.removeAll { $0.id == tool.id }
        write()
    }

    func addTool(_ tool: ToolItem) {
        guard !visibleTools.contains(where: { $0.id == tool.id }) else { return }
        visibleTools.append(tool)
        write()
    }

    func move(from source: IndexSet, to destination: Int) {
        visibleTools.move(fromOffsets: source, toOffset: destination)
        write()
    }

    var allAvailable: [ToolItem] { ToolItem.builtInTools.filter { $0.isBuiltIn } }

    private func write() {
        let ids = visibleTools.map { $0.id }
        guard let data = try? JSONEncoder().encode(ids) else { return }
        try? data.write(to: fileURL, options: .atomic)
    }
}
