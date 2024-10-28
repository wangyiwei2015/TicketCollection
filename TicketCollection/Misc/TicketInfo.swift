//
//  TicketInfo.swift
//  TicketCollection
//
//  Created by leo on 2024-07-05.
//

import SwiftUI
import SwiftData

@available(iOS 17.0, *)
@Model final class TicketItem {
    var id: UUID = UUID()
    var ticketID: String
    var entrance: String
    var stationSrcCN: String
    var stationSrcEN: String
    var stationDstCN: String
    var stationDstEN: String
    var trainNumber: String
    var departTime: Date
    var carriage: String //02
    var seat: String //01A
    var price: Float
    var seatLevel: String
    var isOnline: Bool = false
    var isStudent: Bool = false
    var isDiscount: Bool = false
    var notes: String //仅供报销使用
    var passengerID: String
    var passengerName: String
    var comments: String
    var ticketSerial: String
    var starred: Bool = false
    
    init(ticketID: String, entrance: String, stationSrcCN: String, stationSrcEN: String, stationDstCN: String, stationDstEN: String, trainNumber: String, departTime: Date, carriage: String, seat: String, price: Float, seatLevel: String, isOnline: Bool = false, isStudent: Bool = false, isDiscount: Bool = false, notes: String = "仅供报销使用", passengerID: String, passengerName: String, comments: String = "报销凭证 遗失不补\n退票改签时须交回车站", ticketSerial: String) {
        self.ticketID = ticketID
        self.entrance = entrance
        self.stationSrcCN = stationSrcCN
        self.stationSrcEN = stationSrcEN
        self.stationDstCN = stationDstCN
        self.stationDstEN = stationDstEN
        self.trainNumber = trainNumber
        self.departTime = departTime
        self.carriage = carriage
        self.seat = seat
        self.price = price
        self.seatLevel = seatLevel
        self.isOnline = isOnline
        self.isStudent = isStudent
        self.isDiscount = isDiscount
        self.notes = notes
        self.passengerID = passengerID
        self.passengerName = passengerName
        self.comments = comments
        self.ticketSerial = ticketSerial
    }
    convenience init() {
        self.init(
            ticketID: "A888888", entrance: "检票:99AB",
            stationSrcCN: "城市", stationSrcEN: "pinyin",
            stationDstCN: "城市", stationDstEN: "pinyin",
            trainNumber: "G9999", departTime: Date(),
            carriage: "15", seat: "01A", price: 0.01, seatLevel: "一等座",
            isOnline: false, isStudent: false, isDiscount: false,
            notes: "仅供报销使用", passengerID: "1234567890****9876",
            passengerName: "姓名", comments: "报销凭证 遗失不补\n退票改签时须交回车站",
            ticketSerial: "00000000000000A888888 JM"
        )
    }
}

extension Date {
    var components: (year: Int, month: Int, day: Int, hour: Int, minute: Int) {
        let c = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: self)
        return (c.year!, c.month!, c.day!, c.hour!, c.minute!)
    }
    static func bySetting(_ year: Int, _ month: Int, _ day: Int = 1, _ hour: Int = 0, _ minute: Int = 0) -> Date {
        let cc = Calendar.current
        let y = cc.date(bySetting: .year, value: year, of: Date())!
        let m = cc.date(bySetting: .month, value: month, of: y)!
        let d = cc.date(bySetting: .day, value: day, of: m)!
        let t = cc.date(bySettingHour: hour, minute: minute, second: 0, of: d)!
        return t
    }
}

let defFormatter: DateFormatter = {
    let d = DateFormatter()
    d.dateFormat = "yyyy.MM.dd\n(hh:mm)"
    return d
}()
