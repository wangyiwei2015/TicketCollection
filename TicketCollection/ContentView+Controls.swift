//
//  ContentView+Controls.swift
//  TicketCollection
//
//  Created by leo on 2024-08-09.
//

import SwiftUI

extension ContentView {
    @ViewBuilder var topBar: some View {
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
                                Label("关于TicketBox", systemImage: "info.circle")
                            }
                            Button {
                                //
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
                    }.padding()
                    Spacer(minLength: 0)
                }
            }
        }
        .frame(height: filterOn ? 100 : 48).padding(.top, 60).padding(.horizontal, 30)
    }
}
