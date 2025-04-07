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
            var matched = true
            
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
            // 字母一个都没选 就不筛
            if !filters[3...8].contains(where: {$0}) { matched = filtered1 }
            else { matched = filtered1 && filtered2 }
            
            let searchItems = appliedSearchTerm
                .split(separator: try! Regex(",|;| |，|；"), omittingEmptySubsequences: true)
            if !searchItems.isEmpty {
                //deal with search
                var searchMatched = false
                for term in searchItems {
                    searchMatched ||= item.trainNumber.contains(term)
                    searchMatched ||= item.comments.contains(term)
                    searchMatched ||= item.notes.contains(term)
                    searchMatched ||= item.seat.contains(term)
                    searchMatched ||= item.carriage.contains(term)
                    searchMatched ||= item.entrance.contains(term)
                    searchMatched ||= item.stationSrcCN.contains(term)
                    searchMatched ||= item.stationSrcEN.contains(term)
                    searchMatched ||= item.stationDstCN.contains(term)
                    searchMatched ||= item.stationDstEN.contains(term)
                    searchMatched ||= item.seatLevel.contains(term)
                    searchMatched ||= item.passengerName.contains(term)
                    searchMatched ||= item.passengerID.contains(term)
                    searchMatched ||= item.ticketID.contains(term)
                    searchMatched ||= item.ticketSerial.contains(term)
                }
                //finally
                matched &&= searchMatched
            }
            return matched
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
    
    @ViewBuilder var experimentalLayout: some View {
        LazyVGrid(columns: [GridItem(.flexible())]) {
            Spacer(minLength: filterOn ? 240 : 120)
            if openedFolder == nil {
                Section {
                    if showAllTickets {
                        ForEach(filteredTickets) { item in
                            ZStack {
                                ticketColor
                                HStack {
                                    Button(item.id.uuidString) {
                                        selectedTicket = item
                                    }
                                }
                            }.id(item.id)
                        }
                        Text("item count \(tickets.count)")
                    }
                } header: {
                    ZStack {
                        Color.green
                        HStack {
                            Button("all") {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    if !showAllTickets {
                                        openedFolder = nil
                                    }
                                    showAllTickets.toggle()
                                }
                            }
                        }
                    }.id("allitemsfolder")
                }//section 0
            } //endif no open folder
            if !showAllTickets {
                ForEach(allFolders) { folder in
                    Section {
                        if openedFolder == folder {
                            ForEach(folder.tickets ?? []) { item in
                                ZStack {
                                    ticketColor
                                    HStack {
                                        Button(item.id.uuidString) {
                                            selectedTicket = item
                                        }
                                    }
                                }.id(item.id)
                            }
                            Text("item count \(folder.tickets?.count ?? 0)")
                        }
                    } header: {
                        if openedFolder == folder || openedFolder == nil {
                            ZStack {
                                Color.green
                                HStack {
                                    Button(folder.name) {
                                        withAnimation(.easeInOut(duration: 0.2)) {
                                            showAllTickets = false
                                            if openedFolder == folder {
                                                openedFolder = nil
                                            } else {
                                                openedFolder = folder
                                            }
                                        }
                                    }
                                }
                            }.id(folder.id)
                        }
                    }// section other
                }//foreach folder
            }//endif not show all
        }//lazy v grid
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
    
    return ContentView()
        .modelContainer(container)
}
