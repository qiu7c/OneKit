import SwiftUI

// MARK: - 全屏图片取色器
struct ImageColorPickerView: View {
    let image: UIImage
    @Environment(\.dismiss) private var dismiss
    var onColorSelected: (Color) -> Void

    @State private var location: CGPoint = .zero
    @State private var isPicking = false
    @State private var pickedColor: Color = .white
    @State private var pickedHex: String = "#FFFFFF"
    @State private var showConfirm = false

    var body: some View {
        VStack(spacing: 0) {
            // 图片区域
            ZStack {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .overlay(Color.clear.contentShape(Rectangle()))
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { v in
                                location = v.location
                                isPicking = true
                                updateColor(at: v.location)
                            }
                            .onEnded { _ in
                                isPicking = false
                                showConfirm = true
                            }
                    )

                // 放大镜
                if isPicking {
                    MagnifierLoupe(image: image, location: location, pickedColor: pickedColor)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            // 底部信息
            VStack(spacing: 12) {
                HStack(spacing: 16) {
                    RoundedRectangle(cornerRadius: 10).fill(pickedColor).frame(width: 48, height: 48)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.appSeparator, lineWidth: 0.5))

                    VStack(alignment: .leading, spacing: 2) {
                        Text(pickedHex).font(.system(.title3, design: .monospaced)).fontWeight(.bold).foregroundColor(.appForeground)
                        Text("RGB(\(Int((pickedColor.toRGB().r))*255), \(Int((pickedColor.toRGB().g))*255), \(Int((pickedColor.toRGB().b))*255))")
                            .font(.caption).foregroundColor(.appSecondary)
                    }
                    Spacer()
                }
                .padding(.horizontal)

                HStack(spacing: 12) {
                    Button { dismiss() } label: {
                        Text("取消").font(.headline).foregroundColor(.appSecondary).frame(maxWidth: .infinity).frame(height: 44).background(Color.appCard).clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    Button {
                        onColorSelected(pickedColor)
                        dismiss()
                    } label: {
                        Text("使用此颜色").font(.headline).fontWeight(.semibold).foregroundColor(.white).frame(maxWidth: .infinity).frame(height: 44).background(Color.appForeground).clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 16)
            }
            .background(Color.appBackground)
        }
        .background(Color.appBackground)
        .navigationTitle("图片取色")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            // 默认取中心点颜色
            location = CGPoint(x: image.size.width / 2, y: image.size.height / 2)
            updateColor(at: location)
        }
    }

    private func updateColor(at point: CGPoint) {
        let scale = image.size.width / UIScreen.main.bounds.width
        let imgPoint = CGPoint(x: point.x * scale, y: point.y * scale)
        guard let color = image.getPixelColor(at: imgPoint) else { return }
        pickedColor = color
        var r: CGFloat = 0; var g: CGFloat = 0; var b: CGFloat = 0; var a: CGFloat = 0
        UIColor(color).getRed(&r, green: &g, blue: &b, alpha: &a)
        pickedHex = String(format: "#%02X%02X%02X", Int(r*255), Int(g*255), Int(b*255))
    }
}

// MARK: - 放大镜
struct MagnifierLoupe: View {
    let image: UIImage
    let location: CGPoint
    let pickedColor: Color

    var body: some View {
        GeometryReader { geo in
            let scale = image.size.width / geo.size.width
            let imgX = location.x * scale
            let imgY = location.y * scale
            let cropSize: CGFloat = 40
            let cropRect = CGRect(x: imgX - cropSize/2, y: imgY - cropSize/2, width: cropSize, height: cropSize)

            if let cgImage = image.cgImage?.cropping(to: cropRect) {
                let loupeSize: CGFloat = 120
                Image(uiImage: UIImage(cgImage: cgImage))
                    .resizable()
                    .interpolation(.none)
                    .frame(width: loupeSize, height: loupeSize)
                    .clipShape(Circle())
                    .overlay(
                        ZStack {
                            Circle().stroke(Color.white, lineWidth: 3)
                            // 十字准星
                            Path { p in
                                p.move(to: CGPoint(x: loupeSize/2, y: 0))
                                p.addLine(to: CGPoint(x: loupeSize/2, y: loupeSize))
                                p.move(to: CGPoint(x: 0, y: loupeSize/2))
                                p.addLine(to: CGPoint(x: loupeSize, y: loupeSize/2))
                            }
                            .stroke(Color.white.opacity(0.8), lineWidth: 1)
                            Circle().fill(pickedColor).frame(width: 6, height: 6)
                        }
                    )
                    .position(location)
                    .offset(y: -80)
                    .shadow(color: .black.opacity(0.3), radius: 10)
            }
        }
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
        return Color(red: Double(data[offset])/255, green: Double(data[offset+1])/255, blue: Double(data[offset+2])/255, opacity: 1)
    }
}

// MARK: - Color -> RGB
extension Color {
    func toRGB() -> (r: CGFloat, g: CGFloat, b: CGFloat) {
        var r: CGFloat = 0; var g: CGFloat = 0; var b: CGFloat = 0; var a: CGFloat = 0
        UIColor(self).getRed(&r, green: &g, blue: &b, alpha: &a)
        return (r, g, b)
    }
}
