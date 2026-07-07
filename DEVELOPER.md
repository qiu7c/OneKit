# OneKit 开发指南

## 项目结构

```
OneKit/
├── OneKit/
│   ├── OneKitApp.swift            # @main 入口
│   ├── ContentView.swift          # TabView + 设置页
│   │
│   ├── Models/                    # 数据模型
│   │   ├── ToolItem.swift         # 工具分类 + 工具列表
│   │   ├── SFSymbolItem.swift     # SF Symbols 模型
│   │   ├── AppStoreApp.swift      # iTunes API 模型
│   │   └── ColorPalette.swift     # 颜色模型 + 和谐算法
│   │
│   ├── ViewModels/                # MVVM ViewModel
│   │   ├── SFSymbolsViewModel.swift
│   │   ├── IconDownloadViewModel.swift
│   │   ├── ColorPaletteViewModel.swift
│   │   ├── CodecViewModel.swift
│   │   └── HttpRequestViewModel.swift
│   │
│   ├── Views/                     # SwiftUI 视图
│   │   ├── Home/                  # 首页
│   │   ├── SFSymbols/             # SF Symbols 浏览器
│   │   ├── IconDownloader/        # AppStore 图标下载
│   │   ├── ColorPalette/          # 调色板 + 图片取色
│   │   ├── JSONFormatter/         # 编解码工具
│   │   ├── HttpRequest/           # HTTP 请求工具
│   │   ├── WebView/               # 三角洲助手
│   │   └── Components/            # 通用组件
│   │
│   ├── Helpers/                   # 工具类
│   │   ├── Color+Theme.swift      # 主题色定义
│   │   ├── View+Extensions.swift  # 视图扩展
│   │   ├── ThemeManager.swift     # 主题切换管理
│   │   ├── QuickLaunchManager.swift # 首页快捷启动管理
│   │   └── ConfigManager.swift    # 配置导出导入
│   │
│   └── Services/                  # 网络服务
│       ├── SFSymbolService.swift
│       ├── AppStoreService.swift
│       ├── IconCacheManager.swift
│       └── DeltaForceService.swift
│
├── project.yml                    # XcodeGen 配置
├── .github/workflows/build.yml    # CI/CD
└── DEVELOPER.md                    # 本文件
```

## 添加新工具

### 1. 创建文件

```
OneKit/Views/新工具/NewToolView.swift    # 主视图
OneKit/ViewModels/NewToolViewModel.swift # ViewModel (可选)
OneKit/Models/NewToolModel.swift         # 模型 (可选)
```

### 2. 注册工具

在 `Models/ToolItem.swift` 的 `builtInTools` 数组中添加：

```swift
.init(id: "my-tool", title: "我的工具", subtitle: "一句话描述", icon: "xmark", category: .utility, color: "#6366F1", isBuiltIn: true, tags: ["标签"])
```

颜色值用 Hex（如 `#6366F1`），分类选 `ToolCategory` 枚举。

### 3. 添加路由

在以下文件的 `dest()` / `switch` 中添加 case：

- `Views/Home/HomeView.swift` — 首页路由
- `ContentView.swift` — 工具列表页路由

示例：
```swift
case "my-tool": MyNewToolView()
```

### 4. 需要 tabBar 隐藏的工具

在工具 View 末尾加：
```swift
.toolbar(.hidden, for: .tabBar)
```

## 设计规范

### 颜色
- 文字主色：`Color.appForeground` (浅色=黑, 深色=白)
- 背景色：`Color.appBackground` (浅色=白, 深色=黑)
- 卡片色：`Color.appCard`
- 次级文字：`Color.appSecondary`
- 按钮文字在 `Color.appForeground` 背景上：`Color.appBackground`

**不使用** `.white`、`.black`、`Color.white`、`Color.black` 作为文字颜色。

### 按钮
- 主要按钮：`.modernButtonStyle()` (自动适配深色)
- 或手动：`.foregroundColor(Color.appBackground).background(Color.appForeground)`

### 弹窗/新页面
- 不使用 `.alert()` — 使用 `fullScreenCover` 或独立页面
- 不使用重叠 sheets — 用 `.fullScreenCover(item:)` 避免空白

### 数据持久化
- 简单设置：`@AppStorage` 
- 复杂数据：`UserDefaults` + `JSONEncoder`/`JSONDecoder`
- 全部存在本地，不上传

## 构建

```bash
xcodegen generate
swiftc -sdk $(xcrun --show-sdk-path --sdk iphoneos) \
  -target arm64-apple-ios16.0 -module-name OneKit \
  $(find OneKit -name "*.swift") -o Payload/OneKit.app/OneKit
```

或使用完整的 Xcode + GitHub Actions 工作流。
