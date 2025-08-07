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
    
    static var tc左上红编号: Font {
        //return tcArialUMS(18);
        return .custom("SourceHanSansSC-Regular", fixedSize: 18).weight(.regular)
    }
    static var tc右上检票: Font {
        //return tc华文宋体(12);
        return .custom("SourceHanSansSC-Regular", fixedSize: 12).weight(.regular)
    }
    static var tc车次字母: Font {
        //return tc宋体(20);
        return .custom("FreeSerif", fixedSize: 20).weight(.regular)
    }
    static var tc车次数字: Font {
        return tc宋体(20);
        return .custom("FreeSerif", fixedSize: 20).weight(.regular)
    }
    static var tc车站中文: Font {
        return tc黑体(20);
        //return .custom("", fixedSize: <#T##CGFloat#>).weight(<#T##Font.Weight#>)
    }
    static var tc站: Font {
        return tc宋体(15);
        //return .custom("", fixedSize: <#T##CGFloat#>).weight(<#T##Font.Weight#>)
    }
    static var tc车站英文: Font {
        return tc宋体(12);
        //return .custom("", fixedSize: <#T##CGFloat#>).weight(<#T##Font.Weight#>)
    }
    static var tc日期数字英文: Font {
        return tcTechnicBold(17);
        //return .custom("Gilroy", fixedSize: <#T##CGFloat#>).weight(<#T##Font.Weight#>)
    }
    static var tc日期中文: Font {
        return tc宋体(9);
        //return .custom("", fixedSize: <#T##CGFloat#>).weight(<#T##Font.Weight#>)
    }
    static var tc座位数字英文: Font {
        return tcTechnicBold(16);
        //return .custom("Gilroy", fixedSize: <#T##CGFloat#>).weight(<#T##Font.Weight#>)
    }
    static var tc座位中文: Font {
        return tc宋体(9);
        //return .custom("", fixedSize: <#T##CGFloat#>).weight(<#T##Font.Weight#>)
    }
    static var tc座位中文大: Font {
        return tc宋体(14);
        //return .custom("", fixedSize: <#T##CGFloat#>).weight(<#T##Font.Weight#>)
    }
    static var tc价格CNY: Font {
        return tc宋体(16);
        //return .custom("", fixedSize: <#T##CGFloat#>).weight(<#T##Font.Weight#>)
    }
    static var tc席别: Font {
        return tc黑体(13);
        //return .custom("", fixedSize: <#T##CGFloat#>).weight(<#T##Font.Weight#>)
    }
    static var tc提示标签中文: Font {
        return tc华文宋体(12);
        //return .custom("", fixedSize: <#T##CGFloat#>).weight(<#T##Font.Weight#>)
    }
    static var tc乘客姓名: Font {
        //return tc宋体(15);
        return .custom("SourceHanSerifSC-Bold", fixedSize: 14)
    }
    static var tc乘客身份证: Font {
        //return tcTechnicBold(15);
        return .custom("Gilroy", fixedSize: 14).weight(.bold) // TODO: Gilroy Bold
    }
    static var tc备注框: Font {
        return .custom("SourceHanSerifSC-Bold", fixedSize: 10)
    }
    static var tc左下黑编号: Font {
        //return tc仿宋(14);
        return .custom("FreeSerif", fixedSize: 13)
    }
    static var tc背景CR: Font {
        return .custom("PingFang SC", fixedSize: 4.1).weight(.bold)
    }
}

#Preview {
    PreviewTickets()
}
