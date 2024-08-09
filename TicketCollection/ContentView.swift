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
    @State var selectedTicket: TicketItem? = nil
    
    @Environment(\.colorScheme) var colorScheme
    
    @AppStorage("ViewMode") var viewMode: Int = 0
    let viewModeIcons: [String] = ["list.bullet", "circle.grid.2x2.fill", "square.stack"]
    
    @State var topBarHidden = false
    @State var filterOn = false
    @State var showsEditor = false
    @State var showsDebug = false
    
    @State var dragOffset: CGSize = .zero
    func translation2Degrees(_ x: CGFloat) -> Double {
        let w = Double(UIScreen.main.bounds.width)
        let dx = Double(x)
        return 45 * sin(.pi / 2 / w * dx)
    }
    
    @ViewBuilder func itemActions(for item: TicketItem) -> some View {
        Button {
            //
        } label: {
            Label("action", systemImage: "swift")
        }
        Button(role: .destructive) {
            withAnimation(.easeInOut) {
                modelContext.delete(item)
            }
        } label: {
            Label("Delete", systemImage: "trash.fill")
        }
    }
    
    var body: some View {
        ZStack {
            ScrollView(.vertical, showsIndicators: false) {
                switch viewMode {
                case 0: listView
                case 1: gridView
                case 2: flowView
                default: Spacer()
                }
            }.scrollDisabled(selectedTicket != nil)
            .zIndex(0)
            .padding()
            
            // controls
            VStack {
                topBar
                Spacer()
                
                HStack {
                    Button("Add empty") {
                        modelContext.insert(TicketItem())
                        try! modelContext.save()
                    }
                    Button("debug") { showsDebug = true }
                }.padding(.bottom, 30)
            }.zIndex(1)
            
            VStack {
                LinearGradient(
                    colors: [Color(UIColor.systemBackground), Color(UIColor.systemBackground), .clear],
                    startPoint: .top, endPoint: .bottom)
                .frame(height: 150)
                Spacer()
            }
            
            ticketPreview
        }
        .ignoresSafeArea()
        
        .fullScreenCover(isPresented: $showsEditor) {
            EditorView(ticketItem: selectedTicket!)
        }
        .sheet(isPresented: $showsDebug) {
            DebugView()
        }
    }
}

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
