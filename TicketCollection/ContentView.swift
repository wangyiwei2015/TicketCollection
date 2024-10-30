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
    // - MARK: SwiftData的数据库
    @Environment(\.modelContext) var modelContext
    @Query(
        //filter: #Predicate<TicketItem> { ticket in },
        sort: [SortDescriptor(\TicketItem.departTime, order: .reverse)]
    ) var tickets: [TicketItem]
    @Query(
        sort: [SortDescriptor(\TicketFolder.name)]
    ) var allFolders: [TicketFolder]
    
    // - MARK: 颜色与显示模式
    @Environment(\.colorScheme) var colorScheme
    let ticketColorAuto = Color(light: ticketColorDarker, dark: ticketColor)
    
    // - MARK: 命名空间为了Geometry匹配动画
    @Namespace var namespace

    // - MARK: 持久化设置数据
    @AppStorage("ViewMode") var viewMode: Int = 2
    @AppStorage("BackgroundImage") var bgImgName: String = "nil"
    
    // - MARK: 样式相关常量
    let viewModeIcons: [String] = ["list.bullet", "circle.grid.2x2.fill", "square.stack", "scroll"]
    let filterNames: [String] = ["已收藏","未出行","学生票","G","D","Z","T","K","C",]
    let filterImages: [String] = ["star","calendar.badge.clock","tag",]
    let colorForBG: [String : Color] = [
        "bgn": Color(red: 222/244, green: 200/244, blue: 156/255),
        "bgp": .systemBackground,
        "bgw": Color(light: .init(red: 113/255, green: 78/255, blue: 50/255), dark: .init(white: 0.05)),
        "bgr": Color(red: 182/244, green: 142/244, blue: 112/255),
    ]

    // - MARK: 状态：Ticket列表信息
    @State var selectedTicket: TicketItem? = nil
    @State var itemToDelete: TicketItem? = nil
    @State var filters: [Bool] = Array(repeating: false, count: 9)
//    typealias FolderRecord = [String : String]
//    @State var folders: FolderRecord = defaults.dictionary(
//        forKey: "TicketFolders"
//    ) as? FolderRecord ?? [:] {
//        willSet { defaults.set(newValue, forKey: "TicketFolders") }
//    }
//    @State var selectedFolder: UUID? = nil
    @State var openedFolder: TicketFolder? = nil
    @State var showAllTickets = false
    
    // - MARK: UI界面状态
    @State var topBarHidden = true
    @State var filterOn = false
    @State var showsEditor = false
    @State var showsDebug = false
    @State var showsDelWarning = false
    @State var showsAbout = false
    @State var showsConfig = false
    @State var showsAddMenu = false
    @State var showsFolderView = false
    
    // - MARK: 输入状态
    @State var searchTerm: String = ""
    @State var searchEmpty: Bool = true
    @State var appliedSearchTerm: String = ""
    @State var newFolderNameEntry: String = ""
    
    // - MARK: 拖动手势状态
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

        ShareLink("分享", item: TransferableTicket(item), preview: exportPreview)
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
                        .opacity(0.8)
                }.ignoresSafeArea()
            }.zIndex(0)
            
            ScrollView(.vertical, showsIndicators: false) {
                switch viewMode {
                case 0: listView
                case 1: gridView
                case 2: flowView
                case 3: experimentalLayout
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
                if filteredTickets.isEmpty && !showsAddMenu {
                    Text("无符合条件的车票").font(.title2).foregroundStyle(.gray)
                }
                Spacer()
                if showsAddMenu {
                    addMenu2
                } else if tickets.isEmpty {
                    emptyTipView.offset(y: -25)
                    .transition(.opacity.combined(with: .scale(0.8, anchor: .bottom)))
                }
                
                HStack {
                    Button {
                        withAnimation(.spring(duration: 0.4, bounce: 0.5)) {
                            showsAddMenu.toggle()
                        }
                    } label: {
                        ZStack {
                            Circle().fill(
                                ticketColorDarker
                                    .shadow(.inner(color: .white.opacity(0.3), radius: 4, y: 4))
                                    .shadow(.inner(color: .black.opacity(0.3), radius: 4, y: -4))
                            ).shadow(color: .black.opacity(showsAddMenu ? 0.1 : 0.5), radius: 3, y: 3)
                            Image(systemName: "plus")
                                .font(.system(size: 30, weight: .semibold)).foregroundStyle(ticketColor)
                                .rotationEffect(showsAddMenu ? .degrees(135) : .zero)
                        }.frame(height: 60).aspectRatio(1, contentMode: .fit)
                    }.buttonStyle(MinimalistButtonStyle())
                    .scaleEffect(showsAddMenu ? 0.8 : 1.0)
                    //Button("debug") { showsDebug = true }
                }.padding(.bottom, 20)
            }.blur(radius: selectedTicket == nil && !showsAbout && !showsConfig ? 0 : 5)
            .zIndex(1)
            
            VStack {
                LinearGradient(
                    colors: [
                        colorForBG[bgImgName] ?? Color.systemBackground,
                        colorForBG[bgImgName] ?? Color.systemBackground,
                        .clear
                    ],
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
                    RoundedRectangle(cornerRadius: 20).fill(Color.systemBackground)
                    aboutView
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
                    RoundedRectangle(cornerRadius: 20).fill(Color.systemBackground)
                    configView
                }.padding(.horizontal)
                .padding(.vertical, 80)
                .transition(.asymmetric(
                    insertion: .opacity.combined(with: .scale(scale: 0.6).combined(with: .offset(y: -60))),
                    removal: .opacity.combined(with: .scale(scale: 0.6).combined(with: .move(edge: .bottom)))
                ))
                .zIndex(11)
            }
            
            if showsFolderView {
                overlayGradient.onTapGesture {
                    withAnimation(.easeOut(duration: 0.3)) {
                        showsFolderView = false
                    }
                }.zIndex(10)
                ZStack {
                    RoundedRectangle(cornerRadius: 20).fill(Color.systemBackground)
                    folderView
                }.padding(.horizontal)
                    .padding(.vertical, 148)
                    .transition(.asymmetric(
                        insertion: .opacity.combined(with: .scale(scale: 0.6).combined(with: .offset(y: -60))),
                        removal: .opacity.combined(with: .scale(scale: 0.6).combined(with: .move(edge: .bottom)))
                    ))
                    .zIndex(11)
            }
            
            //end of overlays
        }
        .ignoresSafeArea()
        
        .alert("删除确认", isPresented: $showsDelWarning, actions: {
            Button("取消", role: .cancel) { itemToDelete = nil }
            Button("删除此车票", role: .destructive) {
                withAnimation(.easeInOut(duration: 0.3)) {
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
    }
    
    let ver = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String? ?? "0"
    let build = Bundle.main.infoDictionary!["CFBundleVersion"] as! String? ?? "0"
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: TicketItem.self, configurations: config)
    
    for i in 1...153 {
        let t = TicketItem()
        t.departTime = Date(timeIntervalSinceNow: TimeInterval(3303 * i))
        container.mainContext.insert(t)
    }
    
    return ContentView()
        .modelContainer(container)
}
