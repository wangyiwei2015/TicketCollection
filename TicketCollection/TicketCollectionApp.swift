//
//  TicketCollectionApp.swift
//  TicketCollection
//
//  Created by leo on 2023-11-12.
//

import SwiftUI
import SwiftData
import RevenueCat

@main
struct TicketCollectionApp: App {
    
    init() {
        #if DEBUG
        Purchases.logLevel = .warn
        #endif
        Purchases.configure(withAPIKey: "appl_HHiEKFgRrzfqvoBcwMmcNELGqqb")
    }
    
    var body: some Scene {
        WindowGroup {
            //NavigationStack {
            ContentView()
            //}
        }.modelContainer(for: TicketItem.self, isAutosaveEnabled: false)
    }
}
