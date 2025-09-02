//
//  TCFonts.swift
//  TicketCollection
//
//  Created by leo on 2024-01-21.
//

import SwiftUI

extension Font {
    
    static var tc左上红编号: Font {
        return .custom("SourceHanSansSC-Regular", fixedSize: 18).weight(.regular)
    }
    static var tc右上检票: Font {
        return .custom("SourceHanSansSC-Regular", fixedSize: 12).weight(.regular)
    }
    static var tc车次字母: Font {
        return .custom("FreeSerif", fixedSize: 20).weight(.regular)
    }
    static var tc车次数字: Font {
        return .custom("FreeSerif", fixedSize: 20).weight(.regular)
    }
    static var tc车站中文: Font {
        return .custom("SourceHanSansSC-Regular", fixedSize: 20)
    }
    static var tc站: Font {
        return .custom("SourceHanSerifSC-Bold", fixedSize: 14)
    }
    static var tc车站英文: Font {
        return .custom("FreeSerif", fixedSize: 12).weight(.bold)
    }
    static var tc日期数字英文: Font {
        return .custom("Gilroy", fixedSize: 15)
    }
    static var tc日期中文: Font {
        return .custom("SourceHanSerifSC-Bold", fixedSize: 10)
    }
    static var tc座位数字英文: Font {
        return .custom("Gilroy", fixedSize: 14)
    }
    static var tc座位中文: Font {
        return .custom("SourceHanSerifSC-Bold", fixedSize: 10)
    }
    static var tc座位中文大: Font {
        return .custom("SourceHanSerifSC-Bold", fixedSize: 14)
    }
    static var tc价格CNY: Font {
        return .custom("PingFang SC", fixedSize: 14).weight(.light)
    }
    static var tc席别: Font {
        return .custom("SourceHanSansSC-Regular", fixedSize: 13)
    }
    static var tc提示标签中文: Font {
        return .custom("SourceHanSerifSC-Bold", fixedSize: 12)
    }
    static var tc乘客姓名: Font {
        return .custom("SourceHanSerifSC-Bold", fixedSize: 14)
    }
    static var tc乘客身份证: Font {
        return .custom("Gilroy", fixedSize: 14).weight(.bold)
        // Note: only Gilroy Light is free. We add stroke on the text to immitate Bold
    }
    static var tc备注框: Font {
        return .custom("SourceHanSerifSC-Bold", fixedSize: 10)
    }
    static var tc左下黑编号: Font {
        return .custom("FreeSerif", fixedSize: 13)
    }
    static var tc背景CR: Font {
        return .custom("PingFang SC", fixedSize: 4.1).weight(.bold)
    }
}

#Preview {
    PreviewTickets()
}
