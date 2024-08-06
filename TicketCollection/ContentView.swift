//
//  ContentView.swift
//  TicketCollection
//
//  Created by leo on 2023-11-12.
//

import SwiftUI
import SwiftData

@MainActor
struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: [SortDescriptor(\TicketItem.departTime)]) var tickets: [TicketItem]
    
    @State var showsEditor = false
    @State var showsDebug = false
    
    var body: some View {
        VStack {
            Button("Editor") {
                showsEditor = true
            }.buttonStyle(.borderedProminent).font(.title)
            Button("Add empty") {
                modelContext.insert(TicketItem())
                try! modelContext.save()
            }
            Button("debug") { showsDebug = true }
        }
        .padding()
        .fullScreenCover(isPresented: $showsEditor) {
            EditorView(ticketItem: tickets[0], trainDate: Date())
        }
        //.fullScreenCover(item: Binding<Identifiable?>, content: (Identifiable) -> View)
        // use navigation stack to show detail view
        .sheet(isPresented: $showsDebug) {
            DebugView()
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: TicketItem.self, configurations: config)
    
    for i in 1..<5 {
        let t = TicketItem()
        t.departTime = Date(timeIntervalSinceNow: TimeInterval(60 * i))
        container.mainContext.insert(t)
    }
    
    return ContentView()
        .modelContainer(container)
}
