# OneKit 🧰

> iOS 综合工具集 — SF Symbols 浏览器 · AppStore 图标下载 · 调色板 · 主题切换

![Platform](https://img.shields.io/badge/iOS-16%2B-black)
![Swift](https://img.shields.io/badge/Swift-5.7-orange)

## 功能

| 工具 | 说明 |
|------|------|
| 🔤 SF Symbols | 浏览 6000+ SF Symbols，搜索预览，复制名称，保存 PNG |
| 📲 AppStore 图标下载 | 搜索 AppStore 应用，下载多尺寸高清图标 |
| 🎨 调色板 | 预设色板，RGB 调色，色彩和谐分析，收藏颜色 |
| 🌗 主题切换 | 纯黑 / 纯白 / 跟随系统 |

## 安装

通过 [TrollStore](https://github.com/opa334/TrollStore) 安装：

1. 下载 [最新 IPA](https://github.com/qiu7c/OneKit/releases)
2. 分享到 TrollStore → Install

## 构建

```bash
# 1. 安装 XcodeGen
brew install xcodegen

# 2. 生成 Xcode 项目
xcodegen generate

# 3. 构建
xcodebuild build -project OneKit.xcodeproj -scheme OneKit -destination generic/platform=iOS -configuration Release
```

## 技术栈

- **语言**: Swift 5.7
- **框架**: SwiftUI
- **最低版本**: iOS 16.0
- **包管理**: SwiftPM (SFSafeSymbols)
- **项目生成**: XcodeGen
- **CI/CD**: GitHub Actions
- **包名**: `com.cc.OneKit`

## 项目结构

```
OneKit/
├── OneKit/
│   ├── OneKitApp.swift       # 入口
│   ├── ContentView.swift     # 主 Tab 页
│   ├── Helpers/              # 主题、扩展
│   ├── Models/               # 数据模型
│   ├── ViewModels/           # ViewModel
│   ├── Views/                # UI 页面
│   │   ├── Home/             # 主页
│   │   ├── SFSymbols/        # SF Symbols 浏览器
│   │   ├── IconDownloader/   # 图标下载
│   │   ├── ColorPalette/     # 调色板
│   │   └── Components/       # 通用组件
│   ├── Services/             # 网络服务、缓存
│   └── Resources/            # 资源文件
├── project.yml               # XcodeGen 配置
├── .github/workflows/        # CI/CD
└── README.md
```

## License

MIT
