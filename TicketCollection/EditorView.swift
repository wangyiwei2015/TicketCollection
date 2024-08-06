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
    
//    @State var ticket = TicketInfo(
//        ticketID: "Z156N032758",entrance: "检票:90AB",
//        stationSrcCN: "郑州", stationSrcEN: "Zhengzhou",
//        stationDstCN: "上海虹桥", stationDstEN: "Shanghaihongqiao",
//        trainNumber: "G9876", departTime: 202401311405,
//        carriage: "02", seat: "01A",
//        price: 9876.54, seatLevel: "一等座",
//        isOnline: false, isStudent: true, isDiscount: false,
//        notes: "仅供报销使用", passengerID: "1234567890****9876",
//        passengerName: "姓名",
//        comments: "报销凭证 遗失不补\n退票改签时须交回车站",
//        ticketSerial: "26468311140823K009985 JM"
//    )

    @State var trainDate: Date {
        willSet {
            //let dateStr = df.string(from: newValue)
            //ticket.departTime = UInt64(dateStr) ?? 202312310000
            ticketItem.departTime = newValue
        }
    }
    @State var priceStr: String = "9876.54" {
        willSet {
            ticketItem.price = Float(newValue) ?? 0.0
        }
    }
    
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                /*ShareLink("Export Image", item: {
                    let data = TicketView(ticketInfo: .constant(ticket)).snapshot().jpegData(compressionQuality: 1.0)!
                    let file = URL.documentsDirectory.appending(path: "ticket.jpg")
                    try! data.write(to: file, options: .atomic)
                    return file.path()
                }())
                */
                ShareLink("Export PDF", item: TicketView(ticketInfo: ticketItem).render())
                //Button("Clear") {
                    //ticket = TicketInfo.newEmpty()
                    //ticketItem flush
                //}
                Button("save") {
                    do {
                        //try ticket.save()
                        try! modelContext.save()
                    } catch(let err) {
                        print(err.localizedDescription)
                    }
                }
//                Button("load") {
//                    let firstFile = try? FileManager.default.contentsOfDirectory(atPath: "\(NSHomeDirectory())/Documents")
//                    print(firstFile)
//                }
            }
            TicketView(ticketInfo: ticketItem).padding(.bottom)
            Group {
                HStack {
                    TextField("Ticket ID", text: $ticketItem.ticketID, prompt: Text("车票编号"))
                    TextField("Entrance", text: $ticketItem.entrance, prompt: Text("检票/候车"))
                }
                HStack {
                    TextField("Src CN", text: $ticketItem.stationSrcCN, prompt: Text("发站"))
                    TextField("Train", text: $ticketItem.trainNumber, prompt: Text("车次"))
                    TextField("Dst CN", text: $ticketItem.stationDstCN, prompt: Text("到站"))
                    
                }
                HStack {
                    TextField("Src EN", text: $ticketItem.stationSrcEN, prompt: Text("发站en"))
                    TextField("Dst EN", text: $ticketItem.stationDstEN, prompt: Text("到站en"))
                }
            }
            Group {
                DatePicker("发车时间", selection: $trainDate, displayedComponents: [.date, .hourAndMinute])
                HStack {
                    TextField("Carriage", text: $ticketItem.carriage, prompt: Text("车厢"))
                    TextField("Seat", text: $ticketItem.seat, prompt: Text("座位"))
                    TextField("Type", text: $ticketItem.seatLevel, prompt: Text("类型"))
                    TextField("Price", text: $priceStr, prompt: Text("价格"))
                }
            }
            Group {
                HStack {
                    Toggle("网购票", isOn: $ticketItem.isOnline)
                    Toggle("学生票", isOn: $ticketItem.isStudent)
                    Toggle("优惠票", isOn: $ticketItem.isDiscount)
                }.tint(Color(hue: 0.53, saturation: 0.40, brightness: 0.92))
                TextField("Notes", text: $ticketItem.notes, prompt: Text("备注"))
                HStack {
                    TextField("User ID", text: $ticketItem.passengerID, prompt: Text("身份证"))
                    TextField("User Name", text: $ticketItem.passengerName, prompt: Text("姓名"))
                        .frame(width: 100)
                }
                TextField("Comments", text: $ticketItem.comments, prompt: Text("提示")).lineLimit(2)
                TextField("Serial", text: $ticketItem.ticketSerial, prompt: Text("底部编号"))
            }
        }.textFieldStyle(.roundedBorder)
        .padding()
        
        .onSubmit {
            //ticket.departTime = UInt64(df.string(from: trainDate)) ?? 202312310000
            ticketItem.price = Float(priceStr) ?? 0.0
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
