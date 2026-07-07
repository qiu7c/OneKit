import SwiftUI

struct DeltaForceView: View {
    @State private var selectedTab = 0
    var body: some View {
        VStack(spacing: 0) {
            Picker("", selection: $selectedTab) {
                Text("今日密码").tag(0); Text("研发部门").tag(1); Text("制造推荐").tag(2)
            }
            .pickerStyle(.segmented).padding(.horizontal, 12).padding(.vertical, 8)
            switch selectedTab {
            case 0: DailyPwdView(); case 1: ActivityView(); default: ManufacturingView()
            }
        }
        .background(Color.appBackground)
        .navigationTitle("三角洲助手").navigationBarTitleDisplayMode(.inline).toolbar(.hidden, for: .tabBar)
    }
}

// MARK: - 今日密码
struct DailyPwdView: View {
    @State private var data: DailyPwdData?; @State private var loading = true; @State private var error: String?; @State private var copied: String?
    var body: some View {
        ScrollView {
            if loading { ProgressView().padding(.top, 60) }
            else if let e = error { errView(e) }
            else if let d = data {
                HStack { Image(systemName: "clock").font(.caption2); Text("更新: \(d.updateTime)").font(.caption); Spacer() }.foregroundColor(.appSecondary).padding(.horizontal, 20).padding(.top, 8)
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                    ForEach(d.codes) { p in
                        VStack(spacing: 6) {
                            Text(p.name).font(.caption).foregroundColor(.appSecondary)
                            Text(p.code).font(.system(size: 28, design: .monospaced)).fontWeight(.bold).foregroundColor(.appForeground)
                            Button { UIPasteboard.general.string = p.code; copied = p.code; Haptic.success(); DispatchQueue.main.asyncAfter(deadline: .now()+1.5) { copied = nil } } label: {
                                Text(copied == p.code ? "已复制" : "复制").font(.caption2).fontWeight(.semibold).foregroundColor(copied == p.code ? Color.appBackground : .white).padding(.horizontal, 20).padding(.vertical, 5).background(Color.appForeground).clipShape(Capsule())
                            }
                        }.padding(14).frame(maxWidth: .infinity).background(Color.appCard).clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }.padding(16)
            }
        }.refreshable { await load() }.task { await load() }
    }
    func load() async { loading=true; error=nil; do { data = try await DeltaForceService.shared.fetchDailyPasswords() } catch { self.error=error.localizedDescription }; loading=false }
    func errView(_ e: String) -> some View { VStack(spacing:12) { Image(systemName:"wifi.slash").font(.system(size:36)).foregroundColor(.appSecondary.opacity(0.5)); Text(e).font(.body).foregroundColor(.appSecondary); Button("重试") { Task{await load()} }.fontWeight(.semibold).foregroundColor(.white).padding(.horizontal,32).padding(.vertical,10).background(Color.appForeground).clipShape(RoundedRectangle(cornerRadius:8)) }.padding(.top,60) }
}

// MARK: - 研发部门
struct ActivityView: View {
    @State private var data: ActivityData?; @State private var loading = true; @State private var error: String?
    var body: some View {
        ScrollView {
            if loading { ProgressView().padding(.top, 60) }
            else if let e = error { errView(e) }
            else if let d = data {
                HStack { Image(systemName: "timer").font(.caption2); Text(d.time).font(.caption).fontWeight(.semibold).foregroundColor(.appForeground); Spacer() }.padding(.horizontal, 20).padding(.top, 8)
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                    ForEach(d.items) { item in
                        VStack(spacing: 6) {
                            AsyncImage(url: URL(string: item.image)) { p in if let img = p.image { img.resizable().aspectRatio(contentMode: .fit).frame(height: 56) } else { RoundedRectangle(cornerRadius: 6).fill(Color.appCard).frame(height: 56).overlay(ProgressView()) } }
                            Text(item.name).font(.caption).foregroundColor(.appForeground).lineLimit(1).minimumScaleFactor(0.8)
                        }.padding(10).background(Color.appCard).clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }.padding(16)
            }
        }.refreshable { await load() }.task { await load() }
    }
    func load() async { loading=true; error=nil; do { data = try await DeltaForceService.shared.fetchActivityItems() } catch { self.error=error.localizedDescription }; loading=false }
    func errView(_ e: String) -> some View { VStack(spacing:12) { Image(systemName:"wifi.slash").font(.system(size:36)).foregroundColor(.appSecondary.opacity(0.5)); Text(e).font(.body).foregroundColor(.appSecondary); Button("重试") { Task{await load()} }.fontWeight(.semibold).foregroundColor(.white).padding(.horizontal,32).padding(.vertical,10).background(Color.appForeground).clipShape(RoundedRectangle(cornerRadius:8)) }.padding(.top,60) }
}

// MARK: - 制造推荐
struct ManufacturingView: View {
    @State private var data: ManufacturingData?; @State private var loading = true; @State private var error: String?
    var body: some View {
        ScrollView {
            if loading { ProgressView().padding(.top, 60) }
            else if let e = error { errView(e) }
            else if let d = data {
                LazyVStack(spacing: 10) {
                    ForEach(d.items) { item in
                        HStack(spacing: 12) {
                            AsyncImage(url: URL(string: item.icon)) { p in if let img = p.image { img.resizable().aspectRatio(contentMode: .fit).frame(width: 44, height: 44) } else { RoundedRectangle(cornerRadius: 6).fill(Color.appCard).frame(width:44,height:44).overlay(ProgressView()) } }
                            VStack(alignment: .leading, spacing: 2) { Text(item.name).font(.subheadline).fontWeight(.medium).foregroundColor(.appForeground).lineLimit(1); Text(item.workshop).font(.caption).foregroundColor(.appSecondary) }
                            Spacer()
                            VStack(alignment: .trailing) { Text("时收益").font(.system(size:9)).foregroundColor(.appTertiary); Text(item.hourlyProfit).font(.caption).fontWeight(.bold).foregroundColor(.green) }
                        }.padding(12).background(Color.appCard).clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }.padding(16)
                if let ft = d.fetchTime { Text("更新: \(ft)").font(.caption2).foregroundColor(.appTertiary).padding(.bottom, 8) }
            }
        }.refreshable { await load() }.task { await load() }
    }
    func load() async { loading=true; error=nil; do { data = try await DeltaForceService.shared.fetchManufacturing() } catch { self.error=error.localizedDescription }; loading=false }
    func errView(_ e: String) -> some View { VStack(spacing:12) { Image(systemName:"wifi.slash").font(.system(size:36)).foregroundColor(.appSecondary.opacity(0.5)); Text(e).font(.body).foregroundColor(.appSecondary); Button("重试") { Task{await load()} }.fontWeight(.semibold).foregroundColor(.white).padding(.horizontal,32).padding(.vertical,10).background(Color.appForeground).clipShape(RoundedRectangle(cornerRadius:8)) }.padding(.top,60) }
}
