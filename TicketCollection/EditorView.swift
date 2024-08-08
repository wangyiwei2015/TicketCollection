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

    @State var selectedSection: Int = 0
    @State var notesTemplate: Int = 1
    @State var priceStr: String = "9876.54" {
        willSet { ticketItem.price = Float(newValue) ?? 0.0 }
    }
    @State private var dragOffset: CGSize = .zero
    
    func translation2Degrees(_ x: CGFloat) -> Double {
        let w = Double(UIScreen.main.bounds.width)
        let dx = Double(x)
        return 45 * sin(.pi / 2 / w * dx)
    }
    
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
                    Button {
                        try! modelContext.save()
                        dismiss()
                    } label: {
                        Label("返回", systemImage: "swift")
                    }.buttonStyle(TCButtonStyle(filled: false))
                        .frame(width: 90)
                    Spacer()
                    ShareLink("导出 PDF", item: TicketView(ticketInfo: ticketItem).render())
                        .buttonStyle(TCButtonStyle(filled: true))
                        .frame(width: 130)
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
                        case 3: 元数据.padding()
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
            Color(UIColor.systemBackground)
                .onTapGesture { selectedSection = 0 }
        )
        .onSubmit { ticketItem.price = Float(priceStr) ?? 0.0 }
        .onChange(of: scenePhase) { _, newValue in
            if newValue == .inactive {
                try! modelContext.save()
            }
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
        VStack {
            HStack {
                Text("顶部编号")
                TextField("Ticket ID", text: $ticketItem.ticketID, prompt: Text("车票编号")).foregroundColor(.pink)
            }
            HStack {
                Text("底部编号")
                TextField("Serial", text: $ticketItem.ticketSerial, prompt: Text("底部编号")).foregroundColor(.primary)
            }.padding(.bottom)
            
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
            
            if notesTemplate == 0 {
                Group {
                    TextField("Notes", text: $ticketItem.notes, prompt: Text("备注"))
                        .foregroundColor(ticketColorDarker)
                    TextField("Comments", text: $ticketItem.comments, prompt: Text("提示"), axis: .vertical)
                        .lineLimit(2, reservesSpace: true)
                        .foregroundColor(ticketColorDarker)
                }.transition(.opacity)
            }
            
            Spacer()
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: TicketItem.self, configurations: config)
    
    let t = TicketItem()
    t.departTime = Date(timeIntervalSinceNow: TimeInterval(60))
    container.mainContext.insert(t)
    
    return EditorView(ticketItem: t, selectedSection: 3, notesTemplate: 0)
        .modelContainer(container)
}
