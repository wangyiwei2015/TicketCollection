//
//  EditorView.swift
//  TicketCollection
//
//  Created by leo on 2024-01-22.
//

import SwiftUI

struct EditorView: View {
    @State var ticket = TicketInfo(
        ticketID: "Z156N032758",entrance: "检票:90AB",
        stationSrcCN: "郑州", stationSrcEN: "Zhengzhou",
        stationDstCN: "上海虹桥", stationDstEN: "Shanghaihongqiao",
        trainNumber: "G9876", departTime: 202401311405,
        carriage: "02", seat: "01A",
        price: 9876.54, seatLevel: "一等座",
        isOnline: false, isStudent: true, isDiscount: false,
        notes: "仅供报销使用", passengerID: "1234567890****9876",
        passengerName: "姓名",
        comments: "报销凭证 遗失不补\n退票改签时须交回车站",
        ticketSerial: "26468311140823K009985 JM"
    )

    @State var trainDate: Date {
        willSet {
            let dateStr = df.string(from: newValue)
            ticket.departTime = UInt64(dateStr) ?? 202312310000
            //print(dateStr)
        }
    }
    @State var priceStr: String = "9876.54" {
        willSet {
            ticket.price = Float(newValue) ?? 0.0
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
                ShareLink("Export PDF", item: TicketView(ticketInfo: .constant(ticket)).render())
                Button("Clear") {
                    ticket = TicketInfo.newEmpty()
                }
                Button("save") {
                    do {
                        try ticket.save()
                    } catch(let err) {
                        print(err.localizedDescription)
                    }
                }
                Button("load") {
                    let firstFile = try? FileManager.default.contentsOfDirectory(atPath: "\(NSHomeDirectory())/Documents")
                    print(firstFile)
                }
            }
            TicketView(ticketInfo: $ticket).padding(.bottom)
            Group {
                HStack {
                    TextField("Ticket ID", text: $ticket.ticketID, prompt: Text("车票编号"))
                    TextField("Entrance", text: $ticket.entrance, prompt: Text("检票/候车"))
                }
                HStack {
                    TextField("Src CN", text: $ticket.stationSrcCN, prompt: Text("发站"))
                    TextField("Train", text: $ticket.trainNumber, prompt: Text("车次"))
                    TextField("Dst CN", text: $ticket.stationDstCN, prompt: Text("到站"))
                    
                }
                HStack {
                    TextField("Src EN", text: $ticket.stationSrcEN, prompt: Text("发站en"))
                    TextField("Dst EN", text: $ticket.stationDstEN, prompt: Text("到站en"))
                }
            }
            Group {
                DatePicker("发车时间", selection: $trainDate, displayedComponents: [.date, .hourAndMinute])
                HStack {
                    TextField("Carriage", text: $ticket.carriage, prompt: Text("车厢"))
                    TextField("Seat", text: $ticket.seat, prompt: Text("座位"))
                    TextField("Type", text: $ticket.seatLevel, prompt: Text("类型"))
                    TextField("Price", text: $priceStr, prompt: Text("价格"))
                }
            }
            Group {
                HStack {
                    Toggle("网购票", isOn: $ticket.isOnline)
                    Toggle("学生票", isOn: $ticket.isStudent)
                    Toggle("优惠票", isOn: $ticket.isDiscount)
                }.tint(Color(hue: 0.53, saturation: 0.40, brightness: 0.92))
                TextField("Notes", text: $ticket.notes, prompt: Text("备注"))
                HStack {
                    TextField("User ID", text: $ticket.passengerID, prompt: Text("身份证"))
                    TextField("User Name", text: $ticket.passengerName, prompt: Text("姓名"))
                        .frame(width: 100)
                }
                TextField("Comments", text: $ticket.comments, prompt: Text("提示")).lineLimit(2)
                TextField("Serial", text: $ticket.ticketSerial, prompt: Text("底部编号"))
            }
        }.textFieldStyle(.roundedBorder)
        .padding()
        
        .onSubmit {
            ticket.departTime = UInt64(df.string(from: trainDate)) ?? 202312310000
            ticket.price = Float(priceStr) ?? 0.0
        }
    }
}

#Preview {
    EditorView(trainDate: Date())
}
