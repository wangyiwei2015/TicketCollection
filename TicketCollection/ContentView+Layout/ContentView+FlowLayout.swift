//
//  ContentView+FlowLayout.swift
//  TicketCollection
//
//  Created by leo on 2025.04.07.
//

import SwiftUI

extension ContentView {
    @ViewBuilder var flowView: some View {
        LazyVGrid(columns: [GridItem(.flexible())]) {
            Spacer(minLength: filterOn ? 190 : 100)
            
//            ForEach(filteredTickets) { item in
//                flowCell(for: item)
//            } // foreach
            
            if openedFolder == nil {
                Section {
                    if showAllTickets {
                        ForEach(filteredTickets) { item in
                            flowCell(for: item).id(item.id)
                        }
                        //Text("共有 \(tickets.count) 项").foregroundStyle(.secondary)
                    }
                } header: {
                    ZStack {
                        if v1ProAccess {
                            HStack {
                                Button {
                                    if !v1ProAccess { return }
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        if !showAllTickets {
                                            openedFolder = nil
                                        }
                                        showAllTickets.toggle()
                                    }
                                } label: {
                                    folderLabel(of: nil)
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
                            ForEach(filteredTicketsInFolder(folder)) { item in
                                flowCell(for: item).id(item.id)
                            }
                            //Text("共有 \(folder.tickets?.count ?? 0) 项").foregroundStyle(.secondary)
                        }
                    } header: {
                        if openedFolder == folder || openedFolder == nil {
                            HStack {
                                Button {
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        showAllTickets = false
                                        if openedFolder == folder {
                                            openedFolder = nil
                                        } else {
                                            openedFolder = folder
                                        }
                                    }
                                } label: { folderLabel(of: folder)
                                }
                            }.id(folder.id)
                        }
                    }// section other
                }//foreach folder
            }//endif not show all
            
        } // vgrid
    }
    
    @ViewBuilder func flowCell(for item: TicketItem) -> some View {
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
    UserDefaults.standard.set(2, forKey: "ViewMode")
    return ContentView()
        .modelContainer(container)
}
