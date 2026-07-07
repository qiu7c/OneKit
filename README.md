<div align="center">

# OneKit 🧰

**iOS All-in-One Toolkit**

[![iOS](https://img.shields.io/badge/iOS-16.0+-000?style=flat)](https://developer.apple.com/ios/)
[![Swift](https://img.shields.io/badge/Swift-5.7-FA7343?style=flat)](https://swift.org)

</div>

---

## 📱 Installation

via **TrollStore**:
1. Download the [latest IPA](https://github.com/qiu7c/OneKit/releases)
2. Share to TrollStore → Install

---

## 🏗 Build

```bash
git clone https://github.com/qiu7c/OneKit.git
cd OneKit
brew install xcodegen
xcodegen generate
open OneKit.xcodeproj
```

---

## 🏛 Project Structure

```
OneKit/
├── OneKit/
│   ├── OneKitApp.swift
│   ├── ContentView.swift
│   ├── Helpers/
│   ├── Models/
│   ├── ViewModels/
│   ├── Views/
│   │   ├── Home/          # Home page
│   │   ├── SFSymbols/     # SF Symbols browser
│   │   ├── IconDownloader/ # App Store icons
│   │   ├── ColorPalette/  # Color tools
│   │   ├── JSONFormatter/ # Codec tool
│   │   └── Components/    # Shared UI
│   └── Services/          # API services
├── project.yml            # XcodeGen config
├── .github/workflows/     # CI/CD
└── README.md
```

---

## 📦 Tech

| | |
|---|---|
| Swift 5.7 · SwiftUI | iOS 16.0+ |
| XcodeGen | `com.cc.OneKit` |

---

<div align="center">MIT</div>
