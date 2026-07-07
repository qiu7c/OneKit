# OneKit 🧰

> 综合工具集 — SF Symbols 浏览器 · AppStore 图标下载 · 更多工具开发中

![Platform](https://img.shields.io/badge/platform-iOS%2016%2B-black)
![Swift](https://img.shields.io/badge/swift-5.7%2B-orange)
![License](https://img.shields.io/badge/license-MIT-blue)

## 📱 简介

**OneKit** 是一个面向 iOS 开发者和设计师的综合工具应用。采用纯黑白现代设计风格，提供高效的工具集合。

### 当前功能

| 工具 | 说明 | 状态 |
|------|------|------|
| 🔤 SF Symbols | 浏览、搜索、预览 SF Symbols 图标 | ✅ 可用 |
| 📲 AppStore 图标下载 | 搜索并下载任意 App 的高清图标 | ✅ 可用 |

### 规划中

- 🎨 调色板工具
- 🔧 JSON 格式化工具
- 📱 二维码生成器
- 🖼 图片压缩工具
- 🌐 IP 网络工具
- 📝 正则表达式测试

## 🛠 技术栈

- **语言**: Swift 5.7+
- **框架**: SwiftUI
- **目标**: iOS 16.0+
- **设计**: 纯黑/白极简风格
- **项目管理**: XcodeGen (`project.yml`)

## 🚀 开始使用

### 前置条件

- Xcode 15.0+
- [XcodeGen](https://github.com/yonaskolb/XcodeGen) (可选，用于生成 .xcodeproj)

### 构建步骤

```bash
# 1. 克隆仓库
git clone https://github.com/qiu7c/OneKit.git
cd OneKit

# 2. 生成 Xcode 项目 (需要安装 XcodeGen)
brew install xcodegen
xcodegen generate

# 3. 打开并运行
open OneKit.xcodeproj
```

### 手动创建项目

如果不想安装 XcodeGen，可以直接在 Xcode 中：
1. 新建 iOS App 项目
2. 选择 SwiftUI + Swift
3. Bundle Identifier: `com.cc.OneKit`
4. 将 `OneKit/` 目录下的源文件拖入项目

## 🔄 GitHub Actions

本项目配置了 GitHub Actions 自动构建流程：

- **Push/PR**: 自动编译检查
- **Release**: main 分支推送时自动 Archive
- **手动触发**: 可通过 GitHub Actions 页面手动触发

构建产物以 Artifact 形式保存，可在 Actions 页面下载。

## 📄 项目结构

```
OneKit/
├── project.yml              # XcodeGen 项目配置
├── OneKit/
│   ├── OneKitApp.swift       # App 入口
│   ├── ContentView.swift     # 主 Tab 页面
│   ├── Models/               # 数据模型
│   ├── ViewModels/           # ViewModel 层
│   ├── Views/                # UI 视图
│   │   ├── Home/             # 主页
│   │   ├── SFSymbols/        # SF Symbols 浏览器
│   │   ├── IconDownloader/   # AppStore 图标下载
│   │   └── Components/       # 通用组件
│   ├── Services/             # 服务层
│   ├── Helpers/              # 扩展工具
│   └── Resources/            # 资源文件
├── .github/workflows/        # CI/CD 配置
└── README.md
```

## 📄 许可证

MIT License

---

**OneKit** — Made with ❤️
