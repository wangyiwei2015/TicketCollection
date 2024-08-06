//
//  TicketCollectionApp.swift
//  TicketCollection
//
//  Created by leo on 2023-11-12.
//

import SwiftUI
import SwiftData

@main
struct TicketCollectionApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }.modelContainer(for: TicketItem.self, isAutosaveEnabled: false)
    }
}
