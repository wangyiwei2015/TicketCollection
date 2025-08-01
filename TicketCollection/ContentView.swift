//
//  ContentView.swift
//  TicketCollection
//
//  Created by leo on 2023-11-12.
//

import SwiftUI
import SwiftData
import RevenueCat
//import Reachability

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
    
    // - MARK: 命名空间为了Geometry匹配动画 Fucking shit buggy
    @Namespace var namespace

    // - MARK: 持久化设置数据
    @AppStorage("ViewMode") var viewMode: Int = 1
    @AppStorage("BackgroundImage") var bgImgName: String = "nil"
    @AppStorage("ExtendedOptions") var extEnabled = false
    @AppStorage("V1ProAcess") var v1ProAccess = false
    @AppStorage("SubActive") var subscribingIAP = false
    
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
    let bgImgNameShown: [String : String] = [
        "nil": "空白", "bgp": "皮革", "bgn": "牛皮纸", "bgw": "木纹", "bgr": "软木板",
    ]

    // - MARK: 状态：Ticket列表信息
    @State var selectedTicket: TicketItem? = nil {
        willSet { if newValue == nil { saved = false } }
    }
    @State var itemToDelete: TicketItem? = nil
    @State var filters: [Bool] = Array(repeating: false, count: 9)
    @State var folderToDelete: TicketFolder? = nil
    @State var openedFolder: TicketFolder? = nil
    @State var showAllTickets = true
    
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
    @State var showsFonts = false
    @State var previewAddingFolder = false
    @State var alertFolderDel = false
    @State var saved = false // image saved
    @Environment(\.openURL) var openURL
    @State var showsIAP = false
    @State var paywallShown = false
    @State var selectedIAP: Int = -1
    
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
        if v1ProAccess {
            ShareLink("分享", item: TransferableTicket(item, .pdf), preview: exportPreview)
        }
        Button(role: .destructive) {
            itemToDelete = item
            showsDelWarning = true
        } label: {
            Label("删除设计", systemImage: "trash.fill")
        }
    }
    
    let bg = RoundedRectangle(cornerRadius: 14).fill(Color(uiColor: .systemGray6))
    
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
                case 3: experimentalLayout // for fucking debug
                default: Spacer()
                }
                Color.clear.frame(height: 80)
            }.scrollDisabled(selectedTicket != nil)
            .blur(radius: selectedTicket == nil ? 0 : 5)
            .zIndex(0).padding()
            
            mianControls.zIndex(1)
            topGradient
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
                    } completion: {
                        showsIAP = false
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
        }.ignoresSafeArea()
        
        .onAppear {
            Task {
                do {
                    let info = try await Purchases.shared.customerInfo()
                    let activePurchases = info.entitlements.active
                    // V1 behavior: any purchase unlocks everything
                    v1ProAccess = !activePurchases.isEmpty
                    subscribingIAP = !info.activeSubscriptions.isEmpty
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        
        .sensoryFeedback(.alignment, trigger: viewMode)
        .sensoryFeedback(.selection, trigger: selectedTicket) { $1 != nil }
        .sensoryFeedback(.success, trigger: v1ProAccess) { $1 }
        .sensoryFeedback(.start, trigger: showsEditor) { $1 }
        .sensoryFeedback(.impact, trigger: showsConfig) { $1 }
        .sensoryFeedback(.impact, trigger: showsAbout) { $1 }
        .sensoryFeedback(.impact, trigger: showsAddMenu) { $1 }
        .sensoryFeedback(.success, trigger: saved) { $1 }
        
        .alert("删除确认", isPresented: $showsDelWarning, actions: {
            Button("取消", role: .cancel) { itemToDelete = nil }
            Button("删除此车票", role: .destructive) {
                withAnimation(.easeInOut(duration: 0.3)) {
                    modelContext.delete(itemToDelete!)
                    Task { try! modelContext.save() }
                    itemToDelete = nil
                    selectedTicket = nil
                }
            }
        }, message: {
            Text("即将删除这张\(itemToDelete?.trainNumber ?? "nil")的车票，删除后无法恢复。")
        })
        
        .alert("删除确认", isPresented: $alertFolderDel, actions: {
            Button("取消", role: .cancel) { folderToDelete = nil }
            Button("删除文件夹", role: .destructive) {
                withAnimation(.easeInOut(duration: 0.3)) {
                    modelContext.delete(folderToDelete!)
                    Task { try! modelContext.save() }
                    folderToDelete = nil
                    openedFolder = nil
                }
            }
        }, message: {
            Text("即将删除文件夹\(folderToDelete?.name ?? "nil")，删除后无法恢复。")
        })
        
        .sheet(isPresented: $showsFonts) { FontLoaderView() }
        
        .fullScreenCover(isPresented: $showsEditor) {
            EditorView(ticketItem: selectedTicket!, allFolders: allFolders, extEnabled: extEnabled)
//            EditorView(
//                ticketItemID: selectedTicket!.id, in: modelContext.container,
//                allFolders: allFolders, extEnabled: extEnabled
//            )
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
    
    for i in 1...15 {
        let t = TicketItem()
        t.departTime = Date(timeIntervalSinceNow: TimeInterval(3303 * i))
        container.mainContext.insert(t)
    }
    
    return ContentView()
        .modelContainer(container)
}
