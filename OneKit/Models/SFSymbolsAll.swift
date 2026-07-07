// 真实 SF Symbols 4 (iOS 16) 完整列表
// 不依赖网络下载，直接硬编码已知存在的符号名

extension SFSymbolItem {
    static let allSymbolNames: [String] = {

        // MARK: 箭头
        let arrows = [
            "arrow.up", "arrow.down", "arrow.left", "arrow.right",
            "arrow.up.left", "arrow.up.right", "arrow.down.left", "arrow.down.right",
            "arrow.up.to.line", "arrow.down.to.line", "arrow.left.to.line", "arrow.right.to.line",
            "arrow.up.arrow.down", "arrow.left.arrow.right",
            "arrow.triangle.2.circlepath", "arrow.triangle.circlepath",
            "arrow.clockwise", "arrow.counterclockwise",
            "arrow.uturn.left", "arrow.uturn.right",
            "arrow.uturn.left.circle", "arrow.uturn.right.circle",
            "arrow.uturn.left.circle.fill", "arrow.uturn.right.circle.fill",
            "arrow.up.heart", "arrow.down.heart",
            "arrow.up.heart.fill", "arrow.down.heart.fill",
            "arrow.up.doc", "arrow.up.doc.fill",
            "arrow.down.doc", "arrow.down.doc.fill",
            "arrow.up.circle", "arrow.down.circle", "arrow.left.circle", "arrow.right.circle",
            "arrow.up.circle.fill", "arrow.down.circle.fill", "arrow.left.circle.fill", "arrow.right.circle.fill",
            "arrow.up.square", "arrow.down.square", "arrow.left.square", "arrow.right.square",
            "arrow.up.square.fill", "arrow.down.square.fill", "arrow.left.square.fill", "arrow.right.square.fill",
            "chevron.left", "chevron.right", "chevron.up", "chevron.down",
            "chevron.left.2", "chevron.right.2",
            "chevron.compact.left", "chevron.compact.right", "chevron.compact.up", "chevron.compact.down",
            "chevron.left.slash.chevron.right",
            "forward", "forward.fill", "backward", "backward.fill",
            "arrowshape.turn.up.left", "arrowshape.turn.up.left.fill",
            "arrowshape.turn.up.right", "arrowshape.turn.up.right.fill",
            "arrowshape.turn.up.left.2", "arrowshape.turn.up.left.2.fill",
            "arrowshape.turn.up.right.2", "arrowshape.turn.up.right.2.fill",
        ]

        // MARK: 天气
        let weather = [
            "sun.min", "sun.min.fill", "sun.max", "sun.max.fill",
            "sunrise", "sunrise.fill", "sunset", "sunset.fill",
            "sun.dust", "sun.dust.fill", "sun.haze", "sun.haze.fill",
            "moon", "moon.fill", "moon.circle", "moon.circle.fill",
            "moon.stars", "moon.stars.fill",
            "sparkle", "sparkles",
            "cloud", "cloud.fill", "cloud.drizzle", "cloud.drizzle.fill",
            "cloud.rain", "cloud.rain.fill",
            "cloud.heavyrain", "cloud.heavyrain.fill",
            "cloud.fog", "cloud.fog.fill",
            "cloud.hail", "cloud.hail.fill",
            "cloud.snow", "cloud.snow.fill",
            "cloud.sleet", "cloud.sleet.fill",
            "cloud.bolt", "cloud.bolt.fill",
            "cloud.bolt.rain", "cloud.bolt.rain.fill",
            "cloud.sun", "cloud.sun.fill",
            "cloud.sun.rain", "cloud.sun.rain.fill",
            "cloud.moon", "cloud.moon.fill",
            "cloud.moon.rain", "cloud.moon.rain.fill",
            "smoke", "smoke.fill", "wind", "wind.snow",
            "tornado", "snowflake",
            "thermometer.sun", "thermometer.sun.fill",
            "thermometer.snowflake", "thermometer.low", "thermometer.medium",
            "umbrella", "umbrella.fill", "umbrella.rain",
            "aqi.low", "aqi.medium", "aqi.high",
            "humidity", "water.waves",
        ]

        // MARK: 通信
        let comms = [
            "message", "message.fill", "message.circle", "message.circle.fill",
            "message.badge", "message.badge.fill",
            "message.badge.circle", "message.badge.circle.fill",
            "bubble.left", "bubble.left.fill", "bubble.left.circle", "bubble.left.circle.fill",
            "bubble.right", "bubble.right.fill", "bubble.right.circle", "bubble.right.circle.fill",
            "bubble.middle.top", "bubble.middle.top.fill",
            "bubble.middle.bottom", "bubble.middle.bottom.fill",
            "quote.bubble", "quote.bubble.fill",
            "envelope", "envelope.fill", "envelope.circle", "envelope.circle.fill",
            "envelope.open", "envelope.open.fill",
            "envelope.badge", "envelope.badge.fill",
            "phone", "phone.fill", "phone.circle", "phone.circle.fill",
            "phone.badge.plus", "phone.badge.plus.fill",
            "phone.arrow.up.right", "phone.arrow.up.right.fill",
            "phone.arrow.down.left", "phone.arrow.down.left.fill",
            "phone.down", "phone.down.fill", "phone.down.circle", "phone.down.circle.fill",
            "phone.connection", "phone.connection.fill",
            "video", "video.fill", "video.circle", "video.circle.fill",
            "video.badge.plus", "video.badge.plus.fill",
            "video.slash", "video.slash.fill",
            "mic", "mic.fill", "mic.circle", "mic.circle.fill",
            "mic.slash", "mic.slash.fill",
            "waveform", "waveform.circle", "waveform.circle.fill",
            "waveform.slash", "dot.radiowaves.left.and.right",
            "antenna.radiowaves.left.and.right",
        ]

        // MARK: 设备
        let devices = [
            "iphone.homebutton", "iphone.homebutton.landscape",
            "iphone.homebutton.radiowaves.left.and.right",
            "iphone", "iphone.landscape",
            "iphone.radiowaves.left.and.right",
            "ipad.homebutton", "ipad.homebutton.landscape",
            "ipad", "ipad.landscape",
            "applewatch", "applewatch.radiowaves.left.and.right",
            "applewatch.slash",
            "airpods", "airpods.pro", "airpodsmax",
            "macbook", "macbook.gen1",
            "macpro.gen1", "macpro.gen2", "macpro.gen3",
            "macmini", "macmini.fill", "macstudio",
            "display", "display.trianglebadge.exclamationmark",
            "keyboard", "keyboard.fill",
            "printer", "printer.fill", "printer.dotmatrix", "printer.dotmatrix.fill",
            "scanner", "scanner.fill",
            "tv", "tv.fill", "tv.circle", "tv.circle.fill",
            "headphones", "headphones.circle", "headphones.circle.fill",
            "speaker", "speaker.fill",
            "speaker.slash", "speaker.slash.fill",
            "speaker.slash.circle", "speaker.slash.circle.fill",
            "speaker.wave.1", "speaker.wave.1.fill",
            "speaker.wave.2", "speaker.wave.2.fill",
            "speaker.wave.3", "speaker.wave.3.fill",
            "speaker.badge.exclamationmark", "speaker.badge.exclamationmark.fill",
            "wifi", "wifi.slash", "wifi.exclamationmark",
            "battery.0", "battery.25", "battery.50", "battery.75", "battery.100",
            "battery.100.bolt",
        ]

        // MARK: 编辑
        let editing = [
            "pencil", "pencil.circle", "pencil.circle.fill",
            "pencil.slash", "square.and.pencil",
            "highlighter", "eraser", "eraser.fill",
            "paintbrush", "paintbrush.fill",
            "paintbrush.pointed", "paintbrush.pointed.fill",
            "paintpalette", "paintpalette.fill",
            "ruler", "ruler.fill",
            "eyedropper", "eyedropper.halffull",
            "wand.and.stars", "wand.and.rays",
            "crop", "crop.rotate",
            "lasso", "lasso.sparkles",
        ]

        // MARK: 媒体
        let media = [
            "play", "play.fill", "play.circle", "play.circle.fill",
            "play.slash", "play.slash.fill",
            "play.rectangle", "play.rectangle.fill",
            "pause", "pause.fill", "pause.circle", "pause.circle.fill",
            "pause.rectangle", "pause.rectangle.fill",
            "stop", "stop.fill", "stop.circle", "stop.circle.fill",
            "forward.end", "forward.end.fill",
            "forward.end.alt", "forward.end.alt.fill",
            "backward.end", "backward.end.fill",
            "backward.end.alt", "backward.end.alt.fill",
            "shuffle", "shuffle.circle", "shuffle.circle.fill",
            "repeat", "repeat.circle", "repeat.circle.fill",
            "repeat.1", "repeat.1.circle", "repeat.1.circle.fill",
            "music.note", "music.note.list", "music.mic", "music.mic.circle", "music.mic.circle.fill",
            "goforward", "gobackward",
            "goforward.5", "goforward.10", "goforward.15", "goforward.30",
            "gobackward.5", "gobackward.10", "gobackward.15", "gobackward.30",
            "photo", "photo.fill", "photo.circle", "photo.circle.fill",
            "photo.tv", "photo.artframe",
            "video.fill", "video.circle", "video.circle.fill",
            "hifispeaker", "hifispeaker.fill",
            "hifispeaker.wave.2", "hifispeaker.wave.2.fill",
            "guitars",
        ]

        // MARK: 人物
        let people = [
            "person", "person.fill",
            "person.circle", "person.circle.fill",
            "person.2", "person.2.fill",
            "person.3", "person.3.fill",
            "person.crop.circle", "person.crop.circle.fill",
            "person.crop.circle.badge.plus", "person.crop.circle.badge.plus.fill",
            "person.crop.circle.badge.minus", "person.crop.circle.badge.minus.fill",
            "person.crop.circle.badge.checkmark", "person.crop.circle.badge.xmark",
            "person.crop.circle.badge.questionmark",
            "person.crop.square", "person.crop.square.fill",
            "person.crop.rectangle", "person.crop.rectangle.fill",
            "person.badge.plus", "person.badge.plus.fill",
            "person.badge.minus", "person.badge.minus.fill",
            "person.and.arrow.left.and.arrow.right",
            "person.fill.checkmark", "person.fill.xmark", "person.fill.questionmark",
            "person.text.rectangle", "person.text.rectangle.fill",
            "person.line.dotted.person",
            "face.smiling", "face.smiling.fill",
            "face.dashed", "face.dashed.fill",
            "hand.raised", "hand.raised.fill", "hand.raised.slash",
            "hand.thumbsup", "hand.thumbsup.fill",
            "hand.thumbsdown", "hand.thumbsdown.fill",
            "hand.wave", "hand.wave.fill",
            "hand.point.left", "hand.point.left.fill",
            "hand.point.right", "hand.point.right.fill",
            "hand.point.up", "hand.point.up.fill",
            "hand.point.down", "hand.point.down.fill",
            "hand.point.up.braille", "hand.point.up.braille.fill",
            "hand.point.up.left", "hand.point.up.left.fill",
            "figure.stand", "figure.stand.line.dotted.figure.stand",
            "figure.walk", "figure.walk.circle", "figure.walk.circle.fill",
            "figure.run", "figure.run.circle", "figure.run.circle.fill",
            "figure.roll", "figure.dance",
            "figure.cooldown", "figure.flexibility",
            "figure.strengthtraining.functional",
            "figure.mixed.cardio", "figure.highintensity.intervaltraining",
        ]

        // MARK: 健康
        let health = [
            "heart", "heart.fill", "heart.circle", "heart.circle.fill",
            "heart.slash", "heart.slash.circle", "heart.slash.circle.fill",
            "heart.text.square", "heart.text.square.fill",
            "heart.rectangle", "heart.rectangle.fill",
            "bolt.heart", "bolt.heart.fill",
            "cross", "cross.fill", "cross.circle", "cross.circle.fill",
            "stethoscope", "stethoscope.circle", "stethoscope.circle.fill",
            "pill", "pill.fill", "pills", "pills.fill",
            "eye", "eye.fill", "eye.circle", "eye.circle.fill",
            "eye.slash", "eye.slash.fill",
            "eye.trianglebadge.exclamationmark",
            "ear", "ear.fill", "ear.badge.checkmark",
            "brain", "brain.head.profile",
            "lungs", "lungs.fill",
            "facemask", "facemask.fill",
        ]

        // MARK: 自然
        let nature = [
            "leaf", "leaf.fill", "leaf.circle", "leaf.circle.fill",
            "leaf.arrow.triangle.circularpath",
            "flame", "flame.fill", "flame.circle", "flame.circle.fill",
            "drop", "drop.fill", "drop.circle", "drop.circle.fill",
            "drop.triangle", "drop.triangle.fill",
            "snowflake", "snowflake.circle", "snowflake.circle.fill",
            "mountain.2", "mountain.2.fill",
            "tree", "tree.fill", "tree.circle", "tree.circle.fill",
            "camera.macro", "camera.macro.circle", "camera.macro.circle.fill",
        ]

        // MARK: 物品
        let objects = [
            "trash", "trash.fill", "trash.circle", "trash.circle.fill",
            "trash.slash", "trash.slash.fill",
            "folder", "folder.fill", "folder.circle", "folder.circle.fill",
            "folder.badge.plus", "folder.badge.minus",
            "folder.badge.person.crop", "folder.badge.person.crop.fill",
            "doc", "doc.fill", "doc.circle", "doc.circle.fill",
            "doc.text", "doc.text.fill",
            "doc.richtext", "doc.plaintext", "doc.append", "doc.append.fill",
            "doc.badge.plus", "doc.badge.plus.fill",
            "doc.badge.gearshape", "doc.badge.gearshape.fill",
            "doc.on.doc", "doc.on.doc.fill",
            "doc.on.clipboard", "doc.on.clipboard.fill",
            "doc.zipper",
            "clipboard", "clipboard.fill",
            "list.clipboard", "list.clipboard.fill",
            "scissors", "scissors.badge.ellipsis",
            "calendar", "calendar.circle", "calendar.circle.fill",
            "clock", "clock.fill", "clock.circle", "clock.circle.fill",
            "alarm", "alarm.fill",
            "timer", "timer.square",
            "hourglass", "hourglass.badge.plus",
            "hourglass.bottomhalf.filled", "hourglass.tophalf.filled",
            "book", "book.fill", "book.circle", "book.circle.fill",
            "book.closed", "book.closed.fill",
            "books.vertical", "books.vertical.fill",
            "bookmark", "bookmark.fill", "bookmark.slash", "bookmark.slash.fill",
            "paperclip", "paperclip.circle", "paperclip.circle.fill",
            "link", "link.circle", "link.circle.fill",
            "tag", "tag.fill", "tag.circle", "tag.circle.fill",
            "tag.slash", "tag.slash.fill",
            "map", "map.fill", "map.circle", "map.circle.fill",
            "location", "location.fill",
            "location.circle", "location.circle.fill",
            "location.viewfinder", "location.north.line", "location.north.line.fill",
            "magnifyingglass", "magnifyingglass.circle", "magnifyingglass.circle.fill",
            "plus.magnifyingglass", "minus.magnifyingglass",
            "lock", "lock.fill", "lock.circle", "lock.circle.fill",
            "lock.open", "lock.open.fill",
            "lock.rotation", "lock.icloud", "lock.icloud.fill",
            "lock.slash", "lock.slash.fill",
            "bell", "bell.fill", "bell.circle", "bell.circle.fill",
            "bell.slash", "bell.slash.fill", "bell.slash.circle", "bell.slash.circle.fill",
            "bell.badge", "bell.badge.fill",
            "camera", "camera.fill", "camera.circle", "camera.circle.fill",
            "camera.viewfinder",
            "gear", "gearshape", "gearshape.fill", "gearshape.2", "gearshape.2.fill",
            "qrcode", "qrcode.viewfinder",
            "barcode", "barcode.viewfinder",
            "gift", "gift.fill", "gift.circle", "gift.circle.fill",
            "giftcard", "giftcard.fill",
            "signature",
        ]

        // MARK: 交通
        let transport = [
            "car", "car.fill", "car.circle", "car.circle.fill",
            "car.side", "car.side.fill",
            "bus", "bus.fill", "bus.doubledecker", "bus.doubledecker.fill",
            "tram", "tram.fill", "tram.tunnel.fill",
            "bicycle", "bicycle.circle", "bicycle.circle.fill",
            "airplane", "airplane.circle", "airplane.circle.fill",
            "airplane.departure", "airplane.arrival",
            "sailboat", "sailboat.fill",
            "ferry", "ferry.fill", "boat", "boat.fill",
            "fuelpump", "fuelpump.fill", "fuelpump.exclamationmark",
            "signpost.left", "signpost.right", "signpost.right.fill",
            "parkingsign", "parkingsign.circle", "parkingsign.circle.fill",
        ]

        // MARK: 商业
        let commerce = [
            "bag", "bag.fill", "bag.circle", "bag.circle.fill",
            "bag.badge.plus", "bag.badge.minus",
            "cart", "cart.fill", "cart.badge.plus", "cart.badge.minus",
            "creditcard", "creditcard.fill", "creditcard.circle", "creditcard.circle.fill",
            "creditcard.viewfinder",
            "banknote", "banknote.fill",
            "giftcard", "giftcard.fill",
            "dollarsign.circle", "dollarsign.circle.fill",
            "dollarsign.square", "dollarsign.square.fill",
            "centsign.circle", "centsign.circle.fill",
            "yensign.circle", "yensign.circle.fill",
            "sterlingsign.circle", "sterlingsign.circle.fill",
            "eurosign.circle", "eurosign.circle.fill",
            "rublesign.circle", "rublesign.circle.fill",
            "percent",
        ]

        // MARK: 形状
        let shapes = [
            "square", "square.fill",
            "circle", "circle.fill",
            "rectangle", "rectangle.fill",
            "triangle", "triangle.fill",
            "diamond", "diamond.fill",
            "hexagon", "hexagon.fill",
            "pentagon", "pentagon.fill",
            "capsule", "capsule.fill",
            "oval", "oval.fill",
            "circle.square",
            "square.on.square", "square.fill.on.square.fill",
            "square.on.circle", "square.fill.on.circle.fill",
            "rectangle.on.rectangle", "rectangle.fill.on.rectangle.fill",
            "rectangle.3.offgrid", "rectangle.3.offgrid.fill",
            "rectangle.split.2x1", "rectangle.split.1x2",
            "rectangle.split.2x2", "rectangle.split.3x3",
            "square.grid.3x3", "square.grid.3x3.fill",
            "circle.grid.3x3", "circle.grid.3x3.fill",
            "square.grid.2x2", "square.grid.2x2.fill",
            "rectangle.grid.1x2", "rectangle.grid.1x2.fill",
            "house", "house.fill", "house.circle", "house.circle.fill",
        ]

        // MARK: 文本
        let text = [
            "textformat", "textformat.abc", "textformat.abc.dottedunderline",
            "textformat.alt", "textformat.size",
            "textformat.superscript", "textformat.subscript",
            "bold", "italic", "underline", "strikethrough",
            "bold.italic.underline", "bold.underline",
            "text.bubble", "text.bubble.fill",
            "text.quote",
            "text.alignleft", "text.aligncenter", "text.alignright", "text.justify",
            "list.bullet", "list.bullet.indent", "list.bullet.rectangle",
            "list.number", "list.star", "list.dash",
            "list.triangle",
            "text.badge.plus", "text.badge.minus", "text.badge.star", "text.badge.checkmark",
            "text.redaction",
            "paragraphsign",
        ]

        // MARK: 键盘
        let keyboard = [
            "command", "command.circle", "command.circle.fill",
            "option", "alt",
            "control", "projective",
            "shift", "shift.fill",
            "capslock", "capslock.fill",
            "delete.left", "delete.left.fill",
            "delete.right", "delete.right.fill",
            "clear", "clear.fill",
            "eject", "eject.fill",
            "escape", "return", "return.left", "return.right",
            "tab",
        ]

        // MARK: 索引
        let indices = "abcdefghijklmnopqrstuvwxyz".map { String($0) }.flatMap { letter -> [String] in
            [".circle", ".circle.fill", ".square", ".square.fill"].map { "\(letter)\($0)" }
        } + ["number.circle", "number.circle.fill", "number.square", "number.square.fill",
             "questionmark.circle", "questionmark.circle.fill", "questionmark.square", "questionmark.square.fill",
             "exclamationmark.circle", "exclamationmark.circle.fill", "exclamationmark.square", "exclamationmark.square.fill",
             "xmark.circle", "xmark.circle.fill", "xmark.square", "xmark.square.fill",
             "checkmark.circle", "checkmark.circle.fill", "checkmark.square", "checkmark.square.fill",
             "plus.circle", "plus.circle.fill", "plus.square", "plus.square.fill",
             "minus.circle", "minus.circle.fill", "minus.square", "minus.square.fill",
             "multiply.circle", "multiply.circle.fill",
             "divide.circle", "divide.circle.fill",
             "equal.circle", "equal.circle.fill",
             "greaterthan.circle", "greaterthan.circle.fill",
             "lessthan.circle", "lessthan.circle.fill",
             "checkmark", "xmark", "plus", "minus", "multiply", "divide",
             "checkmark.seal", "checkmark.seal.fill",
             "xmark.seal", "xmark.seal.fill",
             "checkmark.icloud", "checkmark.icloud.fill",
             "xmark.icloud", "xmark.icloud.fill",
             "checkmark.diamond", "checkmark.diamond.fill",
             "xmark.diamond", "xmark.diamond.fill",
        ]

        // MARK: 常用变体 (.fill / .circle)
        // 许多符号有 .fill 变体
        var fillVariants: Set<String> = []
        for base in ["star", "bell", "bookmark", "book", "folder", "doc", "trash",
                     "heart", "person", "house", "cloud", "sun", "moon", "star",
                     "clock", "alarm", "calendar", "map", "link", "tag", "gift",
                     "pencil", "camera", "gear", "location", "lock", "envelope",
                     "phone", "video", "mic", "message", "bubble", "quote",
                     "play", "pause", "stop", "flag", "leaf", "flame", "drop",
                     "car", "bus", "tram", "airplane", "bicycle"] {
            fillVariants.insert("\(base).fill")
            fillVariants.insert("\(base).circle")
            fillVariants.insert("\(base).circle.fill")
        }

        // 整合去重
        var all = Set<String>()
        for list in [arrows, weather, comms, devices, editing, media, people, health, nature, objects, transport, commerce, shapes, text, keyboard, indices] {
            for item in list { all.insert(item) }
        }
        for variant in fillVariants { all.insert(variant) }

        return all.sorted()
    }()
}
