//
//  ContentView+Config.swift
//  TicketCollection
//
//  Created by leo on 2024-10-29.
//

import SwiftUI

extension ContentView {
    @ViewBuilder var aboutView: some View {
        VStack {
            HStack {
                Group {
                    Image(systemName: "info.circle.fill").foregroundStyle(.gray)
                    Text("关于TicketBox").foregroundStyle(ticketColorDarker)
                }.font(.title2).bold()
                Spacer()
                Button {
                    withAnimation(.easeOut(duration: 0.3)) {
                        showsAbout = false
                    }
                } label: {Image(systemName: "xmark")
                }.buttonStyle(TCButtonStyle(filled: false))
                    .frame(width: 50, height: 40)
            }.padding()
            ScrollView(.vertical) {
                Text("V\(ver) (\(build))")
            }
        }
    }
    
    @ViewBuilder var configView: some View {
        VStack {
            HStack {
                Group {
                    Image(systemName: "gearshape.fill").foregroundStyle(.gray)
                    Text("应用偏好设置").foregroundStyle(ticketColorDarker)
                }.font(.title2).bold()
                Spacer()
                Button {
                    withAnimation(.easeOut(duration: 0.3)) {
                        showsConfig = false
                    }
                } label: {Image(systemName: "xmark")
                }.buttonStyle(TCButtonStyle(filled: false))
                    .frame(width: 50, height: 40)
            }.padding()
            ScrollView(.vertical) {
                Text("主页背景图片")
                Picker(selection: $bgImgName) {
                    Text("空白").tag("nil")
                    Text("皮革").tag("bgp")
                    Text("牛皮纸").tag("bgn")
                    Text("木板").tag("bgw")
                } label: {
                    Label("background", systemImage: "swift")
                }
            }
        }
    }
}
