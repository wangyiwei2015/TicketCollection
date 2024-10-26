//
//  ContentView+TicketPreview.swift
//  TicketCollection
//
//  Created by leo on 2024-08-09.
//

import SwiftUI

extension ContentView {
    @ViewBuilder var ticketPreview: some View {
        // selected
        if let selection = selectedTicket {
            LinearGradient(
                gradient: Gradient(colors: [Color.black.opacity(0.65), Color.black.opacity(0.85)]),
                startPoint: .top, endPoint: .bottom
            )
            .ignoresSafeArea()
            .onTapGesture {
                withAnimation(.easeInOut(duration: 0.3)) {
                    selectedTicket = nil
                }
            }.zIndex(2)
            
            TicketView(ticketInfo: selection)
                .id(selection).transition(
                    .asymmetric(
                        insertion: .opacity.combined(with: .move(edge: .leading)).combined(with: .ticketView),
                        removal: .opacity.combined(with: .scale(scale: 0.8)).combined(with: .ticketView)
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(Color(white: 0.48 - translation2Degrees(dragOffset.width) / 100, opacity: translation2Degrees(dragOffset.width) / 100))
                        .shadow(
                            color: Color(white: 0.48 - translation2Degrees(dragOffset.width) / 100, opacity: translation2Degrees(dragOffset.width) / 100),
                            radius: 4, y: 0
                        )
                )
                .gesture(
                    DragGesture(minimumDistance: 20)
                        .onChanged { value in
                            dragOffset = value.translation
                        }
                        .onEnded { value in
                            withAnimation(.interpolatingSpring) {
                                dragOffset = .zero
                            }
                        }
                )
                .rotation3DEffect(
                    .degrees(translation2Degrees(dragOffset.width)),
                    axis: (x: 0.0, y: 1.0, z: 0.0),
                    perspective: 0.4
                )
                .zIndex(3)
            
            VStack {
                Spacer()
                
                HStack {
                    Button {
                        showsEditor = true
                    } label: {
                        Label("编辑车票", systemImage: "chevron.left")
                    }.buttonStyle(TCButtonStyle(filled: true, height: 48))
                        .frame(width: 130)
                    Spacer()
                    Button {
                        //
                    } label: {
                        Label("删除设计", systemImage: "chevron.left")
                    }.buttonStyle(TCButtonStyle(filled: false, height: 48))
                        .frame(width: 130)
                }.transition(.move(edge: .top)).padding(.horizontal, 40)
                
                Spacer().frame(height: 300)
                
                HStack {
                    Button {
                        //
                    } label: {
                        Label("保存图像", systemImage: "chevron.left")
                    }.buttonStyle(TCButtonStyle(filled: true, height: 48))
                        .frame(width: 130)
                    Spacer()
                    ShareLink("导出PDF", item: TicketView(ticketInfo: selectedTicket ?? .init()).render())
                        .buttonStyle(TCButtonStyle(filled: true, height: 48))
                        .frame(width: 130)
                }.transition(.move(edge: .bottom)).padding(.horizontal, 40)
                
                Spacer()
            }.zIndex(4)
        }
    }
}

import SwiftData

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: TicketItem.self, configurations: config)
    
    for i in 1...15 {
        let t = TicketItem()
        t.departTime = Date(timeIntervalSinceNow: TimeInterval(60 * i))
        container.mainContext.insert(t)
    }
    
    return ContentView()
        .modelContainer(container)
}
