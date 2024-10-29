//
//  ContentView+Controls.swift
//  TicketCollection
//
//  Created by leo on 2024-08-09.
//

import SwiftUI
import SwiftData

extension ContentView {
    @ViewBuilder var topBar: some View {
        ZStack {
            
            //search bar
            Group {
                Capsule().fill(Color(UIColor.systemGray5))
                    .strokeBorder(searchEmpty ? .clear : ticketColor, lineWidth: 4)
                    .stroke(Color(UIColor.systemBackground), lineWidth: 2)
                TextField("SearchTerm", text: $searchTerm, prompt: Text("搜索"))
                    .textFieldStyle(.plain).submitLabel(.search)
                    .scrollDismissesKeyboard(.never)
                    .multilineTextAlignment(searchEmpty ? .center : .leading)
                    .font(.system(size: 22))
                    .foregroundStyle(searchEmpty ? .gray : ticketColorDarker)
                    .padding(.horizontal)
                    .onSubmit {
                        withAnimation(.linear(duration: 0.2)) {
                            appliedSearchTerm = searchTerm
                        }
                    }
                    .onChange(of: searchTerm) {
                        withAnimation(.easeOut(duration: 0.2)) {
                            searchEmpty = searchTerm == ""
                        }
                    }
            }
            .frame(height: 40).padding(.horizontal, 70)
            .scaleEffect(x: topBarHidden ? 1.0 : 0.3, y: topBarHidden ? 1.0 : 0.3)
            
            HStack {
                Spacer()
                Button {
                    withAnimation(.linear(duration: 0.2)) {
                        appliedSearchTerm = ""
                        searchTerm = ""
                    }
                } label: {
                    Image(systemName: "xmark")
                }.buttonStyle(RoundedBtnStyle(filled: true))
                .tint(.gray).frame(width: 32, height: 32)
                .scaleEffect(searchEmpty || !topBarHidden ? 0.3 : 1.0, anchor: .leading)
                .opacity(searchEmpty || !topBarHidden ? 0 : 1)
                .padding(.trailing, 28)
            }
            
            //BG
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
                //top buttons
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
                                withAnimation(.spring(duration: 0.3, bounce: 0.4)) {
                                    showsAbout = true
                                }
                            } label: {
                                Label("关于TicketBox", systemImage: "info.circle")
                            }
                            Button {
                                withAnimation(.spring(duration: 0.3, bounce: 0.4)) {
                                    showsConfig = true
                                }
                            } label: {
                                Label("偏好设置", systemImage: "gearshape")
                            }
                        } label: {
                            Image(systemName: "gearshape")
                        }.buttonStyle(RoundedBtnStyle(filled: false))
                            .tint(ticketColorDarker)
                    }
                    Spacer()
                    
                    if !topBarHidden {
                        Text("\(filteredTickets.count != tickets.count ? "\(filteredTickets.count)/" : "")\(tickets.count)张车票").font(.system(size: 18, weight: .semibold, design: .monospaced))
                            .foregroundStyle(.gray)
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
                            .overlay {
                                Circle().fill(ticketColor).frame(width: 10, height: 10)
                                    .offset(x: 14, y: -14)
                                    .opacity(filters.contains(where: {$0}) ? 1 : 0)
                            }
                        
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
                    VStack {
                        HStack {
                            ForEach(0...2, id:\.self) { index in
                                Button {
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        filters[index].toggle()
                                    }
                                } label: {
                                    Label(filterNames[index], systemImage: filterImages[index])
                                }.buttonStyle(TCButtonStyle(filled: filters[index]))
                            }
                        }
                        HStack {
                            ForEach(3...8, id:\.self) { index in
                                Button(filterNames[index]) {
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        filters[index].toggle()
                                    }
                                }.buttonStyle(TCButtonStyle(filled: filters[index]))
                            }
                        }
                    }.padding(10).padding(.bottom, 10)
                    Spacer(minLength: 0)
                }
            }
        }
        .frame(height: filterOn ? 160 : 48).padding(.top, 60).padding(.horizontal, 30)
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: TicketItem.self, configurations: config)
    
    for i in 1...3 {
        let t = TicketItem()
        t.departTime = Date(timeIntervalSinceNow: TimeInterval(60 * i))
        container.mainContext.insert(t)
    }
    
    return ContentView()
        .modelContainer(container)
}
