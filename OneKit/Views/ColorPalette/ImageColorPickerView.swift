import SwiftUI

struct ImageColorPickerView: View {
    let image: UIImage
    @Environment(\.dismiss) private var dismiss
    var onColorSelected: (Color) -> Void

    @State private var location: CGPoint = .zero
    @State private var isPicking = false
    @State private var pickedColor: Color = .white
    @State private var pickedHex: String = "#FFFFFF"
    @State private var imageSize: CGSize = .zero

    var body: some View {
        VStack(spacing: 0) {
            // 图片区域 - 占满剩余空间
            GeometryReader { geo in
                let fitSize = image.size.fit(in: geo.size)
                ZStack {
                    Image(uiImage: image)
                        .resizable()
                        .interpolation(.high)
                        .frame(width: fitSize.width, height: fitSize.height)
                        .clipped()
                        .overlay(
                            // 透明触摸层，大小和图片一致
                            Color.clear
                                .frame(width: fitSize.width, height: fitSize.height)
                                .contentShape(Rectangle())
                                .gesture(
                                    DragGesture(minimumDistance: 0)
                                        .onChanged { v in
                                            // 转换触摸坐标到图片坐标
                                            let imgX = (v.location.x / fitSize.width) * image.size.width
                                            let imgY = (v.location.y / fitSize.height) * image.size.height
                                            location = CGPoint(x: imgX, y: imgY)
                                            isPicking = true
                                            updateColor(at: location)
                                        }
                                        .onEnded { _ in
                                            isPicking = false
                                        }
                                )
                        )
                        .position(x: geo.size.width / 2, y: geo.size.height / 2)

                    // 放大镜
                    if isPicking {
                        let loupeSize: CGFloat = 100
                        let scaleX = image.size.width / fitSize.width
                        let scaleY = image.size.height / fitSize.height
                        let viewX = (location.x / scaleX)
                        let viewY = (location.y / scaleY)

                        let cropW: CGFloat = 30
                        let cropRect = CGRect(x: location.x - cropW/2, y: location.y - cropW/2, width: cropW, height: cropW)
                        if let cgImg = image.cgImage?.cropping(to: cropRect) {
                            Image(uiImage: UIImage(cgImage: cgImg))
                                .resizable().interpolation(.none)
                                .frame(width: loupeSize, height: loupeSize)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.white, lineWidth: 2))
                                .overlay(Circle().fill(pickedColor).frame(width: 6, height: 6))
                                .position(x: viewX, y: viewY - 70)
                                .shadow(color: .black.opacity(0.3), radius: 8)
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }

            // 底部信息栏
            VStack(spacing: 10) {
                HStack(spacing: 14) {
                    RoundedRectangle(cornerRadius: 8).fill(pickedColor).frame(width: 40, height: 40)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.appSeparator, lineWidth: 0.5))
                    Text(pickedHex).font(.system(.title3, design: .monospaced)).fontWeight(.bold).foregroundColor(.appForeground)
                    Text("\(Int((pickedColor.toRGB().r)*255)),\(Int((pickedColor.toRGB().g)*255)),\(Int((pickedColor.toRGB().b)*255))")
                        .font(.caption).foregroundColor(.appSecondary)
                    Spacer()
                    Text("手指滑动取色").font(.caption).foregroundColor(.appTertiary)
                }
                .padding(.horizontal)

                HStack(spacing: 12) {
                    Button { dismiss() } label: {
                        Text("取消").font(.headline).foregroundColor(.appSecondary).frame(maxWidth: .infinity).frame(height: 44).background(Color.appCard).clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    Button {
                        onColorSelected(pickedColor)
                        Haptic.success()
                        dismiss()
                    } label: {
                        Text("使用此颜色").font(.headline).fontWeight(.semibold).foregroundColor(.white).frame(maxWidth: .infinity).frame(height: 44).background(Color.appForeground).clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 12)
            }
            .background(Color.appBackground)
        }
        .background(Color.appBackground)
        .navigationTitle("图片取色")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar { ToolbarItem(placement: .navigationBarTrailing) { Button("关闭") { dismiss() } } }
    }

    private func updateColor(at point: CGPoint) {
        guard let color = image.getPixelColor(at: point) else { return }
        pickedColor = color
        var r: CGFloat = 0; var g: CGFloat = 0; var b: CGFloat = 0; var a: CGFloat = 0
        UIColor(color).getRed(&r, green: &g, blue: &b, alpha: &a)
        pickedHex = String(format: "#%02X%02X%02X", Int(r*255), Int(g*255), Int(b*255))
    }
}

// MARK: - 图片尺寸适配
extension CGSize {
    func fit(in container: CGSize) -> CGSize {
        let scale = min(container.width / width, container.height / height)
        return CGSize(width: width * scale, height: height * scale)
    }
}

// MARK: - UIImage 像素取色
extension UIImage {
    func getPixelColor(at point: CGPoint) -> Color? {
        guard point.x >= 0, point.x < size.width, point.y >= 0, point.y < size.height,
              let cgImage = cgImage else { return nil }
        let w = Int(size.width); let h = Int(size.height)
        var data = [UInt8](repeating: 0, count: w * h * 4)
        let ctx = CGContext(data: &data, width: w, height: h, bitsPerComponent: 8, bytesPerRow: w * 4, space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)
        ctx?.draw(cgImage, in: CGRect(x: 0, y: 0, width: w, height: h))
        let x = Int(point.x); let y = Int(point.y)
        let offset = (y * w + x) * 4
        guard offset + 3 < data.count else { return nil }
        return Color(red: Double(data[offset])/255, green: Double(data[offset+1])/255, blue: Double(data[offset+2])/255)
    }
}

extension Color {
    func toRGB() -> (r: CGFloat, g: CGFloat, b: CGFloat) {
        var r: CGFloat = 0; var g: CGFloat = 0; var b: CGFloat = 0
        UIColor(self).getRed(&r, green: &g, blue: &b, alpha: nil)
        return (r, g, b)
    }
}
