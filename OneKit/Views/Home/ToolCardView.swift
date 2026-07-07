import SwiftUI

// MARK: - 工具卡片
struct ToolCardView: View {
    let tool: ToolItem

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // 图标
            Image(systemName: tool.icon)
                .font(.title2)
                .foregroundColor(Color.iconTint(for: tool.color))
                .frame(width: 36, height: 36)
                .background(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(Color.iconTint(for: tool.color).opacity(0.08))
                )

            Spacer()

            // 标题
            Text(tool.title)
                .font(.body)
                .fontWeight(.semibold)
                .foregroundColor(.appForeground)
                .lineLimit(1)

            // 副标题
            Text(tool.subtitle)
                .font(.caption)
                .foregroundColor(.appSecondary)
                .lineLimit(2)

            // 状态标签
            if !tool.isBuiltIn {
                HStack(spacing: 4) {
                    Image(systemName: "hammer.fill")
                        .font(.caption2)
                    Text("开发中")
                        .font(.caption2)
                }
                .foregroundColor(.appSecondary)
                .padding(.horizontal, 8)
                .padding(.vertical, 3)
                .background(Color.appCardAlt)
                .clipShape(Capsule())
            }
        }
        .padding(14)
        .frame(height: 150)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.appCard)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(Color.appSeparator.opacity(0.3), lineWidth: 0.5)
        )
    }
}
