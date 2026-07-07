import SwiftUI

struct ImageColorPickerView: View {
    let image: UIImage; @Environment(\.dismiss) private var dismiss; var onColorSelected: (Color) -> Void
    @State private var touchLocation: CGPoint = .zero
    @State private var isPicking = false; @State private var pickedColor: Color = .white; @State private var pickedHex: String = "#FFFFFF"
    @State private var imageScale: CGFloat = 1.0; @State private var pixelData: [UInt8]?; @State private var imgW: Int = 0; @State private var imgH: Int = 0

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                GeometryReader { geo in
                    let aH = geo.size.height
                    ZStack {
                        Color.black.opacity(0.03)
                        Image(uiImage: image).resizable().interpolation(.high).aspectRatio(contentMode: .fit).scaleEffect(imageScale)
                            .gesture(MagnificationGesture().onChanged { v in imageScale = max(1, min(4, v)) })
                            .gesture(DragGesture(minimumDistance: 0).onChanged { val in let pt = imgPoint(at: val.location, geo: geo); touchLocation = pt; isPicking = true; updateColor(at: pt) }.onEnded { _ in isPicking = false })
                        if isPicking { indicator(geo: geo) }
                    }.frame(height: aH).clipped()
                }.overlay(Rectangle().stroke(Color.appSeparator.opacity(0.3), lineWidth: 0.5))

                VStack(spacing: 8) {
                    HStack(spacing: 10) {
                        RoundedRectangle(cornerRadius: 6).fill(pickedColor).frame(width: 30, height: 30).overlay(RoundedRectangle(cornerRadius: 6).stroke(Color.appSeparator, lineWidth: 0.5))
                        Text(pickedHex).font(.system(.body, design: .monospaced)).fontWeight(.bold).foregroundColor(.appForeground)
                        Text("\(Int(pickedColor.toRGB().0*255)),\(Int(pickedColor.toRGB().1*255)),\(Int(pickedColor.toRGB().2*255))").font(.caption2).foregroundColor(.appSecondary)
                        Spacer(); Text("\(Int(imageScale))x").font(.caption2).foregroundColor(.appTertiary)
                    }.padding(.horizontal, 16)
                    Button { onColorSelected(pickedColor); Haptic.success(); dismiss() } label: {
                        Text("使用此颜色").fontWeight(.semibold).foregroundColor(Color.appBackground).frame(maxWidth: .infinity).frame(height: 40).background(Color.appForeground).clipShape(RoundedRectangle(cornerRadius: 10)).padding(.horizontal, 16)
                    }
                }.padding(.vertical, 6).background(Color.appBackground)
            }
            .background(Color.appBackground)
            .toolbarBackground(.hidden, for: .navigationBar).navigationTitle("")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) { Text("图片取色").font(.headline).foregroundColor(.appForeground) }
                ToolbarItem(placement: .navigationBarTrailing) { Button("关闭") { dismiss() }.foregroundColor(.appForeground) }
            }
            .onAppear { cachePixels() }
        }
    }

    private func indicator(geo: GeometryProxy) -> some View {
        let vw = geo.size.width; let vh = geo.size.height
        let fs = min(vw / CGFloat(imgW), vh / CGFloat(imgH)); let dw = CGFloat(imgW) * fs * imageScale; let dh = CGFloat(imgH) * fs * imageScale
        let dx = (vw - dw) / 2; let dy = (vh - dh) / 2
        let vx = dx + (touchLocation.x / CGFloat(imgW)) * dw; let vy = dy + (touchLocation.y / CGFloat(imgH)) * dh
        let sz: CGFloat = 80; let lx = min(vw - sz/2 - 10, max(sz/2 + 10, vx)); let ly = max(sz/2 + 5, vy - sz/2 - 35)
        return ZStack {
            Path { p in p.move(to: CGPoint(x: vx-10, y: vy)); p.addLine(to: CGPoint(x: vx+10, y: vy)); p.move(to: CGPoint(x: vx, y: vy-10)); p.addLine(to: CGPoint(x: vx, y: vy+10)) }.stroke(Color.white, lineWidth: 2).shadow(color: .black.opacity(0.5), radius: 1)
            Path { p in p.move(to: CGPoint(x: vx, y: vy-8)); p.addLine(to: CGPoint(x: lx, y: ly+sz/2+4)) }.stroke(Color.white.opacity(0.8), lineWidth: 1.5).shadow(color: .black.opacity(0.3), radius: 1)
            let cr = CGRect(x: touchLocation.x-10, y: touchLocation.y-10, width: 20, height: 20)
            if let cg = image.cgImage?.cropping(to: cr) {
                Image(uiImage: UIImage(cgImage: cg)).resizable().interpolation(.none).frame(width: sz, height: sz).clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 2.5)).overlay(Circle().fill(pickedColor).frame(width: 6, height: 6))
                    .position(x: lx, y: ly).shadow(color: .black.opacity(0.25), radius: 6)
            }
        }
    }

    private func imgPoint(at loc: CGPoint, geo: GeometryProxy) -> CGPoint {
        let vw = geo.size.width; let vh = geo.size.height
        let fs = min(vw / CGFloat(imgW), vh / CGFloat(imgH)); let dw = CGFloat(imgW) * fs * imageScale; let dh = CGFloat(imgH) * fs * imageScale
        let dx = (vw - dw) / 2; let dy = (vh - dh) / 2
        return CGPoint(x: max(0, min(CGFloat(imgW-1), ((loc.x-dx)/dw)*CGFloat(imgW))), y: max(0, min(CGFloat(imgH-1), ((loc.y-dy)/dh)*CGFloat(imgH))))
    }

    private func cachePixels() {
        guard let cg = image.cgImage else { return }; imgW = cg.width; imgH = cg.height
        var data = [UInt8](repeating: 0, count: imgW * imgH * 4)
        CGContext(data: &data, width: imgW, height: imgH, bitsPerComponent: 8, bytesPerRow: imgW * 4, space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)?.draw(cg, in: CGRect(x: 0, y: 0, width: imgW, height: imgH))
        pixelData = data; updateColor(at: CGPoint(x: imgW/2, y: imgH/2))
    }

    private func updateColor(at p: CGPoint) {
        guard let d = pixelData else { return }; let x = Int(p.x); let y = Int(p.y)
        guard x >= 0, x < imgW, y >= 0, y < imgH else { return }; let o = (y * imgW + x) * 4; guard o + 3 < d.count else { return }
        pickedColor = Color(red: Double(d[o])/255, green: Double(d[o+1])/255, blue: Double(d[o+2])/255)
        pickedHex = String(format: "#%02X%02X%02X", d[o], d[o+1], d[o+2])
    }
}

extension Color { func toRGB() -> (CGFloat, CGFloat, CGFloat) { var r: CGFloat=0; var g: CGFloat=0; var b: CGFloat=0; UIColor(self).getRed(&r, green: &g, blue: &b, alpha: nil); return (r, g, b) } }
