//
//  ContentView+Config.swift
//  TicketCollection
//
//  Created by leo on 2024-10-29.
//

import SwiftUI
import SwiftData
import RevenueCat
import RevenueCatUI

extension ContentView {
    @ViewBuilder var aboutView: some View {
        VStack {
            HStack {
                Group {
                    Image(systemName: "info.circle.fill").foregroundStyle(.gray)
                    Text("关于TicketBox").foregroundStyle(ticketColorDarker)
                }.font(.title2).bold()
                Spacer()
                Button {
                    withAnimation(.easeOut(duration: 0.3)) {
                        showsAbout = false
                    } completion: {
                        showsIAP = false
                    }
                } label: {Image(systemName: "xmark")
                }.buttonStyle(TCButtonStyle(filled: false))
                    .frame(width: 50, height: 40)
            }.padding()
            ScrollView(.vertical) {
                VStack {
                    HStack {
                        if v1ProAccess { Image(systemName: "trophy.fill") }
                        Text("V\(ver) (\(build))").bold()
                    }.foregroundStyle(.secondary)
                    Button {
                        openURL(URL(string: "https://github.com/wangyiwei2015/TicketCollection")!)
                    } label: {
                        Label("在 GitHub 查看源代码", systemImage: "chevron.left.forwardslash.chevron.right")
                            .frame(height: 46)
                    }.buttonStyle(TCButtonStyle())
                        .padding(10)
                    Button {
                        openURL(URL(string: "mailto:wangyw.dev@outlook.com?subject=Feedback-Ticket-\(build)")!)
                    } label: {
                        Label("获取帮助 / 反馈问题", systemImage: "envelope.fill")
                            .frame(height: 46)
                    }.buttonStyle(TCButtonStyle())
                        .padding(10)
                    
                    Text("本项目致力于数字化保存火车票，无惧褪色，珍藏属于你的旅行记忆。\n\n2025.10｜铁路部门不再提供纸质报销凭证\n2024.11｜车票全面数字化，纸质票仅作为报销凭证\n2024.01｜本项目开始设计开发\n")
                        .monospaced()
                        .foregroundStyle(.secondary).padding(.top, 50)
                }.padding(.horizontal)
            }
        }
    }
    
    @ViewBuilder var configView: some View {
        VStack {
            HStack {
                Group {
                    Image(systemName: "gearshape.fill").foregroundStyle(.gray)
                    Text("应用偏好设置").foregroundStyle(ticketColorDarker)
                }.font(.title2).bold()
                Spacer()
                Button {
                    withAnimation(.easeOut(duration: 0.3)) {
                        showsConfig = false
                    }
                } label: {Image(systemName: "xmark")
                }.buttonStyle(TCButtonStyle(filled: false))
                    .frame(width: 50, height: 40)
            }.padding()
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 20) {
                    
                    HStack {
                        Text("主页背景图片").bold().font(.title3)
                            .foregroundStyle(v1ProAccess ? ticketColorAuto : .gray)
                            .padding(.leading, 10)
                        Spacer()
                        
                        if v1ProAccess {
                            Menu {
                                Button("空白") { bgImgName = "nil" }
                                Button("皮革") { bgImgName = "bgp" }
                                Button("牛皮纸") { bgImgName = "bgn" }
                                Button("木纹") { bgImgName = "bgw" }
                                Button("软木板") { bgImgName = "bgr" }
                            } label: {
                                Label(bgImgNameShown[bgImgName] ?? "未知", systemImage: "chevron.up.chevron.down")
                                    .frame(height: 46)
                            }.buttonStyle(TCButtonStyle()).frame(width: 120)
                        } else {
                            Label("无", systemImage: "lock").bold()
                                .foregroundStyle(.gray).frame(width: 120)
                        }
                    }
                    .padding(10)
                    //.background(bg).padding(.horizontal, 10)
                    
                    HStack {
                        //Toggle("编辑器扩展选项", isOn: $extEnabled).tint(ticketColorAuto)
                        Text("编辑器操作模式").bold().font(.title3)
                            .foregroundStyle(ticketColorAuto)
                            .padding(.leading, 10)
                        Spacer()
                        
                        Menu {
                            Button("简易") { extEnabled = false }
                            Button("专业") { extEnabled = true }
                        } label: {
                            Label(extEnabled ? "专业" : "简易", systemImage: "chevron.up.chevron.down")
                                .frame(height: 46)
                        }.buttonStyle(TCButtonStyle()).frame(width: 120)
                    }
                    .padding(10)
                    //.background(bg).padding(.horizontal, 10)
                    
                    Button {
                        withAnimation(.easeOut(duration: 0.3)) {
                            showsConfig = false
                            showsAbout = true
                        }
                    } label: {
                        Label("关于TicketBox app", systemImage: "info.circle") //trophy
                            .frame(height: 46)
                    }.buttonStyle(TCButtonStyle())
                        .padding(.horizontal, 10).padding(.vertical)
                    
                    Button {
                        withAnimation(.easeOut(duration: 0.2)) {
                            showsIAP.toggle()
                        }
                    } label: {
                        Label("给开发者打赏", systemImage: "medal.fill") //trophy
                            .frame(height: 46)
                    }.buttonStyle(TCButtonStyle(filled: showsIAP))
                        .padding(.horizontal, 10)
                    
                    if showsIAP {
                        VStack(spacing: 10) {
                            HStack(spacing: 16) {
                                Button {
                                    Task { await payOneTime("com.wyw.ticketbox.donation.1") }
                                } label: {
                                    Label("¥6", systemImage: "bolt")
                                }.buttonStyle(TCButtonStyle())
                                Button {
                                    Task { await payOneTime("com.wyw.ticketbox.donation.2") }
                                } label: {
                                    Label("¥12", systemImage: "bolt")
                                }.buttonStyle(TCButtonStyle())
                                Button {
                                    Task { await payOneTime("com.wyw.ticketbox.donation.3") }
                                } label: {
                                    Label("¥28", systemImage: "bolt")
                                }.buttonStyle(TCButtonStyle())
                            }.frame(height: 46).padding(.horizontal, 10)
                            
                            if !subscribingIAP {
                                HStack(spacing: 16) {
                                    Button {
                                        Task { await payOneTime("com.wyw.ticketbox.sponsor.1") }
                                    } label: {
                                        Label("每月 ¥3", systemImage: "bolt.fill")
                                    }.buttonStyle(TCButtonStyle())
                                    Button {
                                        Task { await payOneTime("com.wyw.ticketbox.sponsor.2") }
                                    } label: {
                                        Label("每年 ¥18", systemImage: "bolt.fill")
                                    }.buttonStyle(TCButtonStyle())
                                }.frame(height: 46).padding(.horizontal, 10)
                            }
                            #if DEBUG
                            HStack(spacing: 16) {
                                Button {
                                    v1ProAccess = true
                                } label: {
                                    Label("DEBUG: 直接免费搞到", systemImage: "swift")
                                }.buttonStyle(TCButtonStyle())
                            }.frame(height: 46).padding(.horizontal, 10)
                            #endif
                        }
                        .sheet(isPresented: $paywallShown) {
                            PaywallView(displayCloseButton: true)
                        }
                    } else {
                        if v1ProAccess {
                            Label("你已获得全部功能！", systemImage: "trophy.fill")
                            .foregroundStyle(.secondary)
                        } else {
                            Button("恢复已购内容") {
                                Task {
                                    if let info = try? await Purchases.shared.restorePurchases() {
                                        v1ProAccess = !info.entitlements.active.isEmpty
                                        subscribingIAP = !info.activeSubscriptions.isEmpty
                                    }
                                }
                            }.foregroundStyle(.secondary)
                        }
                    }
                    
                    Text("选择打赏任意金额即可获得：\n- 自定义背景图像\n- 文件夹管理功能\n- 导出无损PDF文件\n\n任意一项订阅可以永久获得订阅结束前上线的全部功能。\n订阅可随时取消，请于下一次收费开始前，在iCloud账户设置或App Store设置的订阅中取消。")
                        .foregroundStyle(.secondary)
                        .padding(10)
                }.padding(.top).padding(.horizontal) // VStack
            }
        }
    }
    
    func payOneTime(_ id: String) async {
        if let prod = await Purchases.shared
            .products([id])
            .first {
            if let result = try? await Purchases.shared
                .purchase(product: prod) {
                v1ProAccess = !result.customerInfo.entitlements.active.isEmpty
                subscribingIAP = !result.customerInfo.activeSubscriptions.isEmpty
            } else { print("purchase failed") }
        } else { print("no such product") }
    }
    
    @ViewBuilder var folderView: some View {
        VStack {
            HStack {
                Group {
                    Image(systemName: "wallet.bifold").foregroundStyle(.gray)
                    Text("所有文件夹").foregroundStyle(ticketColorDarker)
                }.font(.title2).bold()
                Spacer()
                Button {
                    withAnimation(.easeOut(duration: 0.3)) {
                        showsFolderView = false
                    }
                } label: {Image(systemName: "xmark")
                }.buttonStyle(TCButtonStyle(filled: false))
                    .frame(width: 50, height: 40)
            }.padding()
            ScrollView(.vertical) {
                VStack {
                    Text("共有\(allFolders.count)个文件夹").bold().foregroundStyle(.gray)
                    //add new
                    HStack {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color(UIColor.systemGray5))
                            HStack {
                                TextField("AddNewName", text: $newFolderNameEntry, prompt: Text("在此输入来创建"))
                                    .textFieldStyle(.plain).submitLabel(.done)
                                    .scrollDismissesKeyboard(.never).autocorrectionDisabled()
                                    .multilineTextAlignment(.leading)
                                    .font(.system(size: 20)).lineLimit(1)
                                    .foregroundStyle(ticketColorAuto)
                                    .padding(.horizontal)
                                    .onSubmit(of: .text) {
                                        withAnimation(.snappy) {
                                            let newItem = TicketFolder(name: newFolderNameEntry)
                                            modelContext.insert(newItem)
                                            newFolderNameEntry = ""
                                            Task { try! modelContext.save() }
                                        }
                                    }
                                Button {
                                    dismissKeyboard()
                                    withAnimation(.snappy) {
                                        let newItem = TicketFolder(name: newFolderNameEntry)
                                        modelContext.insert(newItem)
                                        newFolderNameEntry = ""
                                        Task { try! modelContext.save() }
                                    }
                                } label: { Image(systemName: "plus")
                                }.buttonStyle(TCButtonStyle(filled: !newFolderNameEntry.isEmpty))
                                    .aspectRatio(1, contentMode: .fit)
                                    .padding(6).disabled(newFolderNameEntry.isEmpty)
                            }
                        }
                    }.frame(height: 36+12)
                    //all existing
                    ForEach(allFolders) { item in
                        HStack {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color(UIColor.systemGray6))
                                HStack {
                                    FolderItemView(folderItem: item)
                                        .foregroundStyle(ticketColorAuto)
                                        .padding(.leading)
                                    Image(systemName: "star.fill")
                                        .foregroundStyle(item.starred ? Color.yellow : Color(UIColor.systemGray4))
                                    Menu {
                                        Text("文件夹中有\(item.tickets?.count ?? 0)张车票")
                                        Button {
                                            item.starred.toggle()
                                            Task { try! modelContext.save() }
                                        } label: {
                                            Label(item.starred ? "取消收藏" : "收藏", systemImage: item.starred ? "star.slash.fill" : "star")
                                        }
                                        Button(role: .destructive) {
                                            folderToDelete = item
                                            alertFolderDel = true
                                        } label: {
                                            Label("解散并删除", systemImage: "trash")
                                        }
                                    } label: { Image(systemName: "ellipsis")
                                    }.buttonStyle(TCButtonStyle(filled: false))
                                        .aspectRatio(1, contentMode: .fit)
                                        .padding(6)
                                }
                            }
                        }.frame(height: 36+12)
                    }
                    if allFolders.isEmpty {
                        Text("当前没有文件夹，请在上方创建").foregroundStyle(ticketColorDarker)
                            .padding(.top)
                    }
                }.padding(.horizontal)
            }
        }.padding(.bottom, 10)
    }

//    func bindingString(_ id: String) -> Binding<String> {
//        return Binding(
//            get: { self.folders[id] ?? "" },
//            set: { self.folders[id] = $0 }
//        )
//    }
}

struct FolderItemView: View {
    @Bindable var folderItem: TicketFolder
    
    var body: some View {
        TextField("EditName", text: $folderItem.name, prompt: Text("未命名"))
            .textFieldStyle(.plain).submitLabel(.done)
            .scrollDismissesKeyboard(.never).autocorrectionDisabled()
            .multilineTextAlignment(.leading)
            .font(.system(size: 20)).lineLimit(1)
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: TicketItem.self, configurations: config)
    
    for i in 1...3 {
        let t = TicketItem()
        t.departTime = Date(timeIntervalSinceNow: TimeInterval(60 * i))
        container.mainContext.insert(t)
    }
    for i in 1...3 {
        let f = TicketFolder(name: "F-\(i)", starred: i % 2 == 0, tickets: [])
        container.mainContext.insert(f)
    }
    
    return ContentView(showsConfig: true)
        .modelContainer(container)
}
