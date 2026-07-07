# OneKit 项目调研记录

## SF Symbols

### API 方案
- **系统 API**: `UIImage(systemName:)` 和 `Image(systemName:)` — SwiftUI 原生支持
- **SF Symbols 5**: iOS 17 内置 SF Symbols 5.0，包含 5000+ 图标
- **分类**: 系统按层级组织 Symbols，但无法直接枚举所有可用图标
- **解决方案**: 提供预置常用分类列表 + 用户搜索，实时渲染

### AppStore 图标下载

#### API 方案 - iTunes Search API (免费)
- **Endpoint**: `https://itunes.apple.com/search?term={query}&entity=software&limit=20`
- **Endpoint**: `https://itunes.apple.com/lookup?id={appId}`
- **图标 URL**: 返回结果中的 `artworkUrl100`, `artworkUrl512`, `artworkUrl1024`
- **限制**: 无需 API key，但有频率限制
- **特点**: 官方 API，稳定可靠

#### 替代方案
- AppStore Connect API - 需要开发者账号和密钥，过于复杂
- 爬虫方案 - 不稳定且违反 ToS

**推荐**: iTunes Search API (无需认证，完全免费)

## 技术调研

### XcodeGen
- 使用 `project.yml` 声明式定义 Xcode 项目
- 自动生成 `.xcodeproj`
- 安装: `brew install xcodegen`

### GitHub Actions 构建 iOS
- 使用 `macos-latest` runner
- 需要配置 Code Signing (可选 - 可先用模拟器构建)
- 核心 action: `apple-actions/import-codesigning-certs@v2`

### 设计趋势 2024-2026
- 玻璃拟态 (Glassmorphism) - 毛玻璃效果
- 渐变色彩 - 多层次渐变背景
- 微交互 - 触感反馈、弹性动画
- 大标题 + 圆角卡片
- SF Pro 字体深度运用
