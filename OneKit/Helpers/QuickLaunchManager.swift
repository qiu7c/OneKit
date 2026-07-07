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
            // 首次安装: 默认显示调色板和编解码
            visibleTools = allTools.filter { $0.id == "color-palette" || $0.id == "codec" }
            return
        }
        visibleTools = ids.compactMap { id in allTools.first { $0.id == id } }
    }

    func toggleTool(_ tool: ToolItem) { visibleTools.removeAll { $0.id == tool.id }; write() }
    func addTool(_ tool: ToolItem) { guard !visibleTools.contains(where: { $0.id == tool.id }) else { return }; visibleTools.append(tool); write() }
    func move(from source: IndexSet, to destination: Int) { visibleTools.move(fromOffsets: source, toOffset: destination); write() }
    var allAvailable: [ToolItem] { ToolItem.builtInTools.filter { $0.isBuiltIn } }

    private func write() {
        guard let data = try? JSONEncoder().encode(visibleTools.map { $0.id }) else { return }
        try? data.write(to: fileURL, options: .atomic)
    }
}
