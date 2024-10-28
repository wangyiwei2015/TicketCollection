//
//  ContentView+Layouts.swift
//  TicketCollection
//
//  Created by leo on 2024-08-09.
//

import SwiftUI

extension ContentView {
    
    var filteredTickets: [TicketItem] {
        tickets.filter { item in
            let starFiltered = !filters[0] || item.starred
            let futureFiltered = !filters[1] || item.departTime > .now
            let studentFiltered = !filters[2] || item.isStudent
            let filtered1 = starFiltered && futureFiltered && studentFiltered
            let fG = filters[3] && item.trainNumber.first == "G"
            let fD = filters[4] && item.trainNumber.first == "D"
            let fZ = filters[5] && item.trainNumber.first == "Z"
            let fT = filters[6] && item.trainNumber.first == "T"
            let fK = filters[7] && item.trainNumber.first == "K"
            let fC = filters[8] && item.trainNumber.first == "C"
            let filtered2 = fG || fD || fZ || fT || fK || fC
            if !filters[3...8].contains(where: {$0}) {
                return filtered1 // 字母一个都没选 就不筛
            }
            return filtered1 && filtered2
        }
    }
    
    @ViewBuilder var flowView: some View {
        LazyVGrid(columns: [GridItem(.flexible())]) {
            Spacer(minLength: filterOn ? 190 : 100)
            ForEach(filteredTickets) { item in
                GeometryReader { geo in
                    //let isSelected = selectedTicket == item
                    let y = Double(geo.frame(in: .global).minY)
                    return HStack {
                        Spacer()
                        TicketView(ticketInfo: item)
                            .overlay(
                                Group {
                                    if item.starred {
                                        Image(systemName: "star.fill").font(.system(size: 24))
                                            .foregroundStyle(.yellow).shadow(color: .black.opacity(0.8), radius: 0.8)
                                            .rotationEffect(.degrees(20))
                                            .offset(x: 170, y: -106)
                                    }
                                }
                            )
                            .scaleEffect(x: 0.8, y: 0.8)
                            .drawingGroup()
                            .background(
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .fill(.black.opacity(exp(y / 400)))
                                    .scaleEffect(CGSize(width: 0.785, height: 0.80))
                                    .shadow(
                                        color: .black.opacity(0.5),
                                        radius: 3 + y / 400, y: -2 - y / 400
                                    )
                                    .opacity(selectedTicket == item ? 0 : 1)
                            )
                            .matchedGeometryEffect(id: selectedTicket == item ? "ticket" : "", in: namespace, properties: .frame, isSource: false)
                            .rotation3DEffect(
                                .degrees(selectedTicket == item ? 0 : -y / 16 - 20),
                                axis: (x: 1, y: 0, z: 0),
                                perspective: 0.5
                            )
                        //.transition(.move(edge: .bottom))
                            .onTapGesture {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    selectedTicket = item
                                }
                            } // ticket view
                        Spacer()
                    } // hstack
                }.frame(height: 70)
                // geo reader
            } // foreach
        } // vgrid
    }
    
    @ViewBuilder var listView: some View {
        LazyVGrid(columns: [GridItem(.flexible())]) {
            Spacer(minLength: filterOn ? 220 : 120)
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
                                    .frame(width: 87/2, height: 54/2)
                                    .matchedGeometryEffect(id: selectedTicket == item ? "ticket" : "", in: namespace, properties: .frame, isSource: false)
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
                                .scaleEffect(x: 0.4, y: 0.4)
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
    
    for i in 1...15 {
        let t = TicketItem()
        t.departTime = Date(timeIntervalSinceNow: TimeInterval(60 * i))
        if i % 2 == 1 {
            t.starred = true
        }
        container.mainContext.insert(t)
    }
    
    return ContentView()
        .modelContainer(container)
}
