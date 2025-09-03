//
//  OnboardingView.swift
//  TicketCollection
//
//  Created by leo on 2025.09.03.
//

import SwiftUI

struct OnboardingView: View {
    @Environment(\.dismiss) var dismiss
    @AppStorage("_ONBOARDING_DONE") var onboardingDone = false
    let ticketColorAuto = Color(light: ticketColorDarker, dark: ticketColor)
    
    var body: some View {
        VStack {
            Text("欢迎").font(.title).bold().padding()
            Spacer()
            VStack(alignment: .leading, spacing: 30) {
                onboardingitem("数字化保存你的回忆", logo: Image(systemName: "filemenu.and.selection"))
                onboardingitem("集中管理所有收藏", logo: Image(systemName: "tray.full.fill"))
                onboardingitem("自定义设计尽情发挥创意", logo: Image(systemName: "pencil.and.outline"))
                onboardingitem("导出高清图像分享", logo: Image(systemName: "photo.on.rectangle.angled"))
            }.padding().background {
                RoundedRectangle(cornerRadius: 20).fill(Color(UIColor.systemGray6))
            }
            Spacer()
            Text("注意：此App仅用于创作和收藏纪念，不具备票务和提醒功能。相关服务请前往12306官方渠道获取。")
                .font(.system(size: 15)).foregroundStyle(.gray).padding(.vertical)
            Button("-      开始使用      -") {
                onboardingDone = true
                dismiss()
            }
            .buttonStyle(.borderedProminent)
            .font(.title2).tint(ticketColorAuto)
        }
        .padding()
        .ignoresSafeArea(.keyboard)
        .interactiveDismissDisabled()
    }
    
    @ViewBuilder func onboardingitem(_ msg: String, logo: Image) -> some View {
        HStack {
            logo.resizable().scaledToFit()
                .frame(width: 40).padding(.trailing)
                .foregroundStyle(ticketColorAuto)
            Text(msg).font(.title2)
            Spacer()
        }
    }
}

#Preview {
//    Color.gray.ignoresSafeArea().sheet(
//        isPresented: .constant(true)
//    ) { OnboardingView() }
    OnboardingView()
}
