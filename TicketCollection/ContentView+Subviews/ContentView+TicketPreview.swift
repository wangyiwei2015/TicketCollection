//
//  ContentView+TicketPreview.swift
//  TicketCollection
//
//  Created by leo on 2024-08-09.
//

import SwiftUI

extension ContentView {
    @ViewBuilder var ticketPreview: some View {
        // selected
        if let selection = selectedTicket {
            overlayGradient
            .ignoresSafeArea()
            .onTapGesture {
                withAnimation(.easeInOut(duration: 0.3)) {
                    selectedTicket = nil
                }
            }.zIndex(2)
            
            TicketView(ticketInfo: selection)
                .id(selection)//.transition(
            //    .asymmetric(
            //        insertion: .opacity.combined(with: .move(edge: .leading)).combined(with: .ticketView),
            //        removal: .opacity.combined(with: .scale(scale: 0.8)).combined(with: .ticketView)
            //    )
            //)
                .matchedGeometryEffect(id: "ticket", in: namespace, properties: .frame)
                .overlay(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(Color(white: 0.48 - translation2Degrees(dragOffset.width) / 100, opacity: translation2Degrees(dragOffset.width) / 100))
                        .shadow(
                            color: Color(white: 0.48 - translation2Degrees(dragOffset.width) / 100, opacity: translation2Degrees(dragOffset.width) / 100),
                            radius: 4, y: 0
                        )
                )
                .gesture(
                    DragGesture(minimumDistance: 20)
                        .onChanged { value in
                            dragOffset = value.translation
                        }
                        .onEnded { value in
                            withAnimation(.interpolatingSpring) {
                                dragOffset = .zero
                            }
                        }
                )
                .rotation3DEffect(
                    .degrees(translation2Degrees(dragOffset.width)),
                    axis: (x: 0.0, y: 1.0, z: 0.0),
                    perspective: 0.4
                )
                .zIndex(4)
            
            if previewAddingFolder {
                previewAddFolderMenu.ignoresSafeArea().zIndex(99)
            }
        }
        
        if let showingTicket = selectedTicket {
            VStack {
                Spacer()
                
                HStack {
//                    Button {
//                        showsEditor = true
//                    } label: {
//                        Label("编辑车票", systemImage: "square.and.pencil")
//                    }.buttonStyle(TCButtonStyle(filled: false, height: 48))
//                        .frame(width: 130)
//                        .transition(.offset(x: 50, y: 150))
//                    Spacer()
//                    Button {
//                        itemToDelete = showingTicket
//                        showsDelWarning = true
//                    } label: {
//                        Label("删除设计", systemImage: "trash")
//                    }.buttonStyle(TCButtonStyle(filled: false, height: 48, tint: .red))
//                        .frame(width: 130)
                    Button {
                        showsEditor = true
                    } label: {
                        Image(systemName: "square.and.pencil")
                    }.buttonStyle(TCButtonStyle(filled: true, height: 48))
                    .frame(width: 80)
                    Spacer()
                    
                    Group {
                        if v1ProAccess {
                            Button {
                                dismissKeyboard()
                                withAnimation(.spring(duration: 0.4, bounce: 0.5)) {
                                    previewAddingFolder = true
                                }
                            } label: {
                                Image(systemName: "wallet.bifold")
                            }.buttonStyle(TCButtonStyle(
                                filled: selectedTicket?.inFolder != nil, height: 48
                            ))
                        } else { Spacer() }
                    }.frame(width: 80)
                    .overlay {
                        Button {
                            itemToDelete = showingTicket
                            showsDelWarning = true
                        } label: {
                            Image(systemName: "trash")
                        }.buttonStyle(TCButtonStyle(filled: false, height: 48, tint: .red))
                            .frame(width: 80).offset(y: v1ProAccess ? -88 : -30)
                    }
                    
                    Spacer()
                    Button {
                        withAnimation(.linear(duration: 0.2)) {
                            showingTicket.starred.toggle()
                            Task { try! modelContext.save() }
                        }
                    } label: {
                        Image(systemName: showingTicket.starred ? "star.fill" : "star.slash")
                    }.buttonStyle(TCButtonStyle(
                        filled: showingTicket.starred, height: 48, tint: showingTicket.starred ? .yellow : ticketColorDarker
                    ))
                    .frame(width: 80)
                    
                }.padding(.horizontal, 40)
                
                Spacer().frame(height: 300)
                
                HStack {
                    Button {
                        if let t =  selectedTicket {
                            if let img = TicketView(ticketInfo: t).makeImage() {
                                UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil)
                                saved = true
                            }
                        }
                    } label: {
                        Label(
                            saved ? "" : "保存图像",
                            systemImage: saved ? "checkmark" : "tray.and.arrow.down.fill"
                        )
                    }.buttonStyle(TCButtonStyle(filled: !saved, height: 48))
                        .frame(width: 130).disabled(saved)
                    
                    if v1ProAccess {
                        Spacer()
                        ShareLink(
                            "导出PDF", item: TransferableTicketPDF(selectedTicket ?? .init()),
                            preview: exportPreview
                        ).buttonStyle(TCButtonStyle(filled: true, height: 48)).frame(width: 130)
                    } //else {
//                        Spacer()
//                        Label("导出PDF", systemImage: "lock.fill").bold()
//                            .foregroundStyle(.white).opacity(0.6).frame(width: 130)
//                    }
                }.padding(.horizontal, 40)
                Spacer()
            }.zIndex(3)
        } // end if
    }
    
    @ViewBuilder var previewAddFolderMenuBg: some View {
        RoundedRectangle(cornerRadius: 22).fill(Color(UIColor.systemGray5))
            .frame(width: 268, height: 208)
        Rectangle().fill(Color(UIColor.systemGray5))
            .frame(width: 38, height: 38)
            .rotationEffect(.degrees(45))
            .offset(y: -100)
        RoundedRectangle(cornerRadius: 20).fill(Color(UIColor.systemGray6))
            .frame(width: 260, height: 200)
        Rectangle().fill(Color(UIColor.systemGray6))
            .frame(width: 30, height: 30)
            .rotationEffect(.degrees(45))
            .offset(y: -100)
    }
    
    @ViewBuilder var previewAddFolderMenu: some View {
        ZStack {
            previewAddFolderMenuBg
            if allFolders.isEmpty {
                VStack(spacing: 10) {
                    Image(systemName: "viewfinder.rectangular")
                        .font(.title2).bold()
                    Text("没有文件夹").font(.title3)
                }.foregroundStyle(.gray)
            } else {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 10) {
                        Button {
                            selectedTicket?.inFolder = nil
                            try! modelContext.save()
                            withAnimation(.easeOut(duration: 0.2)) {
                                previewAddingFolder = false
                            }
                        } label: {
                            Label("从文件夹移出", systemImage: "circle.slash")
                                .bold().foregroundStyle(.gray).padding(.vertical, 8)
                        }
                        ForEach(allFolders) { folderItem in
                            Button(folderItem.name) {
                                selectedTicket?.inFolder = folderItem
                                try! modelContext.save()
                                withAnimation(.easeOut(duration: 0.2)) {
                                    previewAddingFolder = false
                                }
                            }.buttonStyle(TCButtonStyle(filled: selectedTicket?.inFolder == folderItem))
                        }
                        
                    }.padding(.vertical, 10).padding(.horizontal, 4)
                }.padding(.vertical, 8).frame(width: 240, height: 208)
            }
        }
        .transition(.scale(scale: 0.8).combined(with: .opacity).combined(with: .offset(y: -40)))
        .padding(.bottom)
        .background {
            Rectangle().fill(EllipticalGradient(
                colors: [.black.opacity(0.6), .clear],
                startRadiusFraction: 0.0, endRadiusFraction: 0.3
            ))
            .frame(width: UIScreen.main.bounds.height * 2, height: UIScreen.main.bounds.height * 2)
            .onTapGesture {
                withAnimation(.easeOut(duration: 0.2)) {
                    previewAddingFolder = false
                }
            }
        }
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
    let ts = TicketItem()
    let fs = TicketFolder(name: "folder")
    ts.inFolder = fs
    container.mainContext.insert(ts)
    
    return ContentView(selectedTicket: ts)
        .modelContainer(container)
}
