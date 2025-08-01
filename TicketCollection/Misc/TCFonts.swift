//
//  TCFonts.swift
//  TicketCollection
//
//  Created by leo on 2024-01-21.
//

import SwiftUI

extension Font {
    //未使用: "STHeitiSC-Medium",
    static func tc宋体(_ fixedSize: CGFloat) -> Font {
        return .custom("SimSun", fixedSize: fixedSize)
    }
    static func tc仿宋(_ fixedSize: CGFloat) -> Font {
        return .custom("FangSong_GB2312", fixedSize: fixedSize)
    }
    static func tc华文宋体(_ fixedSize: CGFloat) -> Font {
        return .custom("STSong", fixedSize: fixedSize)
    }
    static func tc黑体(_ fixedSize: CGFloat) -> Font {
        return .custom("SimHei", fixedSize: fixedSize)
    }
    static func tcTechnicBold(_ fixedSize: CGFloat) -> Font {
        return .custom("Technic-Bold", fixedSize: fixedSize)
    }
    static func tcArialUMS(_ fixedSize: CGFloat) -> Font {
        return .custom("Arial Unicode MS", fixedSize: fixedSize)
    }
}

#Preview {
    PreviewTickets()
}
