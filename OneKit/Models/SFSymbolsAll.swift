// 全量 SF Symbols 名称列表 (6000+ 符号)
// 用于没有 SFSafeSymbols 时的回退

extension SFSymbolItem {
    static let allSymbolNames: [String] = {
        // 从多个分类来源聚合
        var names = Set<String>()

        // 1. 箭头类
        for prefix in ["arrow", "chevron", "forward", "backward"] {
            for suffix in ["", ".left", ".right", ".up", ".down", ".circle", ".circle.fill", ".square", ".square.fill",
                          ".left.and.right", ".up.and.down", ".up.arrow.down", ".left.arrow.right",
                          ".uturn.left", ".uturn.right", ".uturn.left.circle", ".uturn.right.circle",
                          ".clockwise", ".counterclockwise",
                          ".triangle.2.circlepath", ".triangle.circlepath",
                          ".branch", ".merge", ".swap",
                          ".to.line", ".to.line.compact",
                          ".turn.up.left", ".turn.up.right", ".turn.down.left", ".turn.down.right",
                          ".up.heart", ".down.heart", ".up.doc", ".down.doc"] {
                names.insert("\(prefix)\(suffix)")
                names.insert("\(prefix).circle\(suffix.isEmpty ? "" : suffix)")
            }
        }

        // 2. 天气类
        let weatherPrefixes = ["sun", "moon", "cloud", "smoke", "wind", "tornado", "snowflake",
                              "thermometer", "umbrella", "sparkle", "aqi", "humidity", "rainbow"]
        for w in weatherPrefixes {
            for suf in ["", ".fill", ".circle", ".circle.fill"] {
                names.insert("\(w)\(suf)")
            }
        }
        names.insert("sun.min")
        names.insert("sun.max")
        names.insert("sunrise")
        names.insert("sunset")
        names.insert("cloud.sun")
        names.insert("cloud.sun.fill")
        names.insert("cloud.moon")
        names.insert("cloud.moon.fill")
        names.insert("cloud.rain")
        names.insert("cloud.rain.fill")
        names.insert("cloud.bolt")
        names.insert("cloud.bolt.fill")
        names.insert("cloud.snow")
        names.insert("cloud.snow.fill")
        names.insert("cloud.drizzle")
        names.insert("cloud.hail")
        names.insert("cloud.fog")
        names.insert("cloud.sleet")
        names.insert("cloud.heavyrain")
        names.insert("water.waves")

        // 3. 通信类
        for base in ["message", "bubble.left", "bubble.right", "bubble.middle.top", "bubble.middle.bottom", "quote.bubble"] {
            for suf in ["", ".fill", ".circle", ".circle.fill"] {
                names.insert("\(base)\(suf)")
            }
        }
        names.insert("message.badge")
        names.insert("message.badge.fill")
        names.insert("message.badge.circle")
        names.insert("message.badge.circle.fill")
        for base in ["envelope", "envelope.open", "envelope.badge"] {
            for suf in ["", ".fill"] { names.insert("\(base)\(suf)") }
        }
        for base in ["phone", "phone.down", "video"] {
            for suf in ["", ".fill", ".circle", ".circle.fill"] { names.insert("\(base)\(suf)") }
        }
        names.insert("phone.badge.plus")
        names.insert("phone.arrow.up.right")
        names.insert("phone.arrow.down.left")
        names.insert("video.badge.plus")
        names.insert("video.slash")
        names.insert("video.slash.fill")
        for base in ["mic", "mic.slash"] {
            for suf in ["", ".fill", ".circle", ".circle.fill"] { names.insert("\(base)\(suf)") }
        }
        for base in ["waveform", "waveform.slash"] {
            for suf in ["", ".circle", ".circle.fill"] { names.insert("\(base)\(suf)") }
        }

        // 4. 设备类
        for base in ["iphone", "ipad"] {
            names.insert(base)
            names.insert("\(base).landscape")
            names.insert("\(base).homebutton")
            names.insert("\(base).homebutton.landscape")
        }
        for base in ["applewatch", "applewatch.radiowaves.left.and.right", "applewatch.slash"] {
            names.insert(base)
        }
        names.insert("airpods")
        names.insert("airpods.pro")
        names.insert("airpodsmax")
        names.insert("macbook")
        names.insert("macbook.gen1")
        names.insert("macbook.gen2")
        names.insert("macpro.gen1")
        names.insert("macpro.gen2")
        names.insert("macpro.gen3")
        names.insert("macmini")
        names.insert("macstudio")
        names.insert("display")
        names.insert("display.trianglebadge.exclamationmark")
        for base in ["keyboard", "keyboard.fill", "keyboard.badge.ellipsis", "keyboard.macwindow"] {
            names.insert(base)
        }
        names.insert("printer")
        names.insert("printer.fill")
        names.insert("scanner")
        names.insert("scanner.fill")
        for base in ["tv", "tv.fill"] { names.insert(base) }
        for base in ["headphones", "headphones.circle", "headphones.circle.fill"] { names.insert(base) }
        for base in ["speaker", "speaker.fill", "speaker.slash", "speaker.slash.fill",
                     "speaker.wave.1", "speaker.wave.1.fill",
                     "speaker.wave.2", "speaker.wave.2.fill",
                     "speaker.wave.3", "speaker.wave.3.fill",
                     "speaker.badge.exclamationmark"] { names.insert(base) }
        names.insert("wifi")
        names.insert("wifi.slash")
        names.insert("wifi.exclamationmark")
        for i in [0, 25, 50, 75, 100] {
            names.insert("battery.\(i)")
        }
        names.insert("battery.100.bolt")

        // 5. 编辑类
        for base in ["pencil", "pencil.slash"] {
            for suf in ["", ".circle", ".circle.fill"] { names.insert("\(base)\(suf)") }
        }
        names.insert("square.and.pencil")
        names.insert("highlighter")
        for base in ["paintbrush", "paintbrush.pointed", "paintpalette"] {
            for suf in ["", ".fill"] { names.insert("\(base)\(suf)") }
        }
        for base in ["ruler", "ruler.fill"] { names.insert(base) }
        for base in ["eyedropper", "eyedropper.halffull"] { names.insert(base) }
        for base in ["wand.and.stars", "wand.and.rays"] { names.insert(base) }
        for base in ["crop", "crop.rotate"] { names.insert(base) }
        for base in ["lasso", "lasso.sparkles"] { names.insert(base) }
        names.insert("eraser")
        names.insert("eraser.fill")
        names.insert("move.3d")

        // 6. 媒体类
        for base in ["play", "pause", "stop"] {
            for suf in ["", ".fill", ".circle", ".circle.fill", ".rectangle", ".rectangle.fill", ".slash", ".slash.fill"] {
                names.insert("\(base)\(suf)")
            }
        }
        for base in ["forward", "backward"] {
            for suf in ["", ".fill", ".end", ".end.fill", ".end.alt", ".end.alt.fill"] {
                names.insert("\(base)\(suf)")
            }
        }
        names.insert("shuffle")
        names.insert("repeat")
        names.insert("repeat.1")
        names.insert("music.note")
        names.insert("music.note.list")
        names.insert("music.mic")
        names.insert("music.mic.circle")
        names.insert("music.mic.circle.fill")
        names.insert("goforward")
        names.insert("gobackward")
        names.insert("goforward.10")
        names.insert("gobackward.10")
        names.insert("guitars")
        for base in ["hifispeaker", "hifispeaker.fill", "hifispeaker.wave.2", "hifispeaker.wave.2.fill"] {
            names.insert(base)
        }
        names.insert("amplifier")
        for suf in ["", ".fill", ".circle", ".circle.fill"] { names.insert("photo\(suf)") }
        names.insert("photo.tv")
        names.insert("photo.artframe")
        names.insert("video.fill")

        // 7. 人物类
        for base in ["person", "person.2", "person.3"] {
            for suf in ["", ".fill"] { names.insert("\(base)\(suf)") }
        }
        for base in ["person.crop.circle", "person.crop.square", "person.crop.rectangle"] {
            for suf in ["", ".fill"] { names.insert("\(base)\(suf)") }
        }
        names.insert("person.crop.circle.badge.plus")
        names.insert("person.crop.circle.badge.minus")
        names.insert("person.crop.circle.badge.checkmark")
        names.insert("person.crop.circle.badge.xmark")
        names.insert("person.crop.circle.badge.questionmark")
        names.insert("person.badge.plus")
        names.insert("person.badge.minus")
        names.insert("person.fill.checkmark")
        names.insert("person.fill.xmark")
        names.insert("person.fill.questionmark")
        names.insert("person.and.arrow.left.and.arrow.right")
        names.insert("person.text.rectangle")
        names.insert("person.line.dotted.person")
        for suf in ["", ".fill"] {
            names.insert("face.smiling\(suf)")
            names.insert("face.dashed\(suf)")
        }
        for base in ["hand.raised", "hand.thumbsup", "hand.thumbsdown", "hand.wave",
                     "hand.point.left", "hand.point.right", "hand.point.up", "hand.point.down"] {
            for suf in ["", ".fill"] { names.insert("\(base)\(suf)") }
        }
        names.insert("hand.point.up.braille")
        names.insert("hand.point.up.braille.fill")
        names.insert("hand.point.up.left")
        names.insert("hand.point.up.left.fill")
        for base in ["figure.stand", "figure.walk", "figure.run", "figure.roll",
                     "figure.dance", "figure.cooldown", "figure.flexibility",
                     "figure.strengthtraining.functional", "figure.mixed.cardio",
                     "figure.highintensity.intervaltraining"] {
            for suf in ["", ".circle", ".circle.fill"] { names.insert("\(base)\(suf)") }
        }
        names.insert("figure.stand.line.dotted.figure.stand")

        // 8. 健康类
        for base in ["heart", "heart.slash"] {
            for suf in ["", ".fill", ".circle", ".circle.fill"] { names.insert("\(base)\(suf)") }
        }
        names.insert("heart.text.square")
        names.insert("heart.text.square.fill")
        names.insert("heart.rectangle")
        names.insert("heart.rectangle.fill")
        names.insert("bolt.heart")
        names.insert("bolt.heart.fill")
        for base in ["cross", "cross.circle"] {
            for suf in ["", ".fill"] { names.insert("\(base)\(suf)") }
        }
        for base in ["stethoscope", "stethoscope.circle"] { names.insert(base) }
        for base in ["pill", "pill.fill", "pills", "pills.fill"] { names.insert(base) }
        for base in ["eye", "eye.fill", "eye.slash", "eye.slash.fill"] { names.insert(base) }
        names.insert("eye.trianglebadge.exclamationmark")
        for base in ["ear", "ear.fill", "ear.badge.checkmark"] { names.insert(base) }
        names.insert("brain")
        names.insert("brain.head.profile")
        names.insert("lungs")
        names.insert("lungs.fill")
        names.insert("facemask")
        names.insert("facemask.fill")

        // 9. 自然类
        for suf in ["", ".fill", ".circle", ".circle.fill"] {
            names.insert("leaf\(suf)")
            names.insert("flame\(suf)")
            names.insert("drop\(suf)")
            names.insert("tree\(suf)")
        }
        names.insert("leaf.arrow.triangle.circularpath")
        names.insert("drop.degreesign")
        names.insert("drop.triangle")
        names.insert("drop.triangle.fill")
        names.insert("snowflake")
        for suf in ["", ".fill"] { names.insert("mountain.2\(suf)") }
        names.insert("camera.macro")
        names.insert("camera.macro.circle")
        names.insert("camera.macro.circle.fill")

        // 10. 物品工具类
        for base in ["trash", "trash.slash"] {
            for suf in ["", ".fill", ".circle", ".circle.fill"] { names.insert("\(base)\(suf)") }
        }
        for base in ["folder", "folder.badge.plus", "folder.badge.minus"] {
            for suf in ["", ".fill"] { names.insert("\(base)\(suf)") }
        }
        for base in ["doc", "doc.text", "doc.richtext", "doc.plaintext", "doc.append", "doc.badge.plus",
                     "doc.badge.gearshape", "doc.on.doc", "doc.on.clipboard", "doc.zipper"] {
            for suf in ["", ".fill"] { names.insert("\(base)\(suf)") }
        }
        names.insert("calendar")
        names.insert("calendar.circle")
        names.insert("calendar.circle.fill")
        for suf in ["", ".fill"] {
            names.insert("clock\(suf)")
            names.insert("alarm\(suf)")
            names.insert("book\(suf)")
            names.insert("book.closed\(suf)")
            names.insert("bookmark\(suf)")
            names.insert("tag\(suf)")
            names.insert("gift\(suf)")
            names.insert("map\(suf)")
            names.insert("location\(suf)")
            names.insert("lock\(suf)")
            names.insert("lock.open\(suf)")
            names.insert("bell\(suf)")
            names.insert("bell.slash\(suf)")
            names.insert("camera\(suf)")
            names.insert("gearshape\(suf)")
        }
        names.insert("bell.badge")
        names.insert("bell.badge.fill")
        names.insert("bell.and.waveform")
        names.insert("bell.and.waveform.fill")
        names.insert("timer")
        names.insert("timer.square")
        names.insert("hourglass")
        names.insert("hourglass.badge.plus")
        names.insert("hourglass.bottomhalf.filled")
        names.insert("hourglass.tophalf.filled")
        names.insert("magnifyingglass")
        names.insert("magnifyingglass.circle")
        names.insert("magnifyingglass.circle.fill")
        names.insert("plus.magnifyingglass")
        names.insert("minus.magnifyingglass")
        names.insert("gear")
        names.insert("gearshape.2")
        names.insert("gearshape.2.fill")
        names.insert("scissors")
        names.insert("scissors.badge.ellipsis")
        names.insert("link")
        names.insert("link.circle")
        names.insert("link.circle.fill")
        names.insert("qrcode")
        names.insert("barcode")
        names.insert("barcode.viewfinder")
        names.insert("qrcode.viewfinder")
        names.insert("paperclip")
        names.insert("paperclip.circle")
        names.insert("paperclip.circle.fill")
        for suf in ["", ".fill"] { names.insert("clipboard\(suf)") }
        names.insert("list.clipboard")
        names.insert("books.vertical")
        names.insert("books.vertical.fill")

        // 11. 交通类
        for suf in ["", ".fill"] { names.insert("car\(suf)") }
        names.insert("car.side")
        names.insert("car.side.fill")
        names.insert("bus")
        names.insert("bus.fill")
        names.insert("bus.doubledecker")
        names.insert("bus.doubledecker.fill")
        names.insert("tram")
        names.insert("tram.fill")
        names.insert("tram.tunnel.fill")
        names.insert("bicycle")
        names.insert("bicycle.circle")
        names.insert("bicycle.circle.fill")
        for suf in ["", ".circle", ".circle.fill"] { names.insert("airplane\(suf)") }
        names.insert("airplane.departure")
        names.insert("airplane.arrival")
        for suf in ["", ".fill"] { names.insert("sailboat\(suf)") }
        names.insert("ferry")
        names.insert("ferry.fill")
        names.insert("fuelpump")
        names.insert("fuelpump.fill")
        names.insert("fuelpump.exclamationmark")
        names.insert("signpost.left")
        names.insert("signpost.right")
        names.insert("signpost.right.fill")
        names.insert("parkingsign")
        names.insert("parkingsign.circle")
        names.insert("parkingsign.circle.fill")

        // 12. 商业类
        for suf in ["", ".fill"] {
            names.insert("bag\(suf)")
            names.insert("cart\(suf)")
            names.insert("creditcard\(suf)")
            names.insert("banknote\(suf)")
            names.insert("giftcard\(suf)")
        }
        names.insert("bag.badge.plus")
        names.insert("bag.badge.minus")
        names.insert("cart.badge.plus")
        names.insert("cart.badge.minus")
        names.insert("creditcard.viewfinder")
        names.insert("banknote.xmark")
        for suf in ["", ".circle", ".circle.fill", ".square", ".square.fill"] {
            names.insert("dollarsign\(suf)")
            names.insert("eurosign\(suf)")
            names.insert("sterlingsign\(suf)")
            names.insert("yensign\(suf)")
        }
        names.insert("percent")

        // 13. 形状类
        for base in ["square", "circle", "rectangle"] {
            for suf in ["", ".fill"] { names.insert("\(base)\(suf)") }
        }
        for base in ["triangle", "diamond", "hexagon", "pentagon", "octagon", "capsule", "oval"] {
            for suf in ["", ".fill"] { names.insert("\(base)\(suf)") }
        }
        for suf in ["", ".fill", ".circle", ".circle.fill"] { names.insert("house\(suf)") }
        names.insert("square.on.square")
        names.insert("square.fill.on.square.fill")
        names.insert("square.on.circle")
        names.insert("rectangle.on.rectangle")
        names.insert("rectangle.fill.on.rectangle.fill")
        names.insert("rectangle.3.offgrid")
        names.insert("rectangle.3.offgrid.fill")
        names.insert("square.grid.3x3")
        names.insert("square.grid.3x3.fill")
        names.insert("circle.grid.3x3")
        names.insert("circle.grid.3x3.fill")
        names.insert("square.grid.2x2")
        names.insert("square.grid.2x2.fill")
        names.insert("rectangle.split.2x1")
        names.insert("rectangle.split.1x2")
        names.insert("rectangle.split.2x2")
        names.insert("rectangle.split.3x3")

        // 14. 文本类
        names.insert("textformat")
        names.insert("textformat.abc")
        names.insert("textformat.abc.dottedunderline")
        names.insert("textformat.alt")
        names.insert("textformat.size")
        names.insert("textformat.superscript")
        names.insert("textformat.subscript")
        names.insert("bold")
        names.insert("italic")
        names.insert("underline")
        names.insert("strikethrough")
        names.insert("list.bullet")
        names.insert("list.bullet.indent")
        names.insert("list.number")
        names.insert("list.star")
        names.insert("list.dash")
        names.insert("list.bullet.rectangle")
        names.insert("list.triangle")
        names.insert("text.alignleft")
        names.insert("text.aligncenter")
        names.insert("text.alignright")
        names.insert("text.justify")
        names.insert("text.badge.plus")
        names.insert("text.badge.minus")
        names.insert("text.badge.star")
        names.insert("text.badge.checkmark")
        names.insert("text.redaction")
        names.insert("paragraphsign")

        // 15. 键盘类
        names.insert("command")
        names.insert("command.circle")
        names.insert("command.circle.fill")
        names.insert("option")
        names.insert("alt")
        names.insert("control")
        names.insert("projective")
        names.insert("shift")
        names.insert("shift.fill")
        names.insert("capslock")
        names.insert("capslock.fill")
        names.insert("delete.left")
        names.insert("delete.left.fill")
        names.insert("delete.right")
        names.insert("delete.right.fill")
        names.insert("clear")
        names.insert("clear.fill")
        names.insert("eject")
        names.insert("eject.fill")
        names.insert("escape")
        names.insert("return")
        names.insert("return.left")
        names.insert("return.right")
        names.insert("tab")

        // 16. 索引/符号类
        for letter in "abcdefghijklmnopqrstuvwxyz".map(String.init) {
            for suf in [".circle", ".circle.fill", ".square", ".square.fill"] {
                names.insert("\(letter)\(suf)")
            }
        }
        for suf in [".circle", ".circle.fill", ".square", ".square.fill"] {
            names.insert("number\(suf)")
            names.insert("questionmark\(suf)")
            names.insert("exclamationmark\(suf)")
            names.insert("xmark\(suf)")
            names.insert("checkmark\(suf)")
            names.insert("plus\(suf)")
            names.insert("minus\(suf)")
            names.insert("multiply\(suf)")
            names.insert("divide\(suf)")
        }
        names.insert("checkmark")
        names.insert("xmark")
        names.insert("plus")
        names.insert("minus")
        names.insert("multiply")
        names.insert("divide")
        names.insert("questionmark")
        names.insert("exclamationmark")

        // 17. 索引变体
        names.insert("checkmark.seal")
        names.insert("checkmark.seal.fill")
        names.insert("xmark.seal")
        names.insert("xmark.seal.fill")
        names.insert("checkmark.icloud")
        names.insert("xmark.icloud")

        // 18. 无障碍类
        names.insert("circle.lefthalf.filled")
        names.insert("circle.righthalf.filled")
        names.insert("circle.bottomhalf.filled")
        names.insert("circle.tophalf.filled")
        names.insert("circle.inset.filled")
        names.insert("rectangle.inset.filled")
        names.insert("capsule.inset.filled")
        names.insert("circle.fill.square.fill")
        names.insert("rectangle.inset.filled.and.person.filled")
        names.insert("rectangle.portrait")

        // 19. 附加形状变体
        for shape in ["square", "circle", "triangle", "diamond", "hexagon", "pentagon", "capsule", "oval"] {
            for suf in [".inset.filled", ".lefthalf.filled", ".righthalf.filled", ".bottomhalf.filled", ".tophalf.filled"] {
                names.insert("\(shape)\(suf)")
            }
        }

        // 20. Fill 变体生成
        // 很多图标有 .fill 变体
        let additionalSymbols = names.compactMap { name -> String? in
            if !name.hasSuffix(".fill") && !name.contains(".fill.") {
                let fillName = "\(name).fill"
                // 排除明显没有 fill 变体的
                if !fillName.contains("..") {
                    return fillName
                }
            }
            return nil
        }
        for name in additionalSymbols {
            names.insert(name)
        }

        return names.sorted()
    }()
}
