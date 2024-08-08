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
    
    @AppStorage("ViewMode") var viewMode: Int = 0
    
    @State var showsEditor = false
    @State var showsDebug = false
    
    var body: some View {
        VStack {
            Picker("View mode", selection: $viewMode) {
                Label("List", systemImage: "swift").tag(0)
                Label("Grid", systemImage: "swift").tag(1)
                Label("Flow", systemImage: "swift").tag(2)
            }.tint(ticketColorDarker)
            
            ScrollView(.vertical, showsIndicators: false) {
                LazyVGrid(columns: [GridItem(.flexible())]) {
                    Spacer(minLength: selectedTicket == nil ? 10 : 30)
                    ForEach(tickets) { item in
                        if selectedTicket == item || selectedTicket == nil {
                            GeometryReader { geo in
                                let isSelected = selectedTicket == item
                                let y = Double(geo.frame(in: .global).minY)
                                return HStack {
                                    Spacer()
                                    TicketView(ticketInfo: item)
                                        .scaleEffect(x: isSelected ? 0.9 : 0.8, y: isSelected ? 0.9 : 0.8)
                                        .background(
                                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                                .fill(.black.opacity(exp(y / 400)))
                                                .scaleEffect(
                                                    isSelected
                                                    ? CGSize(width: 0.885, height: 0.9)
                                                    : CGSize(width: 0.785, height: 0.80))
                                                .shadow(
                                                    color: .black.opacity(0.5),
                                                    radius: 4, y: isSelected ? 2 : -3
                                                )
                                        )
                                        .rotation3DEffect(
                                            .degrees(isSelected ? 0 : -y / 8),
                                            axis: (x: 1, y: 0, z: 0),
                                            perspective: 0.6
                                        )
                                        //.transition(.move(edge: .bottom))
                                        .onTapGesture {
                                            withAnimation(.easeInOut(duration: 0.3)) {
                                                selectedTicket = item
                                            }
                                        } // ticket view
                                    Spacer()
                                } // hstack
                            }.frame(height: 64)
                            // geo reader
                        } // if enable
                    } // foreach
                } // vgrid
            }.scrollDisabled(selectedTicket != nil)
            
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
        .background(
            Color(UIColor.systemBackground).ignoresSafeArea()
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        selectedTicket = nil
                    }
                }
        )
        .navigationTitle("Title").navigationBarTitleDisplayMode(.large)
        
        .fullScreenCover(isPresented: $showsEditor) {
            EditorView(ticketItem: selectedTicket!)
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
    
    for i in 1...15 {
        let t = TicketItem()
        t.departTime = Date(timeIntervalSinceNow: TimeInterval(60 * i))
        container.mainContext.insert(t)
    }
    
    return ContentView()
        .modelContainer(container)
}
