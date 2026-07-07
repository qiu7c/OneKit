import SwiftUI

extension View {
    func cardStyle(cornerRadius: CGFloat = 16) -> some View {
        self.background(Color.appCard).clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
    }

    func modernButtonStyle() -> some View {
        self.font(.headline).fontWeight(.semibold)
            .foregroundColor(Color.appBackground)
            .frame(maxWidth: .infinity).frame(height: 50)
            .background(Color.appForeground)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }

    @ViewBuilder
    func pressableScale(action: @escaping () -> Void) -> some View {
        Button(action: action) { self }.buttonStyle(ScaleButtonStyle())
    }

    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition { transform(self) } else { self }
    }
}

import Combine

// MARK: - onChange iOS 16/17 兼容
extension View {
    /// 兼容 iOS 16 和 17 的 onChange（使用 onReceive 避免签名冲突）
    func onChangeCompat<T: Equatable>(of value: T, perform action: @escaping () -> Void) -> some View {
        self.onReceive(Just(value).dropFirst()) { _ in action() }
    }
}

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label.scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(.interpolatingSpring(mass: 1, stiffness: 200, damping: 15), value: configuration.isPressed)
    }
}

enum Haptic {
    static func light() { UIImpactFeedbackGenerator(style: .light).impactOccurred() }
    static func medium() { UIImpactFeedbackGenerator(style: .medium).impactOccurred() }
    static func selection() { UISelectionFeedbackGenerator().selectionChanged() }
    static func success() { UINotificationFeedbackGenerator().notificationOccurred(.success) }
    static func error() { UINotificationFeedbackGenerator().notificationOccurred(.error) }
}
