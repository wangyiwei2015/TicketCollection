//
//  ContentView+Layouts.swift
//  TicketCollection
//
//  Created by leo on 2024-08-09.
//

import SwiftUI

extension ContentView {
    @ViewBuilder var listView: some View {
        LazyVGrid(columns: [GridItem(.flexible())]) {
            Spacer(minLength: filterOn ? 240 : 120)
            ForEach(filteredTickets) { item in
                HStack {
                    Button {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            selectedTicket = item
                        }
                    } label: {
                        HStack {
                            ZStack {
                                RoundedRectangle(cornerRadius: 4, style: .continuous)
                                    .fill(ticketColor)
                                    .matchedGeometryEffect(id: selectedTicket == item ? "ticket" : "", in: namespace, properties: .position, isSource: false)
                                    .frame(width: 87/2, height: 54/2)
                                    .scaleEffect(
                                        selectedTicket == item ? 3.0 : 1.0
                                    )
                                VStack(spacing: 0) {
                                    Spacer()
                                    RoundedRectangle(cornerRadius: 3)
                                        .fill(Color(colorScheme == .dark ? UIColor.systemGray4 : UIColor.systemBackground))
                                        .shadow(color: .black.opacity(0.3), radius: 0, y: -1.2)
                                        .shadow(color: .black.opacity(0.2), radius: 3, y: 1)
                                        .frame(height: 14)
                                }
                            }.frame(width: 87/2+2.5, height: 54/2+1).padding(.trailing, 10)
                            Text(item.trainNumber).font(.title3).bold().foregroundColor(colorScheme == .dark ? ticketColor : ticketColorDarker)
                            
                            if item.starred {
                                Image(systemName: "star.fill").padding(.leading, 10)
                                    .font(.system(size: 12)).foregroundStyle(.gray.opacity(0.5))
                            }
                            
                            Spacer()
                            
                            Text(defFormatter.string(from: item.departTime))
                                .multilineTextAlignment(.trailing)
                                .font(.system(size: 14)).lineSpacing(-4)
                                .foregroundColor(.gray)
                        }.padding(.horizontal)
                    }.buttonStyle(ListItemBtnStyle(colorScheme: colorScheme))
                    
                    Menu {
                        itemActions(for: item)
                    } label: {
                        Image(systemName: "ellipsis")
                    }.buttonStyle(RoundedBtnStyle(filled: false))
                        .frame(width: 26)
                        .padding(.leading, 8)
                        .padding(.trailing, 4)
                }
                .padding(.bottom, 10).padding(.leading, 20)
                .frame(height: 60)
            } // foreach
        } // vgrid
    }
}

import SwiftData

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: TicketItem.self, configurations: config)
    
//    for i in 1...3 {
//        var ts: [TicketItem] = []
//        for j in 1...4 {
//            let t = TicketItem(starred: j % 2 == 1)
//            t.departTime = Date(timeIntervalSinceNow: TimeInterval(60 * i + j))
//            container.mainContext.insert(t)
//            ts.append(t)
//        }
//        let f = TicketFolder(name: "F-\(i)", starred: i % 2 == 0)
//        container.mainContext.insert(f)
//    }
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
    UserDefaults.standard.set(0, forKey: "ViewMode")
    return ContentView()
        .modelContainer(container)
}
