//
//  Untitled.swift
//  TicketCollection
//
//  Created by leo on 2025.04.07.
//

import SwiftUI

extension ContentView {
    @ViewBuilder var gridView: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 160))]) {
            Spacer(); Spacer(minLength: filterOn ? 150 : 70)
            ForEach(filteredTickets) { item in
                GeometryReader { geo in
                    //let isSelected = selectedTicket == item
                    let y = Double(geo.frame(in: .global).minY)
                    let r = -max(0, 0.4 * (y - UIScreen.main.bounds.height + 300))
                    let s = max(0.001, min(1.0, 1 - 0.005 * (y - UIScreen.main.bounds.height + 200)))
                    return HStack {
                        Spacer()
                        ZStack {
                            TicketView(ticketInfo: item)
                                .onTapGesture {
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        selectedTicket = item
                                    }
                                }
                                .scaleEffect(
                                    selectedTicket == item ? 1.0 : 0.4
                                )
                                .background(
                                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                                        .fill(.black.opacity(0.9))
                                        .scaleEffect(CGSize(width: 0.39, height: 0.39))
                                        .shadow(
                                            color: .black.opacity(0.5), radius: 4, y: 4
                                        )
                                        .opacity(selectedTicket == item ? 0 : 1)
                                )
                                .matchedGeometryEffect(id: selectedTicket == item ? "ticket" : "", in: namespace, properties: .frame, isSource: false)
                                .contextMenu(ContextMenu {
                                    itemActions(for: item)
                                })
                                .overlay {
                                    if item.starred && selectedTicket != item {
                                        Image(systemName: "star.fill").font(.system(size: 16))
                                            .foregroundStyle(.yellow).shadow(color: .black.opacity(0.8), radius: 0.8)
                                            .rotationEffect(.degrees(15))
                                            .offset(x: 70, y: -44)
                                    }
                                }
                                .rotation3DEffect(
                                    .degrees(r),
                                    axis: (x: 1, y: 0, z: 0),
                                    perspective: 0.5
                                )
                                .scaleEffect(x: s, y: s)
                            // ticket view
                        }.drawingGroup()
                        Spacer()
                    } // hstack
                }.frame(width: 1000, height: 100)
                // geo reader
            } // foreach
        } // vgrid
    }
}

import SwiftData

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: TicketItem.self, configurations: config)
    
    for i in 1...3 {
        let t = TicketItem()
        t.departTime = Date(timeIntervalSinceNow: TimeInterval(60 * i))
        container.mainContext.insert(t)
    }
    for i in 1...3 {
        let f = TicketFolder(name: "F-\(i)", starred: i % 2 == 0)
        f.tickets?.append(TicketItem())
        f.tickets?.append(TicketItem())
        container.mainContext.insert(f)
    }
    UserDefaults.standard.set(1, forKey: "ViewMode")
    return ContentView()
        .modelContainer(container)
}
