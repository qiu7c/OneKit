import SwiftUI
import PhotosUI

struct ColorPaletteView: View {
    @StateObject private var viewModel = ColorPaletteViewModel()
    @State private var showCopied = false; @State private var showCopiedRGB = false; @State private var showImageFlow = false

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // 色块 + 取色器
                VStack(spacing: 10) {
                    RoundedRectangle(cornerRadius: 14).fill(viewModel.currentColor).frame(height: 90)
                        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.appSeparator.opacity(0.3), lineWidth: 0.5))
                        .overlay(Text(viewModel.hexInput).font(.title2).fontWeight(.bold).foregroundColor(viewModel.selectedColor.isLight ? .black : .white).opacity(0.7))

                    ColorPicker("取色器", selection: Binding(get: { viewModel.currentColor }, set: { c in
                        var r: CGFloat=0; var g: CGFloat=0; var b: CGFloat=0; var a: CGFloat=0
                        UIColor(c).getRed(&r, green: &g, blue: &b, alpha: &a)
                        viewModel.customRed = Double(r); viewModel.customGreen = Double(g); viewModel.customBlue = Double(b); viewModel.customOpacity = Double(a)
                        viewModel.updateFromSliders()
                    }), supportsOpacity: false).labelsHidden().frame(maxWidth: .infinity, alignment: .center)
                }

                // 颜色信息
                HStack(spacing: 10) {
                    infoChip("HEX", viewModel.selectedColor.hexString)
                    infoChip("RGB", viewModel.selectedColor.rgbString)
                    infoChip("HSL", viewModel.selectedColor.hslString)
                }

                // Hex 输入 + 操作
                HStack(spacing: 8) {
                    TextField("Hex 颜色", text: $viewModel.hexInput).font(.system(.body, design: .monospaced)).textFieldStyle(.plain).padding(10).background(Color.appCard).clipShape(RoundedRectangle(cornerRadius: 8))
                    Button { viewModel.applyHexInput(); Haptic.medium() } label: { Text("应用").fontWeight(.semibold).foregroundColor(Color.appBackground).padding(.horizontal, 16).padding(.vertical, 10).background(Color.appForeground).clipShape(RoundedRectangle(cornerRadius: 8)) }
                }

                // 操作按钮
                HStack(spacing: 8) {
                    Button { viewModel.copyHex(viewModel.selectedColor); showCopied = true; DispatchQueue.main.asyncAfter(deadline: .now()+1.5) { showCopied = false } } label: {
                        HStack(spacing: 4) { Image(systemName: showCopied ? "checkmark" : "doc.on.doc"); Text(showCopied ? "已复制" : "HEX") }.font(.subheadline).fontWeight(.medium).frame(maxWidth: .infinity).frame(height: 36).foregroundColor(Color.appBackground).background(Color.appForeground).clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    Button { viewModel.copyRGB(viewModel.selectedColor); showCopiedRGB = true; DispatchQueue.main.asyncAfter(deadline: .now()+1.5) { showCopiedRGB = false } } label: {
                        HStack(spacing: 4) { Image(systemName: showCopiedRGB ? "checkmark" : "doc.on.doc"); Text(showCopiedRGB ? "已复制" : "RGB") }.font(.subheadline).fontWeight(.medium).frame(maxWidth: .infinity).frame(height: 36).foregroundColor(.appForeground).background(Color.appCard).clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    Button { withAnimation { viewModel.saveCurrentColor() } } label: { Image(systemName: "heart").font(.body).foregroundColor(.appForeground).frame(width: 36, height: 36).background(Color.appCard).clipShape(RoundedRectangle(cornerRadius: 8)) }
                }

                // 图片取色
                Button { showImageFlow = true } label: {
                    HStack { Image(systemName: "photo.on.rectangle"); Text("从图片取色") }.font(.subheadline).fontWeight(.medium).frame(maxWidth: .infinity).frame(height: 40).foregroundColor(.appForeground).background(Color.appCard).clipShape(RoundedRectangle(cornerRadius: 10))
                }

                // RGB 滑块
                VStack(alignment: .leading, spacing: 10) {
                    Text("RGB").font(.headline).fontWeight(.semibold).foregroundColor(.appForeground)
                    VStack(spacing: 8) {
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
                .padding(14).background(Color.appCard).clipShape(RoundedRectangle(cornerRadius: 12))

                // 已保存颜色
                SavedColorsView(viewModel: viewModel)
            }
            .padding(16)
        }
        .background(Color.appBackground)
        .navigationTitle("调色板").navigationBarTitleDisplayMode(.inline).toolbar(.hidden, for: .tabBar)
        .fullScreenCover(isPresented: $showImageFlow) {
            ImagePickFlowView { color in
                if let c = color { var r: CGFloat=0; var g: CGFloat=0; var b: CGFloat=0; var a: CGFloat=0; UIColor(c).getRed(&r, green: &g, blue: &b, alpha: &a); viewModel.customRed = Double(r); viewModel.customGreen = Double(g); viewModel.customBlue = Double(b); viewModel.updateFromSliders() }
            }
        }
    }

    private func infoChip(_ t: String, _ v: String) -> some View {
        VStack(spacing: 2) { Text(t).font(.system(size: 8)).fontWeight(.semibold).foregroundColor(.appTertiary); Text(v).font(.system(size: 10, design: .monospaced)).foregroundColor(.appForeground).lineLimit(1).minimumScaleFactor(0.7) }.frame(maxWidth: .infinity).padding(8).background(Color.appCard).clipShape(RoundedRectangle(cornerRadius: 8))
    }

    private func sliderRow(_ l: String, _ c: Color, _ v: Binding<Double>) -> some View {
        HStack { Text(l).font(.caption).foregroundColor(.appSecondary).frame(width: 32, alignment: .leading); Slider(value: v, in: 0...1).tint(c); Text("\(Int(v.wrappedValue * 255))").font(.system(size: 10, design: .monospaced)).foregroundColor(.appSecondary).frame(width: 32, alignment: .trailing) }
    }
}

struct ImagePickFlowView: View {
    @Environment(\.dismiss) private var dismiss; let onComplete: (Color?) -> Void
    @State private var pickedImage: UIImage?; @State private var showPHPicker = true
    var body: some View {
        NavigationStack {
            if let img = pickedImage { ImageColorPickerView(image: img) { c in onComplete(c); dismiss() } }
            else { Color.clear.onAppear { showPHPicker = true }.sheet(isPresented: $showPHPicker) { PhotoPickerView { img in pickedImage = img; showPHPicker = false } } }
        }
    }
}
struct PhotoPickerView: UIViewControllerRepresentable {
    let onPick: (UIImage) -> Void
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var c = PHPickerConfiguration(); c.filter = .images; c.selectionLimit = 1; let p = PHPickerViewController(configuration: c); p.delegate = context.coordinator; return p
    }
    func updateUIViewController(_: PHPickerViewController, context: Context) {}
    func makeCoordinator() -> Coordinator { Coordinator(onPick: onPick) }
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let onPick: (UIImage) -> Void; init(onPick: @escaping (UIImage) -> Void) { self.onPick = onPick }
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            guard let result = results.first, result.itemProvider.canLoadObject(ofClass: UIImage.self) else { return }
            result.itemProvider.loadObject(ofClass: UIImage.self) { img, _ in if let image = img as? UIImage { DispatchQueue.main.async { self.onPick(image) } } }
        }
    }
}
