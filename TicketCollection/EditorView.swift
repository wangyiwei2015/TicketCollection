//
//  EditorView.swift
//  TicketCollection
//
//  Created by leo on 2024-01-22.
//

import SwiftUI
import SwiftData

struct EditorView: View {
    @Environment(\.scenePhase) var scenePhase
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    @Bindable var ticketItem: TicketItem
    var allFolders: [TicketFolder]
    var extEnabled: Bool
    
    @State var isSettingFolder = false
    @State var selectedSection: Int = 0
    @State var notesTemplate: Int = 1
    @State var priceStr: String = "0.01" {
        willSet { ticketItem.price = Float(newValue) ?? 0.0 }
    }
    @State private var dragOffset: CGSize = .zero
    
    func translation2Degrees(_ x: CGFloat) -> Double {
        let w = Double(UIScreen.main.bounds.width)
        let dx = Double(x)
        return 45 * sin(.pi / 2 / w * dx)
    }
    
    @State var showsQuitAlert = false
    
    var body: some View {
        ZStack {
            VStack(spacing: 10) {
                HStack {
                    /*ShareLink("Export Image", item: {
                     let data = TicketView(ticketInfo: .constant(ticket)).snapshot().jpegData(compressionQuality: 1.0)!
                     let file = URL.documentsDirectory.appending(path: "ticket.jpg")
                     try! data.write(to: file, options: .atomic)
                     return file.path()
                     }()) */
                    if extEnabled {
                        Menu {
                            Button {
                                //show info
                                
                            } label: {
                                Label("详细信息", systemImage: "info.circle")
                            }
                            
                            Button {
                                try! modelContext.save()
                            } label: {
                                Label("保存", systemImage: "square.and.arrow.down.fill")
                            }.disabled(!modelContext.hasChanges)
                            
                            Button {
                                //no imp
                            } label: {
                                Label("另存为…", systemImage: "square.and.arrow.down.on.square")
                            }
                            
                            Button(role: modelContext.hasChanges ? .destructive : .cancel) {
                                if modelContext.hasChanges {
                                    showsQuitAlert = true
                                } else { dismiss() }
                            } label: {
                                Label("关闭", systemImage: "xmark")
                            }
                            
                            Text("创建于\(ticketItem.creationDate.formatted(date: .numeric, time: .shortened))")
                            Text("更新于\(ticketItem.lastModified.formatted(date: .numeric, time: .shortened))")
                        } label: {
                            Label("文件", systemImage: "list.dash")
                        }.buttonStyle(TCButtonStyle(filled: false))
                            .frame(width: 90)
                    } else {
                        Button {
                            try! modelContext.save()
                            dismiss()
                        } label: {
                            Label("完成", systemImage: "chevron.left")
                        }.buttonStyle(TCButtonStyle(filled: false))
                            .frame(width: 90)
                    }
                    Spacer()
                    Menu {
                        ShareLink("导出为PDF", item: TransferableTicket(ticketItem), preview: exportPreview)
                    } label: {
                        Label("分享", systemImage: "square.and.arrow.up")
                    }.buttonStyle(TCButtonStyle(filled: true))
                    .frame(width: 90)
                }.ignoresSafeArea().padding(.bottom)
                
                TicketView(ticketInfo: ticketItem)
                    .background(
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(.black.opacity(exp(-abs(dragOffset.width) / 400)))
                            .scaleEffect(CGSize(width: 0.985, height: 0.99))
                            .shadow(
                                color: .black.opacity(0.5),
                                radius: 2 + abs(dragOffset.width) / 10,
                                y: 2 + abs(dragOffset.width) / 30
                            )
                    )
                    //.animation(.easeInOut, value: dragOffset)
                    .gesture(
                        DragGesture(minimumDistance: 20)
//                            .updating($dragOffset) { value, state, transaction in
//                                state = value.translation
//                            }
                            .onChanged { value in
                                dragOffset = value.translation
                            }
                            .onEnded { value in
                                withAnimation(.interpolatingSpring) {
                                    dragOffset = .zero
                                }
                            }
                    )
                    .rotation3DEffect(
                        .degrees(translation2Degrees(dragOffset.width)),
                        axis: (x: 0.0, y: 1.0, z: 0.0),
                        perspective: 0.4
                    )
                    .padding(.bottom).ignoresSafeArea()
                Spacer()
            }
            
            VStack {
                Spacer()
                VStack(spacing: 0) {
                    Picker("Section", selection: $selectedSection) {
                        Text("列车信息").tag(1)
                        Text("乘客信息").tag(2)
                        Text("元数据").tag(3)
                    }.pickerStyle(.segmented).padding(10)
//                    TabView(selection: $selectedSection) {
//                        站台信息.tag(1)
//                        车次信息.tag(2)
//                        座位与乘客.tag(3)
//                        元数据.tag(4)
//                    }.tabViewStyle(.page)
                    Group {
                        switch selectedSection {
                        case 1: 站台信息.padding()
                        case 2: 列车信息.padding()
                        case 3: 元数据.padding([.horizontal, .top])
                        default: Text("未选择项目").padding()
                        }
                    }.frame(height: 300)
                }.background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.background)
                        .shadow(color: .black.opacity(0.3), radius: 2, y: 2)
                ).animation(.easeInOut(duration: 0.2), value: selectedSection)
            }.frame(maxWidth: 480)
        }
        .textFieldStyle(.roundedBorder)
        .padding()
        .background(
            Color(UIColor.systemGray6).ignoresSafeArea()
                .onTapGesture { selectedSection = 0 }
        )
        .onSubmit { ticketItem.price = Float(priceStr) ?? 0.0 }
        .onChange(of: scenePhase) { _, newValue in
            if newValue == .inactive {
                //try! modelContext.save()
            }
        }
        .alert("当前有未保存的更改", isPresented: $showsQuitAlert) {
            Button("保存后关闭", role: .none) {
                try! modelContext.save()
                dismiss()
            }
            Button("丢弃修改内容并关闭", role: .destructive) {
                modelContext.rollback()
                dismiss()
            }
            Button("取消", role: .cancel) {}
        }
    }
    
    @ViewBuilder var 站台信息: some View {
        VStack {
            HStack {
                Text("车次：")
                TextField("Train", text: $ticketItem.trainNumber, prompt: Text("车次"))
                    .multilineTextAlignment(.center).foregroundColor(ticketColorDarker).frame(width: 80)
                Spacer()
                Text("检票：")
                TextField("Entrance", text: $ticketItem.entrance, prompt: Text("检票/候车"))
                    .foregroundColor(ticketColorDarker).frame(width: 110)
            }
            DatePicker("发车时间：", selection: $ticketItem.departTime, displayedComponents: [.date, .hourAndMinute])
                .tint(ticketColorDarker).padding(.bottom)
                .datePickerStyle(.compact)
            HStack(spacing: 40) {
                VStack {
                    Text("—— 出发 ——")
                    TextField("Src CN", text: $ticketItem.stationSrcCN, prompt: Text("发站")).foregroundColor(ticketColorDarker)
                    TextField("Src EN", text: $ticketItem.stationSrcEN, prompt: Text("发站en")).foregroundColor(.gray)
                }
                VStack {
                    Text("—— 到达 ——")
                    TextField("Dst CN", text: $ticketItem.stationDstCN, prompt: Text("到站")).foregroundColor(ticketColorDarker)
                    TextField("Dst EN", text: $ticketItem.stationDstEN, prompt: Text("到站en")).foregroundColor(.gray)
                }
            }.multilineTextAlignment(.center).padding(.top)
            Spacer()
        }
        .onChange(of: ticketItem.stationSrcCN) { oldValue, newValue in
            ticketItem.stationSrcEN = newValue.拼音()!
        }
        .onChange(of: ticketItem.stationDstCN) { oldValue, newValue in
            ticketItem.stationDstEN = newValue.拼音()!
        }
    }
    
    @ViewBuilder var 列车信息: some View {
        VStack {
            HStack {
                Text("座位：")
                TextField("Carriage", text: $ticketItem.carriage, prompt: Text("车厢"))
                    .multilineTextAlignment(.center).foregroundColor(ticketColorDarker).frame(width: 50)
                Text("车")
                TextField("Seat", text: $ticketItem.seat, prompt: Text("座位"))
                    .multilineTextAlignment(.center).foregroundColor(ticketColorDarker).frame(width: 60)
                Text("号")
                Spacer()
            }
            HStack {
                Text("座位席别：")
                TextField("Type", text: $ticketItem.seatLevel, prompt: Text("类型"))
                    .multilineTextAlignment(.center).foregroundColor(ticketColorDarker).frame(width: 100)
                Text("¥")
                TextField("Price", text: $priceStr, prompt: Text("价格"))
                    .multilineTextAlignment(.center).foregroundColor(ticketColorDarker).frame(width: 90)
                Spacer()
            }
            
            HStack {
                Text("乘客：")
                Spacer()
            }
            HStack {
                TextField("User Name", text: $ticketItem.passengerName, prompt: Text("姓名")).foregroundColor(ticketColorDarker)
                    .frame(width: 88)
                TextField("User ID", text: $ticketItem.passengerID, prompt: Text("身份证")).foregroundColor(ticketColorDarker)
                    .frame(width: 210)
                Spacer()
            }.padding(.bottom)
            
            VStack {
                HStack {
                    Toggle("网购票", isOn: $ticketItem.isOnline).frame(width: 120)
                    Spacer()
                }
                HStack {
                    Toggle("学生票", isOn: $ticketItem.isStudent).frame(width: 120)
                    Spacer()
                    Toggle("优惠票", isOn: $ticketItem.isDiscount).frame(width: 120)
                    Spacer()
                }
            }.tint(ticketColor)
            Spacer()
        }
    }
    
    @ViewBuilder var 元数据: some View {
        VStack(spacing: 8) {
            HStack {
                Text("顶部编号")
                TextField("Ticket ID", text: $ticketItem.ticketID, prompt: Text("车票编号")).foregroundColor(.pink)
            }
            HStack {
                Text("底部编号")
                TextField("Serial", text: $ticketItem.ticketSerial, prompt: Text("底部编号")).foregroundColor(.primary)
            }.padding(.bottom, 6)
            
            HStack {
                Text("提示文字")
                Picker("NotesGen", selection: $notesTemplate) {
                    Text("报销凭证").tag(1)
                    //Others
                    Text("自定义").tag(0)
                }.pickerStyle(.segmented)
            }.onChange(of: notesTemplate) { _, newValue in
                if newValue == 1 {
                    ticketItem.notes = "仅供报销使用"
                    ticketItem.comments = "报销凭证 遗失不补\n退票改签时须交回车站"
                }
            }
            
            Group {
                TextField("Notes", text: $ticketItem.notes, prompt: Text("备注"))
                    .foregroundColor(notesTemplate == 0 ? .secondary : .gray)
                    .bold()
                TextField("Comments", text: $ticketItem.comments, prompt: Text("提示"), axis: .vertical)
                    .lineLimit(2, reservesSpace: true)
                    .foregroundColor(notesTemplate == 0 ? ticketColorDarker : .gray)
            }.disabled(notesTemplate != 0) //.transition(.opacity)
            .opacity(notesTemplate == 0 ? 1.0 : 0.5)
            
            HStack(spacing: 16) {
                Button {
                    ticketItem.starred.toggle()
                    //Task { try! modelContext.save() }
                } label: {
                    Image(systemName: ticketItem.starred ? "star.fill" : "star.slash")
                }.buttonStyle(TCButtonStyle(
                    filled: false, height: 32,
                    tint: ticketItem.starred ? .yellow : .gray
                )).frame(width: 50)
                
                Button {
                    //dismissKeyboard()
                    withAnimation(.spring(duration: 0.4, bounce: 0.5)) {
                        isSettingFolder = true
                    }
                } label: {
                    Label(ticketItem.inFolder?.name ?? "收进文件夹…", systemImage: "wallet.bifold")
                }.buttonStyle(TCButtonStyle(
                    filled: ticketItem.inFolder != nil, height: 32
                ))
                .overlay {
                    if isSettingFolder {
                        addFolderMenu.ignoresSafeArea()
                    }
                }
            }.padding(.top, 6)
            
            Spacer()
        }
    }
    
    @ViewBuilder var addFolderMenu: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 22).fill(Color(UIColor.systemGray5))
                .frame(width: 268, height: 208)
            Rectangle().fill(Color(UIColor.systemGray5))
                .frame(width: 38, height: 38)
                .rotationEffect(.degrees(45))
                .offset(y: 100)
            RoundedRectangle(cornerRadius: 20).fill(Color(UIColor.systemGray6))
                .frame(width: 260, height: 200)
            Rectangle().fill(Color(UIColor.systemGray6))
                .frame(width: 30, height: 30)
                .rotationEffect(.degrees(45))
                .offset(y: 100)
            if allFolders.isEmpty {
                VStack(spacing: 10) {
                    Image(systemName: "viewfinder.rectangular")
                        .font(.title2).bold()
                    Text("没有文件夹").font(.title3)
                }.foregroundStyle(.gray)
            } else {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 10) {
                        Button {
                            ticketItem.inFolder = nil
                            //try! modelContext.save()
                            withAnimation(.easeOut(duration: 0.2)) {
                                isSettingFolder = false
                            }
                        } label: {
                            Label("从文件夹移出", systemImage: "circle.slash")
                                .bold().foregroundStyle(.gray).padding(.vertical, 8)
                        }
                        ForEach(allFolders) { folderItem in
                            Button(folderItem.name) {
                                ticketItem.inFolder = folderItem
                                //try! modelContext.save()
                                withAnimation(.easeOut(duration: 0.2)) {
                                    isSettingFolder = false
                                }
                            }.buttonStyle(TCButtonStyle(filled: ticketItem.inFolder == folderItem))
                        }
                        
                    }.padding(.vertical, 10).padding(.horizontal, 4)
                }.padding(.vertical, 8).frame(width: 240)
            }
        }
        .offset(y: -130)
        .transition(.scale(scale: 0.8).combined(with: .opacity).combined(with: .offset(y: 10)))
        .padding(.bottom)
        .background {
            Rectangle().fill(EllipticalGradient(
                colors: [.black.opacity(0.6), .clear],
                startRadiusFraction: 0.0, endRadiusFraction: 0.3
            )).offset(y: 120)
                .frame(width: UIScreen.main.bounds.height * 2, height: UIScreen.main.bounds.height * 2)
                .onTapGesture {
                    withAnimation(.easeOut(duration: 0.2)) {
                        isSettingFolder = false
                    }
                }
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: TicketItem.self, configurations: config)
    
    let t = TicketItem()
    t.departTime = Date(timeIntervalSinceNow: TimeInterval(60))
    container.mainContext.insert(t)
    var f: [TicketFolder] = []
    for i in 1...7 {
        f.append(TicketFolder(name: UUID().uuidString, starred: i % 3 == 1))
    }
    
    return EditorView(
        ticketItem: t, allFolders: f, extEnabled: true,
        selectedSection: 3, notesTemplate: 0
    ).modelContainer(container)
}
