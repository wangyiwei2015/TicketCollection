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
                    
                Text("站").font(.tc宋体(15)).padding(.leading, 5)
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
                .padding(.trailing, 18)
        }
    }

    @ViewBuilder func departime(_ t: Date) -> some View {
        let (year, month, day, hour, minute) = t.components
        HStack(spacing: 0) {
            Text(String(year)).font(.tcTechnicBold(17))
            Text("年").font(.tc宋体(9)).padding(.trailing, 6)
            Text(String(month)).font(.tcTechnicBold(17))
            Text("月").font(.tc宋体(9)).padding(.trailing, 6)
            Text(String(day)).font(.tcTechnicBold(17))
            Text("日").font(.tc宋体(9)).padding(.trailing, 6)
            Text(String(format: "%02d:%02d", hour, minute)).font(.tcTechnicBold(17))
            Text("开").font(.tc宋体(9))
            //Spacer()
            seats.padding(.leading, 30)
            Spacer()
        }
    }
    
    @ViewBuilder var seats: some View {
        HStack(spacing: 0) {
            switch ticketInfo.ticketType {
            case .noSeat:
                Text("无座").font(.tc宋体(14)).frame(maxWidth: .infinity)
            case .seat: // 01车01A号
                Text(ticketInfo.carriage).font(.tcTechnicBold(16))
                Text("车").font(.tc宋体(9)).padding(.trailing, 4)
                Text(ticketInfo.seat.prefix(2)).font(.tcTechnicBold(16))
                Text(ticketInfo.seat.suffix(1)).font(.tcTechnicBold(12))
                Text("号").font(.tc宋体(9))
            case .bed: // 01车001号下铺
                Text(ticketInfo.carriage).font(.tcTechnicBold(16))
                Text("车").font(.tc宋体(9)).padding(.trailing, 4)
                if ticketInfo.seat.count > 3 {
                    Text(ticketInfo.seat.prefix(3)).font(.tcTechnicBold(16))
                    Text(ticketInfo.seat.suffix(
                        from: .init(utf16Offset: 3, in: ticketInfo.seat)
                    )).font(.tc宋体(14))
                }
            case .custom:
                Text(ticketInfo.seat).font(.tc宋体(14)).frame(maxWidth: .infinity)
            default:
                Text("INVALID")
            }
        }.frame(maxWidth: .infinity)
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
            if ticketInfo.isOnline { circledText("网").padding(.horizontal, 2) }
            if ticketInfo.isStudent { circledText("学").padding(.horizontal, 2) }
            if ticketInfo.isDiscount { circledText("惠").padding(.horizontal, 2) }
            Spacer()
            HStack(spacing: 0) {
                Text(ticketInfo.seatLevel).font(.tc黑体(13))
            }//.frame(width: 100)
            .padding(.horizontal, 32)
        }
    }
    
    // MARK: - Passenger info and QR
    
    @ViewBuilder var passengerInfo: some View {
        VStack(spacing: 0) {
            HStack {
                Text("\(ticketInfo.isRefunded ? "退票\n" : "")\(ticketInfo.notes)\(ticketInfo.isExtended ? "\n越站" : "")").font(.tc华文宋体(12))
                Spacer()
            }
            .fixedSize(horizontal: false, vertical: true)
            .frame(height: ticketInfo.isExtended ? 22 : 18)
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
    
//    @MainActor func render() -> URL {
//        // 1: Render Hello World with some modifiers
//        let renderer = ImageRenderer(
//            content: TicketView(ticketInfo: ticketInfo)
//        )
//        // 2: Save it to our documents directory
//        let url = URL.documentsDirectory.appending(path: "ticket.pdf")
//        // 3: Start the rendering process
//        renderer.render { size, context in
//            // 4: Tell SwiftUI our PDF should be the same size as the views we're rendering
//            var box = CGRect(x: 0, y: 0, width: size.width, height: size.height)
//            // 5: Create the CGContext for our PDF pages
//            guard let pdf = CGContext(url as CFURL, mediaBox: &box, nil) else {
//                return
//            }
//            // 6: Start a new PDF page
//            pdf.beginPDFPage(nil)
//            // 7: Render the SwiftUI view data onto the page
//            context(pdf)
//            // 8: End the page and close the file
//            pdf.endPDFPage()
//            pdf.closePDF()
//        }
//        print("render pdf")
//        return url
//    }
    
    @MainActor func makePDF() -> Data {
        let renderer = ImageRenderer(content: TicketView(ticketInfo: ticketInfo))
        let url = FileManager.default.temporaryDirectory.appending(path: "ExportedTicket.pdf")
        try? FileManager.default.removeItem(at: url)
        renderer.render { size, context in
            var box = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            guard let pdf = CGContext(url as CFURL, mediaBox: &box, nil)
            else { return }
            pdf.beginPDFPage(nil)
            context(pdf)
            pdf.endPDFPage()
            pdf.closePDF()
        }
        print("render make pdf")
        let data = try! Data(contentsOf: url, options: .alwaysMapped)
        return data
    }
    
    @MainActor func makeImage() -> UIImage? {
        let renderer = ImageRenderer(content: TicketView(ticketInfo: ticketInfo))
        renderer.scale = 8.0
        let generatedImage = renderer.uiImage
        return generatedImage
    }
    
    @MainActor func makeJPG() -> Data {
        let url = FileManager.default.temporaryDirectory.appending(path: "ExportedTicket.jpg")
        let generatedImage = makeImage()!
        try? FileManager.default.removeItem(at: url)
        try! generatedImage.jpegData(compressionQuality: 0.9)!.write(to: url, options: .atomic)
        let data = try! Data(contentsOf: url, options: .alwaysMapped)
        return data
    }
}

class TransferableTicket: Transferable {
    enum FileType {
        case pdf, jpg
    }
    init(_ item: TicketItem, _ fileType: FileType) {
        self.item = item
        self.fileType = fileType
    }
    let item: TicketItem
    let fileType: FileType
    static var transferRepresentation: some TransferRepresentation {
        DataRepresentation(exportedContentType: .pdf) { instance in
            switch instance.fileType {
            case .pdf: await TicketView(ticketInfo: instance.item).makePDF()
            case .jpg: await TicketView(ticketInfo: instance.item).makeJPG()
            default: fatalError()
            }
        }
    }
}

let exportPreview = SharePreview(
    "已打印1/1张车票，请收好您的证件",
    image: Image("export")
)

struct PreviewTickets: View {
    @State var opac: Double = 0.1
    
    var body: some View {
        let exampleItem1 = TicketItem()
        exampleItem1.ticketType = .noSeat
        exampleItem1.carriage = "88"
        exampleItem1.seat = "88A号"
        let t1 = TicketView(ticketInfo: exampleItem1)
        
        let exampleItem2 = TicketItem()
        exampleItem2.ticketType = .bed
        exampleItem2.carriage = "88"
        exampleItem2.seat = "88A号上铺"
        let t2 = TicketView(ticketInfo: exampleItem2)
        
        let exampleItem3 = TicketItem()
        exampleItem3.ticketType = .seat
        exampleItem3.carriage = "10"
        exampleItem3.seat = "09A"
        exampleItem3.isRefunded = true
        let t3 = TicketView(ticketInfo: exampleItem3)
        
        return VStack {
            Slider(value: $opac, in: 0...1)
            t1.overlay {
                //Image("devref1").resizable().scaledToFit().opacity(opac)
            }
            t2.overlay {
                //Image("devref2").resizable().scaledToFit().opacity(opac)
            }
            t3.overlay {
                //Image("devref3").resizable().scaledToFit().opacity(opac)
            }
        }
    }
}

#Preview {
    PreviewTickets()
}
