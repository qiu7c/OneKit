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
    @State private var pixelData: [UInt8]?
    @State private var imgW: Int = 0
    @State private var imgH: Int = 0

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                GeometryReader { geo in
                    let areaH = geo.size.height
                    ZStack {
                        Color.black.opacity(0.03)
                        Image(uiImage: image).resizable().interpolation(.high).aspectRatio(contentMode: .fit)
                            .scaleEffect(imageScale)
                            .gesture(MagnificationGesture().onChanged { v in imageScale = max(1, min(4, v)) })
                            .gesture(
                                DragGesture(minimumDistance: 0)
                                    .onChanged { val in
                                        let pt = imagePoint(at: val.location, geo: geo)
                                        touchLocation = pt; isPicking = true; updateColor(at: pt)
                                    }
                                    .onEnded { _ in isPicking = false }
                            )
                        if isPicking { colorIndicator(geo: geo) }
                    }
                    .frame(height: areaH).clipped()
                }
                .overlay(Rectangle().stroke(Color.appSeparator.opacity(0.3), lineWidth: 0.5))

                VStack(spacing: 8) {
                    HStack(spacing: 10) {
                        RoundedRectangle(cornerRadius: 6).fill(pickedColor).frame(width: 30, height: 30)
                            .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color.appSeparator, lineWidth: 0.5))
                        Text(pickedHex).font(.system(.body, design: .monospaced)).fontWeight(.bold).foregroundColor(.appForeground)
                        Text("\(Int(pickedColor.toRGB().0*255)),\(Int(pickedColor.toRGB().1*255)),\(Int(pickedColor.toRGB().2*255))").font(.caption2).foregroundColor(.appSecondary)
                        Spacer()
                        Text("\(Int(imageScale))x").font(.caption2).foregroundColor(.appTertiary)
                    }.padding(.horizontal, 16)
                    Button {
                        onColorSelected(pickedColor); Haptic.success(); dismiss()
                    } label: {
                        Text("使用此颜色").fontWeight(.semibold).foregroundColor(.white)
                            .frame(maxWidth: .infinity).frame(height: 40)
                            .background(Color.appForeground).clipShape(RoundedRectangle(cornerRadius: 10)).padding(.horizontal, 16)
                    }
                }.padding(.vertical, 6).background(Color.appBackground)
            }
            .background(Color.appBackground)
            .toolbarBackground(.hidden, for: .navigationBar)
            .navigationTitle("")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) { Text("图片取色").font(.headline).foregroundColor(.appForeground) }
                ToolbarItem(placement: .navigationBarTrailing) { Button("关闭") { dismiss() }.foregroundColor(.appForeground) }
            }
            .onAppear { cachePixelData() }
        }
    }

    private func colorIndicator(geo: GeometryProxy) -> some View {
        let vw = geo.size.width; let vh = geo.size.height
        let fs = min(vw / CGFloat(imgW), vh / CGFloat(imgH))
        let dw = CGFloat(imgW) * fs * imageScale; let dh = CGFloat(imgH) * fs * imageScale
        let dx = (vw - dw) / 2; let dy = (vh - dh) / 2
        let vx = dx + (touchLocation.x / CGFloat(imgW)) * dw
        let vy = dy + (touchLocation.y / CGFloat(imgH)) * dh
        let loupeSize: CGFloat = 80
        let loupeX = min(vw - loupeSize/2 - 10, max(loupeSize/2 + 10, vx))
        let loupeY = max(loupeSize/2 + 5, vy - loupeSize/2 - 35)

        return ZStack {
            Path { p in
                p.move(to: CGPoint(x: vx - 10, y: vy))
                p.addLine(to: CGPoint(x: vx + 10, y: vy))
                p.move(to: CGPoint(x: vx, y: vy - 10))
                p.addLine(to: CGPoint(x: vx, y: vy + 10))
            }.stroke(Color.white, lineWidth: 2).shadow(color: .black.opacity(0.5), radius: 1)

            Path { p in
                p.move(to: CGPoint(x: vx, y: vy - 8))
                p.addLine(to: CGPoint(x: loupeX, y: loupeY + loupeSize/2 + 4))
            }.stroke(Color.white.opacity(0.8), lineWidth: 1.5).shadow(color: .black.opacity(0.3), radius: 1)

            let cropSize: CGFloat = 20
            let cr = CGRect(x: touchLocation.x - cropSize/2, y: touchLocation.y - cropSize/2, width: cropSize, height: cropSize)
            if let cg = image.cgImage?.cropping(to: cr) {
                Image(uiImage: UIImage(cgImage: cg)).resizable().interpolation(.none)
                    .frame(width: loupeSize, height: loupeSize).clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 2.5))
                    .overlay(Circle().fill(pickedColor).frame(width: 6, height: 6))
                    .position(x: loupeX, y: loupeY)
                    .shadow(color: .black.opacity(0.25), radius: 6)
            }
        }
    }

    private func imagePoint(at loc: CGPoint, geo: GeometryProxy) -> CGPoint {
        let vw = geo.size.width; let vh = geo.size.height
        let fs = min(vw / CGFloat(imgW), vh / CGFloat(imgH))
        let dw = CGFloat(imgW) * fs * imageScale; let dh = CGFloat(imgH) * fs * imageScale
        let dx = (vw - dw) / 2; let dy = (vh - dh) / 2
        let ix = ((loc.x - dx) / dw) * CGFloat(imgW)
        let iy = ((loc.y - dy) / dh) * CGFloat(imgH)
        return CGPoint(x: max(0, min(CGFloat(imgW-1), ix)), y: max(0, min(CGFloat(imgH-1), iy)))
    }

    private func cachePixelData() {
        guard let cg = image.cgImage else { return }
        imgW = cg.width; imgH = cg.height
        var data = [UInt8](repeating: 0, count: imgW * imgH * 4)
        let ctx = CGContext(data: &data, width: imgW, height: imgH, bitsPerComponent: 8, bytesPerRow: imgW * 4, space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)
        ctx?.draw(cg, in: CGRect(x: 0, y: 0, width: imgW, height: imgH))
        pixelData = data
        updateColor(at: CGPoint(x: imgW/2, y: imgH/2))
    }

    private func updateColor(at point: CGPoint) {
        guard let data = pixelData else { return }
        let x = Int(point.x); let y = Int(point.y)
        guard x >= 0, x < imgW, y >= 0, y < imgH else { return }
        let offset = (y * imgW + x) * 4
        guard offset + 3 < data.count else { return }
        pickedColor = Color(red: Double(data[offset])/255, green: Double(data[offset+1])/255, blue: Double(data[offset+2])/255)
        pickedHex = String(format: "#%02X%02X%02X", data[offset], data[offset+1], data[offset+2])
    }
}

extension Color {
    func toRGB() -> (CGFloat, CGFloat, CGFloat) {
        var r: CGFloat = 0; var g: CGFloat = 0; var b: CGFloat = 0
        UIColor(self).getRed(&r, green: &g, blue: &b, alpha: nil)
        return (r, g, b)
    }
}
