import SwiftUI

@main
struct OneKitApp: App {
    @StateObject private var themeManager = ThemeManager.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(themeManager.currentTheme.colorScheme)
                .onAppear {
                    themeManager.applyTheme()
                }
        }
    }
}
