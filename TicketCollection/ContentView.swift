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
    
    @ViewBuilder var flowView: some View {
        LazyVGrid(columns: [GridItem(.flexible())]) {
            Spacer(minLength: 100)
            ForEach(tickets) { item in
                GeometryReader { geo in
                    //let isSelected = selectedTicket == item
                    let y = Double(geo.frame(in: .global).minY)
                    return HStack {
                        Spacer()
                        TicketView(ticketInfo: item)
                            .scaleEffect(x: 0.8, y: 0.8)
                            .background(
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .fill(.black.opacity(exp(y / 400)))
                                    .scaleEffect(CGSize(width: 0.785, height: 0.80))
                                    .shadow(
                                        color: .black.opacity(0.5),
                                        radius: 3 + y / 400, y: -2 - y / 400
                                    )
                            )
                            .rotation3DEffect(
                                .degrees(-y / 16 - 20),
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
            Spacer(minLength: 120)
            ForEach(tickets) { item in
                HStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(Color(colorScheme == .dark ? UIColor.systemGray6 : UIColor.systemBackground))
                            .shadow(color: .black.opacity(0.5), radius: 3, y: 2)
                        HStack {
                            ZStack {
                                RoundedRectangle(cornerRadius: 4, style: .continuous)
                                    .fill(ticketColor)
                                    .frame(width: 87/2, height: 54/2)
                                VStack(spacing: 0) {
                                    Spacer()
                                    RoundedRectangle(cornerRadius: 3)
                                        .fill(Color(colorScheme == .dark ? UIColor.systemGray4 : UIColor.systemBackground))
                                        .shadow(color: .black.opacity(0.3), radius: 0, y: -1.2)
                                        .shadow(color: .black.opacity(0.2), radius: 3, y: 1)
                                        .frame(height: 14)
                                }
                            }.frame(width: 87/2+2.5, height: 54/2+1).padding(.trailing, 10)
                            Text(item.trainNumber).font(.title3).bold()
                            
                            Spacer()
                            
                            Text(defFormatter.string(from: item.departTime))
                                .multilineTextAlignment(.trailing)
                                .font(.system(size: 14))
                                .lineSpacing(-4)
                        }.padding(.horizontal)
                    } // zstack
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            selectedTicket = item
                        }
                    }
                    
                    Menu {
                        Button {
                            //
                        } label: {
                            Label("action", systemImage: "swift")
                        }
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
            Spacer(); Spacer(minLength: 70)
            ForEach(tickets) { item in
                GeometryReader { geo in
                    //let isSelected = selectedTicket == item
                    let y = Double(geo.frame(in: .global).minY)
                    let r = -max(0, 0.4 * (y - UIScreen.main.bounds.height + 300))
                    let s = max(0.001, min(1.0, 1 - 0.005 * (y - UIScreen.main.bounds.height + 200)))
                    return HStack {
                        Spacer()
                        TicketView(ticketInfo: item)
                            .scaleEffect(x: 0.4, y: 0.4)
                            .background(
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .fill(.black.opacity(0.9))
                                    .scaleEffect(CGSize(width: 0.39, height: 0.39))
                                    .shadow(
                                        color: .black.opacity(0.5), radius: 4, y: 4
                                    )
                            )
                            .rotation3DEffect(
                                .degrees(r),
                                axis: (x: 1, y: 0, z: 0),
                                perspective: 0.5
                            )
                            .scaleEffect(x: s, y: s)
                            .onTapGesture {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    selectedTicket = item
                                }
                            } // ticket view
                        Spacer()
                    } // hstack
                }.frame(width: 1000, height: 100)
                // geo reader
            } // foreach
        } // vgrid
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
                ZStack {
                    HStack {
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .fill(Color(UIColor.systemGray6))
                            .frame(maxWidth: topBarHidden ? 48 : .infinity)
                            .shadow(color: .black.opacity(0.5), radius: 4, y: 2)
                        if topBarHidden {
                            Spacer()
                        }
                    }
                    VStack(spacing: 0) {
                        HStack {
                            Button {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    topBarHidden.toggle()
                                    if topBarHidden { filterOn = false }
                                }
                            } label: {
                                Image(systemName: "chevron.left")
                                    .rotationEffect(.degrees(topBarHidden ? -180 : 0))
                            }.buttonStyle(RoundedBtnStyle(filled: false))
                                .tint(ticketColorDarker)
                            
                            if !topBarHidden {
                                Menu {
                                    Button {
                                        //
                                    } label: {
                                        Label("act", systemImage: "swift")
                                    }
                                } label: {
                                    Image(systemName: "gearshape")
                                }.buttonStyle(RoundedBtnStyle(filled: false))
                                    .tint(ticketColorDarker)
                            }
                                
                            Spacer()
                            if !topBarHidden {
                                Button {
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        filterOn.toggle()
                                    }
                                } label: {
                                    Image(systemName: "line.3.horizontal.decrease") //dot.scope
                                }.buttonStyle(RoundedBtnStyle(filled: filterOn))
                                    .tint(ticketColorDarker)
                                
                                Menu {
                                    Picker("View mode", selection: $viewMode) {
                                        Label("列表", systemImage: viewModeIcons[0]).tag(0)
                                        Label("网格", systemImage: viewModeIcons[1]).tag(1)
                                        Label("透视", systemImage: viewModeIcons[2]).tag(2)
                                    }
                                } label: {
                                    Image(systemName: viewModeIcons[viewMode])
                                }.buttonStyle(RoundedBtnStyle(filled: false))
                                    .tint(ticketColorDarker)
                            }
                        }.frame(height: 36).padding(6)
                        
                        if filterOn {
                            Spacer(minLength: 0)
                            Text("filter")
                            Spacer(minLength: 0)
                        }
                    }
                }
                .frame(height: filterOn ? 120 : 48).padding(.top, 60).padding(.horizontal, 30)
                
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
                            insertion: .opacity.combined(with: .move(edge: .top)),
                            removal: .opacity.combined(with: .scale(scale: 0.8)).combined(with: .ticketView)
                        )
                    )
                    .background(
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(.black.opacity(0.5))
                            .scaleEffect(CGSize(width: 0.985, height: 0.99))
                            .shadow(
                                color: .black.opacity(0.7),
                                radius: 3, y: 3
                            )
                    )
                    .zIndex(3)
                    
                VStack {
                    Spacer()
                    Button("Editor") {
                        showsEditor = true
                    }.buttonStyle(.borderedProminent).font(.title)
                }.transition(.move(edge: .bottom))
                .zIndex(4)
            }
        }
        .ignoresSafeArea()
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
