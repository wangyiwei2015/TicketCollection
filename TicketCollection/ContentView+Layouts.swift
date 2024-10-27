//
//  ContentView+Layouts.swift
//  TicketCollection
//
//  Created by leo on 2024-08-09.
//

import SwiftUI

extension ContentView {
    
    @ViewBuilder var flowView: some View {
        LazyVGrid(columns: [GridItem(.flexible())]) {
            Spacer(minLength: filterOn ? 150 : 100)
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
                                    .opacity(selectedTicket == item ? 0 : 1)
                            )
                            .matchedGeometryEffect(id: selectedTicket == item ? "ticket" : "", in: namespace, properties: .frame, isSource: false)
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
            Spacer(minLength: filterOn ? 200 : 120)
            ForEach(tickets) { item in
                HStack {
                    Button {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            selectedTicket = item
                        }
                    } label: {
                        HStack {
                            ZStack {
                                RoundedRectangle(cornerRadius: 4, style: .continuous)
                                    .fill(ticketColor)
                                    .frame(width: 87/2, height: 54/2)
                                    .matchedGeometryEffect(id: selectedTicket == item ? "ticket" : "", in: namespace, properties: .frame, isSource: false)
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
                    }.buttonStyle(ListItemBtnStyle(colorScheme: colorScheme))
                    
                    Menu {
                        itemActions(for: item)
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
            Spacer(); Spacer(minLength: filterOn ? 110 : 70)
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
                                    .opacity(selectedTicket == item ? 0 : 1)
                            )
                            .matchedGeometryEffect(id: selectedTicket == item ? "ticket" : "", in: namespace, properties: .frame, isSource: false)
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
                            }
                            .contextMenu(ContextMenu {
                                itemActions(for: item)
                            })
                            // ticket view
                        Spacer()
                    } // hstack
                }.frame(width: 1000, height: 100)
                // geo reader
            } // foreach
        } // vgrid
    }
}
