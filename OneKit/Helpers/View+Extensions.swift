import SwiftUI

// MARK: - 视图扩展
extension View {
    /// 卡片样式 - 纯白/黑风格
    func cardStyle(cornerRadius: CGFloat = 16) -> some View {
        self
            .background(Color.appCard)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
    }

    /// 现代按钮样式
    func modernButtonStyle() -> some View {
        self
            .font(.headline)
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(Color.appForeground)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }

    /// 按压缩放效果
    @ViewBuilder
    func pressableScale(action: @escaping () -> Void) -> some View {
        Button(action: action) {
            self
        }
        .buttonStyle(ScaleButtonStyle())
    }

    /// 条件修饰符
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}

// MARK: - 自定义按钮样式
struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(.interpolatingSpring(mass: 1, stiffness: 200, damping: 15), value: configuration.isPressed)
    }
}

// MARK: - Haptic 反馈
enum Haptic {
    static func light() { UIImpactFeedbackGenerator(style: .light).impactOccurred() }
    static func medium() { UIImpactFeedbackGenerator(style: .medium).impactOccurred() }
    static func selection() { UISelectionFeedbackGenerator().selectionChanged() }
    static func success() { UINotificationFeedbackGenerator().notificationOccurred(.success) }
    static func error() { UINotificationFeedbackGenerator().notificationOccurred(.error) }
}

// MARK: - 导航扩展 (iOS 16+)
extension NavigationLink where Destination == Never {
    public init(title: String, @ViewBuilder label: () -> Label) {
        self.init(destination: EmptyView(), label: label)
    }
}
