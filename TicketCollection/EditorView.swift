//
//  EditorView.swift
//  TicketCollection
//
//  Created by leo on 2024-01-22.
//

import SwiftUI
import SwiftData

struct EditorView: View {
    @Environment(\.modelContext) var modelContext
    @Bindable var ticketItem: TicketItem

    @State var selectedSection: Int = 0
    
    @State var trainDate: Date {
        willSet { ticketItem.departTime = newValue }
    }
    @State var priceStr: String = "9876.54" {
        willSet { ticketItem.price = Float(newValue) ?? 0.0 }
    }
    
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                /*ShareLink("Export Image", item: {
                    let data = TicketView(ticketInfo: .constant(ticket)).snapshot().jpegData(compressionQuality: 1.0)!
                    let file = URL.documentsDirectory.appending(path: "ticket.jpg")
                    try! data.write(to: file, options: .atomic)
                    return file.path()
                }()) */
                ShareLink("Export PDF", item: TicketView(ticketInfo: ticketItem).render())
                Button("save") { try! modelContext.save() }
            }.ignoresSafeArea()
            
            TicketView(ticketInfo: ticketItem)
                .padding(.bottom).ignoresSafeArea()
            Spacer()
            
            VStack(spacing: 0) {
                Picker("Section", selection: $selectedSection) {
                    Text("站台信息").tag(1)
                    Text("车次信息").tag(2)
                    Text("座位与乘客").tag(3)
                    Text("元数据").tag(4)
                }.pickerStyle(.segmented).padding(10)
//                TabView(selection: $selectedSection) {
//                    站台信息.tag(1)
//                    车次信息.tag(2)
//                    座位与乘客.tag(3)
//                    元数据.tag(4)
//                }.tabViewStyle(.page)
                switch selectedSection {
                case 1: 站台信息.padding()
                case 2: 车次信息.padding()
                case 3: 座位与乘客.padding()
                case 4: 元数据.padding()
                default: Text("No selection").padding()
                }
            }.background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(.background)
                    .shadow(color: .black.opacity(0.3), radius: 2, y: 2)
            ).animation(.easeInOut(duration: 0.2), value: selectedSection)
        }
        .textFieldStyle(.roundedBorder)
        .padding()
        
        .onSubmit {
            ticketItem.price = Float(priceStr) ?? 0.0
        }
        
        .onChange(of: ticketItem.stationSrcCN) { oldValue, newValue in
            ticketItem.stationSrcEN = newValue.拼音()!
        }
    }
    
    @ViewBuilder var 站台信息: some View {
        VStack {
            HStack {
                TextField("Entrance", text: $ticketItem.entrance, prompt: Text("检票/候车"))
            }
            HStack {
                TextField("Src CN", text: $ticketItem.stationSrcCN, prompt: Text("发站"))
                TextField("Dst CN", text: $ticketItem.stationDstCN, prompt: Text("到站"))
            }
            HStack {
                TextField("Src EN", text: $ticketItem.stationSrcEN, prompt: Text("发站en"))
                TextField("Dst EN", text: $ticketItem.stationDstEN, prompt: Text("到站en"))
            }
        }
    }
    
    @ViewBuilder var 车次信息: some View {
        VStack {
            TextField("Train", text: $ticketItem.trainNumber, prompt: Text("车次"))
            DatePicker("发车时间", selection: $trainDate, displayedComponents: [.date, .hourAndMinute])
        }
    }
    
    @ViewBuilder var 座位与乘客: some View {
        VStack {
            HStack {
                TextField("Carriage", text: $ticketItem.carriage, prompt: Text("车厢"))
                TextField("Seat", text: $ticketItem.seat, prompt: Text("座位"))
                TextField("Type", text: $ticketItem.seatLevel, prompt: Text("类型"))
                TextField("Price", text: $priceStr, prompt: Text("价格"))
            }
            HStack {
                Toggle("网购票", isOn: $ticketItem.isOnline)
                Toggle("学生票", isOn: $ticketItem.isStudent)
                Toggle("优惠票", isOn: $ticketItem.isDiscount)
            }.tint(Color(hue: 0.53, saturation: 0.40, brightness: 0.92))
            HStack {
                TextField("User ID", text: $ticketItem.passengerID, prompt: Text("身份证"))
                TextField("User Name", text: $ticketItem.passengerName, prompt: Text("姓名"))
                    .frame(width: 100)
            }
        }
    }
    
    @ViewBuilder var 元数据: some View {
        VStack {
            TextField("Ticket ID", text: $ticketItem.ticketID, prompt: Text("车票编号"))
            TextField("Notes", text: $ticketItem.notes, prompt: Text("备注"))
            TextField("Comments", text: $ticketItem.comments, prompt: Text("提示")).lineLimit(2)
            TextField("Serial", text: $ticketItem.ticketSerial, prompt: Text("底部编号"))
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: TicketItem.self, configurations: config)
    
    let t = TicketItem()
    t.departTime = Date(timeIntervalSinceNow: TimeInterval(60))
    container.mainContext.insert(t)
    
    return EditorView(ticketItem: t, trainDate: Date())
        .modelContainer(container)
}
