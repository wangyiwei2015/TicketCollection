//
//  DateHelper.swift
//  TicketCollection
//
//  Created by leo on 2024-01-22.
//

import Foundation

let df: DateFormatter = {
    let _df = DateFormatter()
    _df.dateFormat = "YYYYMMDDHHmm"
    return _df
}()
