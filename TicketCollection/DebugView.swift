//
//  DebugView.swift
//  TicketCollection
//
//  Created by leo on 2024-08-06.
//

#if DEBUG

import SwiftUI

struct DebugView: View {
    
    let str: [String] = [
        //"FangSong_GB2312",
        //"SimHei",
        //"SimSun",
        //"Arial Unicode MS",
        //"STSong",
        //"STHeitiSC-Medium",
        //"Technic-Bold",
        //"Technic",
        //"Songti SC",
        //"Heiti SC",
        "PingFang SC",
        "FreeSerif",
        "Gilroy",
        "SourceHanSansSC-Regular",
        "SourceHanSerifSC-Regular"
    ]
    
    var body: some View {
        VStack {
            ForEach(0..<str.count, id: \.self) {id in
                Text("\(str[id]) 123456中文")
                    .font(.custom(str[id], fixedSize: 40))
            }
            Button("all") {
                for family in UIFont.familyNames.sorted() {
                    let names = UIFont.fontNames(forFamilyName: family)
                    print("Family: \(family) Font names: \(names)")
                }
            }
        }
    }
}

#Preview {
    DebugView()
}

#endif
