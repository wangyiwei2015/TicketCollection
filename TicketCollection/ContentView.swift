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
    @Query(
        //filter: #Predicate<TicketItem> { ticket in },
        sort: [SortDescriptor(\TicketItem.departTime, order: .reverse)]
    ) var tickets: [TicketItem]
    @State var selectedTicket: TicketItem? = nil
    
    @Environment(\.colorScheme) var colorScheme
    
    @Namespace var namespace
    
    @AppStorage("ViewMode") var viewMode: Int = 2
    let viewModeIcons: [String] = ["list.bullet", "circle.grid.2x2.fill", "square.stack"]
    @AppStorage("BackgroundImage") var bgImgName: String = "nil"
    
    @State var topBarHidden = false
    @State var filterOn = false
    @State var showsEditor = false
    @State var showsDebug = false
    @State var showsDelWarning = false
    @State var itemToDelete: TicketItem? = nil
    @State var showsAbout = false
    @State var showsConfig = false
    
    let filterNames: [String] = ["已收藏","未出行","学生票","G","D","Z","T","K","C",]
    let filterImages: [String] = ["star","calendar.badge.clock","tag",]
    @State var filters: [Bool] = Array(repeating: false, count: 9)
    
    @State var dragOffset: CGSize = .zero
    func translation2Degrees(_ x: CGFloat) -> Double {
        let w = Double(UIScreen.main.bounds.width)
        let dx = Double(x)
        return 45 * sin(.pi / 2 / w * dx)
    }
    
    @ViewBuilder func itemActions(for item: TicketItem) -> some View {
        Button {
            selectedTicket = item
            showsEditor = true
        } label: {
            Label("编辑", systemImage: "square.and.pencil")
        }
        Button {
            item.starred.toggle()
            Task { try! modelContext.save() }
        } label: {
            Label(item.starred ? "取消收藏" : "收藏", systemImage: item.starred ? "star.slash" : "star")
        }

        ShareLink("分享", item: TicketView(ticketInfo: item).render())
        Button(role: .destructive) {
            itemToDelete = item
            showsDelWarning = true
        } label: {
            Label("删除设计", systemImage: "trash.fill")
        }
    }
    
    var body: some View {
        ZStack {
            Group {
                Spacer().overlay {
                    Image(bgImgName).resizable().scaledToFill()
                        .opacity(0.5)
                }.ignoresSafeArea()
            }.zIndex(0)
            
            ScrollView(.vertical, showsIndicators: false) {
                switch viewMode {
                case 0: listView
                case 1: gridView
                case 2: flowView
                default: Spacer()
                }
            }.scrollDisabled(selectedTicket != nil)
            .blur(radius: selectedTicket == nil ? 0 : 5)
            .zIndex(0)
            .padding()
            
            // controls
            VStack {
                topBar
                Spacer()
                if filteredTickets.isEmpty {
                    Text("无符合条件的车票").font(.title2).foregroundStyle(.gray)
                }
                Spacer()
                if tickets.isEmpty {
                    ZStack {
                        RoundedRectangle(cornerRadius: 22).fill(ticketColor)
                            .frame(width: 188, height: 68)
                        Rectangle().fill(ticketColor)
                            .frame(width: 38, height: 38)
                            .rotationEffect(.degrees(45))
                            .offset(y: 30)
                        RoundedRectangle(cornerRadius: 20).fill(ticketColorDarker)
                            .frame(width: 180, height: 60)
                        Rectangle().fill(ticketColorDarker)
                            .frame(width: 30, height: 30)
                            .rotationEffect(.degrees(45))
                            .offset(y: 30)
                        Text("点击此处开始").font(.title3).bold()
                            .foregroundStyle(.white)
                    }.offset(y: -25)
                        .transition(.opacity.combined(with: .scale(0.8, anchor: .bottom)))
                }
                
                HStack {
                    Button {
                        let newItem = TicketItem()
                        modelContext.insert(newItem)
                        try! modelContext.save()
                        withAnimation(.easeInOut(duration: 0.3)) {
                            selectedTicket = newItem
                            showsEditor = true
                        }
                    } label: {
                        ZStack {
                            Circle().fill(
                                ticketColorDarker
                                    .shadow(.inner(color: .white.opacity(0.3), radius: 4, y: 4))
                                ).shadow(color: .black.opacity(0.5), radius: 3, y: 3)
                            Image(systemName: "plus")
                                .font(.system(size: 30, weight: .semibold)).tint(ticketColor)
                        }.frame(height: 60).aspectRatio(1, contentMode: .fit)
                    }
                    //Button("debug") { showsDebug = true }
                }.padding(.bottom, 20)
            }.blur(radius: selectedTicket == nil && !showsAbout && !showsConfig ? 0 : 5)
            .zIndex(1)
            
            VStack {
                LinearGradient(
                    colors: [Color(UIColor.systemBackground), Color(UIColor.systemBackground), .clear],
                    startPoint: .top, endPoint: .bottom)
                .frame(height: 150)
                Spacer()
            }
            
            ticketPreview
            
            if showsAbout {
                overlayGradient.onTapGesture {
                    withAnimation(.easeOut(duration: 0.3)) {
                        showsAbout = false
                    }
                }.zIndex(10)
                ZStack {
                    RoundedRectangle(cornerRadius: 20).fill(Color(UIColor.systemBackground))
                    VStack {
                        HStack {
                            Group {
                                Image(systemName: "info.circle.fill").foregroundStyle(.gray)
                                Text("关于TicketBox").foregroundStyle(ticketColorDarker)
                            }.font(.title2).bold()
                            Spacer()
                            Button {
                                withAnimation(.easeOut(duration: 0.3)) {
                                    showsAbout = false
                                }
                            } label: {Image(systemName: "xmark")
                            }.buttonStyle(TCButtonStyle(filled: false))
                                .frame(width: 50, height: 40)
                        }.padding()
                        ScrollView(.vertical) {
                            Text("V\(ver) (\(build))")
                        }
                    }
                }.padding(.horizontal)
                .padding(.vertical, 148)
                .transition(.asymmetric(
                    insertion: .opacity.combined(with: .scale(scale: 0.6).combined(with: .offset(y: -60))),
                    removal: .opacity.combined(with: .scale(scale: 0.6).combined(with: .move(edge: .bottom)))
                ))
                .zIndex(11)
            }
            
            if showsConfig {
                overlayGradient.onTapGesture {
                    withAnimation(.easeOut(duration: 0.3)) {
                        showsConfig = false
                    }
                }.zIndex(10)
                ZStack {
                    RoundedRectangle(cornerRadius: 20).fill(Color(UIColor.systemBackground))
                    VStack {
                        HStack {
                            Group {
                                Image(systemName: "gearshape.fill").foregroundStyle(.gray)
                                Text("应用偏好设置").foregroundStyle(ticketColorDarker)
                            }.font(.title2).bold()
                            Spacer()
                            Button {
                                withAnimation(.easeOut(duration: 0.3)) {
                                    showsConfig = false
                                }
                            } label: {Image(systemName: "xmark")
                            }.buttonStyle(TCButtonStyle(filled: false))
                                .frame(width: 50, height: 40)
                        }.padding()
                        ScrollView(.vertical) {
                            Text("主页背景图片")
                            Picker(selection: $bgImgName) {
                                Text("空白").tag("nil")
                                Text("皮革纹理").tag("bgp")
                                Text("牛皮纸纹理").tag("bgn")
                            } label: {
                                Label("background", systemImage: "swift")
                            }
                        }
                    }
                }.padding(.horizontal)
                .padding(.vertical, 80)
                .transition(.asymmetric(
                    insertion: .opacity.combined(with: .scale(scale: 0.6).combined(with: .offset(y: -60))),
                    removal: .opacity.combined(with: .scale(scale: 0.6).combined(with: .move(edge: .bottom)))
                ))
                .zIndex(11)
            }
        }
        .ignoresSafeArea()
        
        .alert("删除确认", isPresented: $showsDelWarning, actions: {
            Button("取消", role: .cancel) { itemToDelete = nil }
            Button("删除此车票", role: .destructive) {
                withAnimation(.easeInOut) {
                    modelContext.delete(itemToDelete!)
                    itemToDelete = nil
                    selectedTicket = nil
                }
            }
        }, message: {
            Text("即将删除这张\(itemToDelete?.trainNumber ?? "nil")的车票，删除后无法恢复。")
        })
        
        .fullScreenCover(isPresented: $showsEditor) {
            EditorView(ticketItem: selectedTicket!)
        }
        .sheet(isPresented: $showsDebug) {
            DebugView()
        }
        
        #if DEBUG
        //.onAppear { selectedTicket = tickets.first }
        #endif
    }
    
    let ver = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String? ?? "0"
    let build = Bundle.main.infoDictionary!["CFBundleVersion"] as! String? ?? "0"
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: TicketItem.self, configurations: config)
    
    for i in 1...3 {
        let t = TicketItem()
        t.departTime = Date(timeIntervalSinceNow: TimeInterval(3303 * i))
        container.mainContext.insert(t)
    }
    
    return ContentView()
        .modelContainer(container)
}
