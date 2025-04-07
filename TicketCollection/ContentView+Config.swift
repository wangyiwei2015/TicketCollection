//
//  ContentView+Config.swift
//  TicketCollection
//
//  Created by leo on 2024-10-29.
//

import SwiftUI
import SwiftData

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
                    }
                } label: {Image(systemName: "xmark")
                }.buttonStyle(TCButtonStyle(filled: false))
                    .frame(width: 50, height: 40)
            }.padding()
            ScrollView(.vertical) {
                Text("V\(ver) (\(build))")
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
            ScrollView(.vertical) {
                Button("about") {
                    withAnimation(.easeOut(duration: 0.3)) {
                        showsConfig = false
                        showsAbout = true
                    }
                }
                
                Text("主页背景图片")
                Picker(selection: $bgImgName) {
                    Text("空白").tag("nil")
                    Text("皮革").tag("bgp")
                    Text("牛皮纸").tag("bgn")
                    Text("木纹").tag("bgw")
                    Text("软木板").tag("bgr")
                } label: {
                    Label("background", systemImage: "swift")
                }
                
                Toggle("编辑器扩展选项", isOn: $extEnabled).tint(ticketColorAuto)
            }
        }
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
