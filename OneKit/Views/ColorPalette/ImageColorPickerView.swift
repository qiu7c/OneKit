import SwiftUI

struct ImageColorPickerView: View {
    let image: UIImage
    @Environment(\.dismiss) private var dismiss
    var onColorSelected: (Color) -> Void

    @State private var touchLocation: CGPoint = .zero
    @State private var isPicking = false
    @State private var pickedColor: Color = .white
    @State private var pickedHex: String = "#FFFFFF"
    @State private var imageScale: CGFloat = 1.0
    @State private var imageOffset: CGSize = .zero
    @State private var pixelData: [UInt8]?
    @State private var imageW: Int = 0
    @State private var imageH: Int = 0

    private let maxImageHeight: CGFloat = UIScreen.main.bounds.height * 0.72

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // 图片区域 (约72% 屏幕)
                ZStack {
                    Color.black.opacity(0.03)

                    Image(uiImage: image)
                        .resizable()
                        .interpolation(.high)
                        .aspectRatio(contentMode: .fit)
                        .scaleEffect(imageScale)
                        .offset(imageOffset)
                        .gesture(
                            MagnificationGesture()
                                .onChanged { val in
                                    imageScale = max(1.0, min(4.0, val))
                                }
                        )
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { val in
                                    let scale = imageScale
                                    let pos = val.location
                                    // 转换触摸点到图片实际坐标
                                    let imgW = image.size.width
                                    let imgH = image.size.height
                                    let viewW = UIScreen.main.bounds.width
                                    let viewH = maxImageHeight
                                    let fitScale = min(viewW / imgW, viewH / imgH)
                                    let drawW = imgW * fitScale * scale
                                    let drawH = imgH * fitScale * scale
                                    let drawX = (viewW - drawW) / 2 + imageOffset.width
                                    let drawY = (viewH - drawH) / 2 + imageOffset.height

                                    let imgX = ((pos.x - drawX) / (drawW)) * imgW * scale
                                    let imgY = ((pos.y - drawY) / (drawH)) * imgH * scale

                                    let pt = CGPoint(x: max(0, min(imgW-1, imgX)), y: max(0, min(imgH-1, imgY)))
                                    touchLocation = pt
                                    isPicking = true
                                    updateColor(at: pt)
                                }
                                .onEnded { _ in
                                    isPicking = false
                                }
                        )

                    // 放大镜
                    if isPicking {
                        loupeView
                    }
                }
                .frame(height: maxImageHeight)
                .clipped()
                .overlay(Rectangle().stroke(Color.appSeparator.opacity(0.3), lineWidth: 0.5))

                // 紧凑底部栏
                VStack(spacing: 10) {
                    HStack(spacing: 12) {
                        RoundedRectangle(cornerRadius: 8).fill(pickedColor).frame(width: 36, height: 36)
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.appSeparator, lineWidth: 0.5))

                        Text(pickedHex).font(.system(.title3, design: .monospaced)).fontWeight(.bold).foregroundColor(.appForeground)

                        Text("\(Int(pickedColor.toRGB().r*255)),\(Int(pickedColor.toRGB().g*255)),\(Int(pickedColor.toRGB().b*255))")
                            .font(.caption).foregroundColor(.appSecondary)

                        Spacer()

                        Text("缩放: \(Int(imageScale))x").font(.caption2).foregroundColor(.appTertiary)
                    }
                    .padding(.horizontal)

                    Button {
                        onColorSelected(pickedColor)
                        Haptic.success()
                        dismiss()
                    } label: {
                        Text("使用此颜色").fontWeight(.semibold).foregroundColor(.white)
                            .frame(maxWidth: .infinity).frame(height: 44)
                            .background(Color.appForeground).clipShape(RoundedRectangle(cornerRadius: 10))
                            .padding(.horizontal)
                    }
                }
                .padding(.vertical, 8)
                .background(Color.appBackground)
            }
            .background(Color.appBackground)
            .navigationTitle("图片取色")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("关闭") { dismiss() }.foregroundColor(.appForeground)
                }
            }
            .onAppear { cachePixelData() }
        }
    }

    // MARK: - 放大镜
    private var loupeView: some View {
        let loupeSize: CGFloat = 90
        // 在图片上定位放大镜
        let viewW = UIScreen.main.bounds.width
        let viewH = maxImageHeight
        let fitScale = min(viewW / image.size.width, viewH / image.size.height)
        let drawW = image.size.width * fitScale * imageScale
        let drawH = image.size.height * fitScale * imageScale
        let drawX = (viewW - drawW) / 2 + imageOffset.width
        let drawY = (viewH - drawH) / 2 + imageOffset.height
        let viewX = drawX + (touchLocation.x / image.size.width) * drawW
        let viewY = drawY + (touchLocation.y / image.size.height) * drawH

        let cropSize: CGFloat = 24
        let cropRect = CGRect(x: touchLocation.x - cropSize/2, y: touchLocation.y - cropSize/2, width: cropSize, height: cropSize)
        let cgImg = image.cgImage?.cropping(to: cropRect)

        return Group {
            if let cgImg {
                Image(uiImage: UIImage(cgImage: cgImg))
                    .resizable().interpolation(.none)
                    .frame(width: loupeSize, height: loupeSize)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 2.5))
                    .overlay(Circle().fill(pickedColor).frame(width: 5, height: 5))
                    .position(x: min(viewW - 50, max(50, viewX)), y: max(loupeSize/2 + 10, viewY - loupeSize/2 - 10))
                    .shadow(color: .black.opacity(0.25), radius: 8)
            }
        }
    }

    // MARK: - 缓存像素数据
    private func cachePixelData() {
        guard let cg = image.cgImage else { return }
        imageW = cg.width; imageH = cg.height
        var data = [UInt8](repeating: 0, count: imageW * imageH * 4)
        let ctx = CGContext(data: &data, width: imageW, height: imageH, bitsPerComponent: 8, bytesPerRow: imageW * 4, space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)
        ctx?.draw(cg, in: CGRect(x: 0, y: 0, width: imageW, height: imageH))
        pixelData = data
        // 初始化取中心点颜色
        let center = CGPoint(x: imageW / 2, y: imageH / 2)
        updateColor(at: center)
    }

    // MARK: - 从缓存中取色 (不重复渲染)
    private func updateColor(at point: CGPoint) {
        guard let data = pixelData else { return }
        let x = Int(point.x); let y = Int(point.y)
        guard x >= 0, x < imageW, y >= 0, y < imageH else { return }
        let offset = (y * imageW + x) * 4
        guard offset + 3 < data.count else { return }
        let r = data[offset], g = data[offset+1], b = data[offset+2]
        pickedColor = Color(red: Double(r)/255, green: Double(g)/255, blue: Double(b)/255)
        pickedHex = String(format: "#%02X%02X%02X", r, g, b)
    }
}

extension Color {
    func toRGB() -> (r: CGFloat, g: CGFloat, b: CGFloat) {
        var r: CGFloat = 0; var g: CGFloat = 0; var b: CGFloat = 0
        UIColor(self).getRed(&r, green: &g, blue: &b, alpha: nil)
        return (r, g, b)
    }
}
