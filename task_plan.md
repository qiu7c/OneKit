# OneKit - 综合工具 iOS App 开发计划

## 项目概述
- **项目名称**: OneKit
- **包名**: com.cc.OneKit
- **技术栈**: SwiftUI, iOS 17+
- **设计风格**: 现代化玻璃拟态 (Glassmorphism) + 渐变主题
- **CI/CD**: GitHub Actions 云打包编译
- **仓库**: git@github.com:qiu7c/OneKit.git

## 阶段

### Phase 1: 项目骨架 ✅ 已完成
- [x] 创建目录结构
- [x] XcodeGen project.yml 配置
- [x] .gitignore
- [x] Info.plist

### Phase 2: 基础架构 ✅ 已完成
- [x] 主题色系统 (Color+Theme.swift) — 纯黑/白风格
- [x] 视图扩展 (View+Extensions.swift) — 按压缩放、卡片样式
- [x] App 入口 (OneKitApp.swift)
- [x] 主页面布局 (ContentView.swift) — 三 Tab (主页/工具/设置)

### Phase 3: 数据模型层 ✅ 已完成
- [x] ToolItem.swift - 工具分类模型 (6 分类)
- [x] SFSymbolItem.swift - SF Symbols 模型 (30 个热门)
- [x] AppStoreApp.swift - iTunes API 响应模型

### Phase 4: 服务层 ✅ 已完成
- [x] SFSymbolService.swift - SF Symbols 搜索与分类
- [x] AppStoreService.swift - iTunes Search API
- [x] IconCacheManager.swift - 内存+磁盘两级缓存

### Phase 5: ViewModel 层 ✅ 已完成
- [x] SFSymbolsViewModel.swift — 搜索、分类、详情
- [x] IconDownloadViewModel.swift — 搜索、下载、缓存

### Phase 6: UI - 主页 ✅ 已完成
- [x] HomeView.swift — 头部+快捷工具+卡片网格
- [x] ToolCardView.swift — 工具卡片（黑白极简）

### Phase 7: UI - SF Symbols 浏览器 ✅ 已完成
- [x] SFSymbolsListView.swift — 分类栏+搜索+网格
- [x] SymbolDetailView.swift — 大图预览+复制
- [x] SymbolGridCell.swift — 网格单元+长按菜单

### Phase 8: UI - AppStore 图标下载器 ✅ 已完成
- [x] IconDownloaderView.swift — 搜索+结果列表+空状态
- [x] AppSearchResultRow.swift — 结果行+评级+菜单

### Phase 9: UI - 通用组件 ✅ 已完成
- [x] IconPreviewView.swift — 图标预览+多尺寸下载+保存相册
- [x] 内联组件 (QuickToolCard, ToolRowView, PlaceholderView)

### Phase 10: CI/CD 与部署 ✅ 已完成
- [x] GitHub Actions 工作流 (build.yml)
- [x] Assets.xcassets 资源 (AccentColor, AppIcon)
- [x] README.md
- [x] 单元测试 + UI 测试

## 技术决策记录
| 决策 | 选择 | 理由 |
|------|------|------|
| 框架 | SwiftUI | 现代化声明式 UI，iOS 17+ 支持 |
| 项目生成 | XcodeGen | 避免 git 冲突，易于管理 |
| UI 风格 | 玻璃拟态 + 渐变 | 现代感强，符合 2024-2026 设计趋势 |
| 构建 | GitHub Actions | 云打包编译，无需本地 Xcode |
| SF Symbols 数据源 | 系统 API + 本地 JSON | 离线可用，快速加载 |
| AppStore 图标 | iTunes API (apple.com) | 免费无需密钥 |
