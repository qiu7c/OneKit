import SwiftUI
import PhotosUI

struct ColorPaletteView: View {
    @StateObject private var viewModel = ColorPaletteViewModel()
    @State private var showCopied = false
    @State private var showImagePicker = false
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var pickedImage: UIImage?
    @State private var showColorPickerSheet = false

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                colorPickerSection
                colorInfoSection
                hexInputSection
                actionButtonsSection
                imageColorPickerSection
                sliderSection
                presetSection
                ColorHarmoniesView(color: viewModel.selectedColor, selectedType: $viewModel.selectedHarmony)
                SavedColorsView(viewModel: viewModel)
            }
            .padding(20)
        }
        .background(Color.appBackground)
        .navigationTitle("调色板")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
        .photosPicker(isPresented: $showImagePicker, selection: $selectedPhoto, matching: .images)
        .onChange(of: selectedPhoto) { _ in
            Task {
                guard let data = try? await selectedPhoto?.loadTransferable(type: Data.self),
                      let img = UIImage(data: data) else { return }
                pickedImage = img
                showColorPickerSheet = true
            }
        }
        .fullScreenCover(isPresented: $showColorPickerSheet) {
            if let img = pickedImage {
                NavigationStack {
                    ImageColorPickerView(image: img) { color in
                        var r: CGFloat = 0; var g: CGFloat = 0; var b: CGFloat = 0; var a: CGFloat = 0
                        UIColor(color).getRed(&r, green: &g, blue: &b, alpha: &a)
                        viewModel.customRed = Double(r); viewModel.customGreen = Double(g); viewModel.customBlue = Double(b)
                        viewModel.updateFromSliders()
                    }
                }
            }
        }
    }

    private var imageColorPickerSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("图片取色").font(.headline).fontWeight(.semibold).foregroundColor(.appForeground)
            Button {
                showImagePicker = true
            } label: {
                HStack {
                    Image(systemName: "photo.on.rectangle").font(.body)
                    Text("从照片取色 — 全屏触控取色")
                }
                .font(.subheadline).fontWeight(.medium)
                .frame(maxWidth: .infinity).frame(height: 44)
                .foregroundColor(.appForeground).background(Color.appCard)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
    }

    private var colorPickerSection: some View {
        VStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 16).fill(viewModel.currentColor).frame(height: 100)
                .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.appSeparator.opacity(0.3), lineWidth: 0.5))
                .overlay(Text(viewModel.hexInput).font(.title2).fontWeight(.bold).foregroundColor(viewModel.selectedColor.isLight ? .black : .white).opacity(0.7))
            ColorPicker("取色器", selection: Binding(get: { viewModel.currentColor }, set: { c in
                var r: CGFloat = 0; var g: CGFloat = 0; var b: CGFloat = 0; var a: CGFloat = 0
                UIColor(c).getRed(&r, green: &g, blue: &b, alpha: &a)
                viewModel.customRed = Double(r); viewModel.customGreen = Double(g); viewModel.customBlue = Double(b); viewModel.customOpacity = Double(a)
                viewModel.updateFromSliders()
            }), supportsOpacity: false).labelsHidden().frame(maxWidth: .infinity, alignment: .center)
        }
    }

    private var colorInfoSection: some View {
        HStack(spacing: 12) {
            infoChip("HEX", viewModel.selectedColor.hexString)
            infoChip("RGB", viewModel.selectedColor.rgbString)
            infoChip("HSL", viewModel.selectedColor.hslString)
        }
    }

    private func infoChip(_ title: String, _ value: String) -> some View {
        VStack(spacing: 4) {
            Text(title).font(.system(size: 9)).fontWeight(.semibold).foregroundColor(.appTertiary)
            Text(value).font(.system(size: 11, design: .monospaced)).foregroundColor(.appForeground).lineLimit(1).minimumScaleFactor(0.7)
        }
        .frame(maxWidth: .infinity).padding(10).background(Color.appCard).clipShape(RoundedRectangle(cornerRadius: 10))
    }

    private var hexInputSection: some View {
        HStack(spacing: 10) {
            TextField("输入 Hex 颜色", text: $viewModel.hexInput).font(.system(.body, design: .monospaced)).textFieldStyle(.plain).padding(12).background(Color.appCard).clipShape(RoundedRectangle(cornerRadius: 10))
            Button { viewModel.applyHexInput(); Haptic.medium() } label: {
                Text("应用").fontWeight(.semibold).foregroundColor(.white).padding(.horizontal, 20).padding(.vertical, 12).background(Color.appForeground).clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
    }

    private var actionButtonsSection: some View {
        HStack(spacing: 10) {
            Button { viewModel.copyHex(viewModel.selectedColor); showCopied = true; DispatchQueue.main.asyncAfter(deadline: .now()+1.5) { showCopied = false } } label: {
                HStack(spacing: 6) { Image(systemName: showCopied ? "checkmark" : "doc.on.doc"); Text(showCopied ? "已复制" : "复制 HEX") }.font(.subheadline).fontWeight(.medium).frame(maxWidth: .infinity).frame(height: 40).foregroundColor(.white).background(Color.appForeground).clipShape(RoundedRectangle(cornerRadius: 10))
            }
            Button { viewModel.copyRGB(viewModel.selectedColor) } label: {
                HStack(spacing: 6) { Image(systemName: "doc.on.doc"); Text("复制 RGB") }.font(.subheadline).fontWeight(.medium).frame(maxWidth: .infinity).frame(height: 40).foregroundColor(.appForeground).background(Color.appCard).clipShape(RoundedRectangle(cornerRadius: 10))
            }
            Button { withAnimation { viewModel.saveCurrentColor() } } label: {
                Image(systemName: "heart").font(.body).foregroundColor(.appForeground).frame(width: 40, height: 40).background(Color.appCard).clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
    }

    private var sliderSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("RGB 调色").font(.headline).fontWeight(.semibold).foregroundColor(.appForeground)
            VStack(spacing: 10) {
                sliderRow("红", .red, $viewModel.customRed)
                sliderRow("绿", .green, $viewModel.customGreen)
                sliderRow("蓝", .blue, $viewModel.customBlue)
                sliderRow("透明度", .gray, $viewModel.customOpacity)
            }
            .onChange(of: viewModel.customRed) { _ in viewModel.updateFromSliders() }
            .onChange(of: viewModel.customGreen) { _ in viewModel.updateFromSliders() }
            .onChange(of: viewModel.customBlue) { _ in viewModel.updateFromSliders() }
            .onChange(of: viewModel.customOpacity) { _ in viewModel.updateFromSliders() }
        }
        .padding(16).background(Color.appCard).clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private func sliderRow(_ label: String, _ color: Color, _ value: Binding<Double>) -> some View {
        HStack {
            Text(label).font(.caption).foregroundColor(.appSecondary).frame(width: 40, alignment: .leading)
            Slider(value: value, in: 0...1).tint(color)
            Text("\(Int(value.wrappedValue * 255))").font(.system(size: 11, design: .monospaced)).foregroundColor(.appSecondary).frame(width: 36, alignment: .trailing)
        }
    }

    private var presetSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("预设颜色").font(.headline).fontWeight(.semibold).foregroundColor(.appForeground)
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 8), spacing: 8) {
                ForEach(PaletteColor.presets) { c in
                    RoundedRectangle(cornerRadius: 10).fill(c.color).frame(height: 40)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.appSeparator.opacity(0.3), lineWidth: 0.5))
                        .overlay(Image(systemName: "checkmark").font(.caption2).foregroundColor(c.textColor).opacity(viewModel.selectedColor.hex == c.hex ? 1 : 0))
                        .onTapGesture { viewModel.selectPreset(c) }
                }
            }
        }
    }
}
