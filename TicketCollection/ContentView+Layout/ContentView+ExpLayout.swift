//
//  ContentView+ExpLayout.swift
//  TicketCollection
//
//  Created by leo on 2025.04.07.
//

import SwiftUI

extension ContentView {
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
    UserDefaults.standard.set(3, forKey: "ViewMode")
    return ContentView()
        .modelContainer(container)
}
