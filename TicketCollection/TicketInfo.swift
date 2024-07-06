//
//  TicketInfo.swift
//  TicketCollection
//
//  Created by leo on 2024-07-05.
//

import SwiftUI

struct TicketInfo: Codable {
    var id: UUID = UUID()
    var ticketID: String
    var entrance: String
    var stationSrcCN: String
    var stationSrcEN: String
    var stationDstCN: String
    var stationDstEN: String
    var trainNumber: String
    var departTime: UInt64 //202401011405
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
}

extension TicketInfo {
    static let savePath = "\(NSHomeDirectory())/Documents/tickets"
    
    static func newEmpty() -> Self {
        Self(
            id: UUID(), ticketID: "XXX", entrance: "检票:99AB",
            stationSrcCN: "城市", stationSrcEN: "pinyin",
            stationDstCN: "城市", stationDstEN: "pinyin",
            trainNumber: "G9999", departTime: 202401010000,
            carriage: "16", seat: "01A", price: 0.01, seatLevel: "二等座",
            isOnline: false, isStudent: false, isDiscount: false,
            notes: "仅供报销使用", passengerID: "1234567890****9876",
            passengerName: "姓名", comments: "报销凭证 遗失不补\n退票改签时须交回车站",
            ticketSerial: "0000 XX"
        )
    }
    
    static func fromFile(filePath: String) throws -> Self {
//        let nsd = try NSDictionary(
//            contentsOf: URL(
//                filePath: filePath, directoryHint: .notDirectory
//            ), error: ()
//        )
//        let fileData = try JSONSerialization
//            .jsonObject(
//                with: Data(
//                    contentsOf: URL(
//                        filePath: filePath,
//                        directoryHint: .notDirectory
//                    ), options: .mappedIfSafe
//                ), options: .topLevelDictionaryAssumed
//            )
        let fileData = try Data(
            contentsOf: URL(
                filePath: filePath,
                directoryHint: .notDirectory
            ), options: .mappedIfSafe
        )
        let object = try JSONDecoder().decode(Self.self, from: fileData)
        return object
        
//        let nsd = fileData as! [String: Any]
        
//        return Self(
//            id: nsd["id"] as! UUID,
//            ticketID: nsd["ticketID"] as! String,
//            entrance: nsd["entrance"] as! String,
//            stationSrcCN: nsd["stationSrcCN"] as! String,
//            stationSrcEN: nsd["stationSrcEN"] as! String,
//            stationDstCN: nsd["stationDstCN"] as! String,
//            stationDstEN: nsd["stationDstEN"] as! String,
//            trainNumber: nsd["trainNumber"] as! String,
//            departTime: nsd["departTime"] as! UInt64,
//            carriage: nsd["carriage"] as! String,
//            seat: nsd["seat"] as! String,
//            price: nsd["price"] as! Float,
//            seatLevel: nsd["seatLevel"] as! String,
//            isOnline: nsd["isOnline"] as! Bool,
//            isStudent: nsd["isStudent"] as! Bool,
//            isDiscount: nsd["isDiscount"] as! Bool,
//            notes: nsd["notes"] as! String,
//            passengerID: nsd["passengerID"] as! String,
//            passengerName: nsd["passengerName"] as! String,
//            comments: nsd["comments"] as! String,
//            ticketSerial: nsd["ticketSerial"] as! String
//        )
    }
    
    static func fromFile(id: String) throws -> Self {
        try Self.fromFile(filePath: "\(Self.savePath)/\(id).json")
    }
    
    func save(to filePath: String = Self.savePath) throws {
//        let dict: [String: Any] = [
//            "id": id,
//            "ticketID": ticketID,
//            "entrance": entrance,
//            "stationSrcCN": stationSrcCN,
//            "stationSrcEN": stationSrcEN,
//            "stationDstCN": stationDstCN,
//            "stationDstEN": stationDstEN,
//            "trainNumber": trainNumber,
//            "departTime": departTime,
//            "carriage": carriage,
//            "seat": seat,
//            "price": price,
//            "seatLevel": seatLevel,
//            "isOnline": isOnline,
//            "isStudent": isStudent,
//            "isDiscount": isDiscount,
//            "notes": notes,
//            "passengerID": passengerID,
//            "passengerName": passengerName,
//            "comments": comments,
//            "ticketSerial": ticketSerial,
//        ]
        
        //let jsonData = try JSONSerialization
            //.data(withJSONObject: dict, options: [])
        
        let jsonData = try JSONEncoder().encode(self)
        let jsonURL = URL(filePath: filePath, directoryHint: .isDirectory)
            .appending(path: "\(id.uuidString).json", directoryHint: .notDirectory)
        try jsonData.write(to: jsonURL, options: [])
    }
}
