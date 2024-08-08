//
//  TicketView.swift
//  TicketCollection
//
//  Created by leo on 2024-01-21.
//

import SwiftUI

struct TicketView: View {
    @Bindable var ticketInfo: TicketItem
    let ticketBG1 = Color(hue: 0.53, saturation: 0.15, brightness: 0.98)
    let ticketBG2 = Color(hue: 0.53, saturation: 0.40, brightness: 0.92)
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                Rectangle().fill(ticketBG1).frame(height: 4*4)
                Spacer(minLength: 28*4)
                Rectangle().fill(ticketBG1).frame(height: 4*4)
                Spacer()
            }
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(ticketBG1).frame(width: 86*4, height: 54*4) // physically 86x54mm
            VStack {
                Spacer()
                ZStack {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(ticketBG2)
                    VStack {
                        ticketBG1.frame(height: 10)
                        Spacer()
                    }
                }.frame(width: 86*4, height: 20+10)
            }
            contents.frame(width: 86*4, height: 54*4)
        }
        .frame(width: 87*4, height: 54*4)
        .drawingGroup()
    }
    
    @ViewBuilder var contents: some View {
        VStack(spacing: 0) {
            topLabels.frame(height: 26).padding(.horizontal, 20).padding(.top, 6)
            trainInfo.padding(.horizontal, 20)
            Spacer()
            passengerInfo.padding(.horizontal, 20)
            Text("CR CR CR CR CR CR CR CR CR CR CR CR CR CR CR CR CR CR CR CR CR CR CR CR CR CR CR CR CR CR CR CR CR CR CR CR CR CR CR CR CR CR CR CR CR CR CR")
                .font(.tcArialUMS(4.2)).foregroundColor(ticketBG2)
            bottomLabels.frame(height: 20).padding(.horizontal, 20)
        }
    }
    
    // MARK: - Top labels
    
    @ViewBuilder var topLabels: some View {
        HStack {
            Text(ticketInfo.ticketID).font(.tcArialUMS(18))
                .foregroundColor(.red).opacity(0.8)
            Spacer()
            Text(ticketInfo.entrance).font(.tc华文宋体(12))
                .foregroundColor(.black)
        }
    }
    
    // MARK: - Train and station info
    
    @ViewBuilder var trainInfo: some View {
        VStack {
            trainstation
            departime(ticketInfo.departTime)
            pricelevel
        }.foregroundColor(.black)
    }
    
    struct Triangle: Shape {
        var endWidth: CGFloat // 0.0~1.0
        func path(in rect: CGRect) -> Path {
            var path = Path()
            path.move(to: rect.origin)
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.maxX * endWidth, y: rect.maxY))
            path.closeSubpath()
            return path
        }
    }
    
    @ViewBuilder func station(_ cn: String, _ en: String) -> some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                HStack(spacing: 0) {
                    ForEach(0..<cn.count, id: \.self) {strIndex in
                        Spacer(minLength: 0)
                        Text(cn.prefix(strIndex + 1).suffix(1))
                    }
                }.font(.tc黑体(20))
                    
                Text("站").font(.tc宋体(12)).padding(.leading, 5)
            }
            Text(en).font(.tc宋体(12))
        }.frame(width: 108)
    }
    
    @ViewBuilder var trainstation: some View {
        HStack(spacing: 0) {
            station(ticketInfo.stationSrcCN, ticketInfo.stationSrcEN)
            Spacer()
            VStack(spacing: 0) {
                //FIXME: WRONG Font
                Text(ticketInfo.trainNumber).font(.tc宋体(20))
                VStack(spacing: 0) {
                    HStack {
                        Spacer()
                        Triangle(endWidth: 0.6).fill(Color.black)
                            .frame(width: 8)
                    }.frame(height: 2)
                    Capsule().fill(Color.black)
                        .frame(height: 1)
                }.frame(width: 60)
            }
            Spacer()
            station(ticketInfo.stationDstCN, ticketInfo.stationDstEN)
        }
    }

    @ViewBuilder func departime(_ t: Date) -> some View {
        let (year, month, day, hour, minute) = t.components
        HStack(spacing: 0) {
            Text(String(year)).font(.tcTechnicBold(16))
            Text("年").font(.tc宋体(9)).padding(.trailing, 6)
            Text(String(month)).font(.tcTechnicBold(16))
            Text("月").font(.tc宋体(9)).padding(.trailing, 6)
            Text(String(day)).font(.tcTechnicBold(16))
            Text("日").font(.tc宋体(9)).padding(.trailing, 6)
            Text(String(format: "%02d:%02d", hour, minute)).font(.tcTechnicBold(16))
            Text("开").font(.tc宋体(9))
            Spacer()
            seats.frame(width: 100)
        }
    }
    
    @ViewBuilder var seats: some View {
        HStack(spacing: 0) {
            Text(ticketInfo.carriage).font(.tcTechnicBold(16))
            Text("车").font(.tc宋体(9)).padding(.trailing, 4)
            Text(ticketInfo.seat.prefix(2)).font(.tcTechnicBold(16))
            Text(ticketInfo.seat.suffix(1)).font(.tcTechnicBold(12))
            Text("号").font(.tc宋体(9))
            Spacer()
        }
    }
    
    @ViewBuilder func circledText(_ txt: String) -> some View {
        Text(txt)
            .font(.tc宋体(13)).frame(width: 15, height: 15)
            .background(Circle().stroke(lineWidth: 0.5))
    }
    
    @ViewBuilder var pricelevel: some View {
        HStack(spacing: 0) {
            HStack(spacing: 0) {
                Text("¥").font(.tc宋体(16)).padding(.trailing, 2)
                Text(String(format: "%.2f", ticketInfo.price)).font(.tcTechnicBold(16))
                Text("元").font(.tc宋体(9))
                Spacer()
            }.frame(width: 100)
            Spacer()
            if ticketInfo.isOnline { circledText("网") }
            if ticketInfo.isStudent { circledText("学").padding(.horizontal, 4) }
            if ticketInfo.isDiscount { circledText("惠") }
            Spacer()
            HStack(spacing: 0) {
                Text(ticketInfo.seatLevel).font(.tc宋体(14))
            }.frame(width: 100)
        }
    }
    
    // MARK: - Passenger info and QR
    
    @ViewBuilder var passengerInfo: some View {
        VStack(spacing: 0) {
            HStack {
                Text(ticketInfo.notes).font(.tc华文宋体(12))
                Spacer()
            }
            HStack {
                VStack {
                    HStack {
                        Text(ticketInfo.passengerID)
                            .font(.tcTechnicBold(15))
                        Text(ticketInfo.passengerName)
                            .font(.tc宋体(15))
                        Spacer()
                    }
                    ZStack {
                        Rectangle().stroke(style: .init(
                            lineWidth: 1.0, lineCap: .butt,
                            lineJoin: .bevel, miterLimit: 2.0,
                            dash: [5, 2], dashPhase: 0)
                        )
                        .padding(.horizontal, 16)
                        Text(ticketInfo.comments)
                            .multilineTextAlignment(.center)
                            .font(.tc宋体(11))
                    }.frame(height: 29).padding(.trailing, 16)
                }
                Image(uiImage: QRGen.shared.generateQRCode(
//                    from: "com.wyw.TicketCollection", w: 56 * UIScreen.main.scale, h: 56 * UIScreen.main.scale
                    from: "com.wyw.TicketCollection", w: 56, h: 56
                ))
                    //.resizable().interpolation(.none).scaledToFit()
                    .frame(width: 56, height: 56)
            }
        }.foregroundColor(.black)
    }
    
    // MARK: - Bottom labels
    
    @ViewBuilder var bottomLabels: some View {
        HStack {
            Text(ticketInfo.ticketSerial)
                .font(.tc仿宋(14)).foregroundColor(.black)
            Spacer()
        }
    }
    
    // MARK: - Methods
    
    @MainActor func render() -> URL {
        // 1: Render Hello World with some modifiers
        let renderer = ImageRenderer(
            content: TicketView(ticketInfo: ticketInfo)
        )
        // 2: Save it to our documents directory
        let url = URL.documentsDirectory.appending(path: "ticket.pdf")
        // 3: Start the rendering process
        renderer.render { size, context in
            // 4: Tell SwiftUI our PDF should be the same size as the views we're rendering
            var box = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            // 5: Create the CGContext for our PDF pages
            guard let pdf = CGContext(url as CFURL, mediaBox: &box, nil) else {
                return
            }
            // 6: Start a new PDF page
            pdf.beginPDFPage(nil)
            // 7: Render the SwiftUI view data onto the page
            context(pdf)
            // 8: End the page and close the file
            pdf.endPDFPage()
            pdf.closePDF()
        }
        return url
    }
}

#Preview {
    TicketView(ticketInfo: .init()
//        ticketInfo: .constant(
//            TicketInfo(
//                ticketID: "Z156N032758",entrance: "检票:90AB",
//                stationSrcCN: "上海", stationSrcEN: "Shanghai",
//                stationDstCN: "上海虹桥", stationDstEN: "Shanghaihongqiao",
//                trainNumber: "G7631", departTime: 202401311405,
//                carriage: "02", seat: "01A",
//                price: 9876.54, seatLevel: "一等座",
//                isOnline: false, isStudent: true, isDiscount: false,
//                notes: "仅供报销使用", passengerID: "1234567890****9876",
//                passengerName: "姓名",
//                comments: "报销凭证 遗失不补\n退票改签时须交回车站",
//                ticketSerial: "26468311140823K009985 JM"
//            )
//        )
    )
}
