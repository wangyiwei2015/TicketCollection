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
    //var container: ModelContainer
    
//    init() {
//        let config1 = ModelConfiguration(for: TicketItem.self)
//        let config2 = ModelConfiguration(for: TicketFolder.self)
//        container = try! ModelContainer(for: TicketItem.self, TicketFolder.self, configurations: config1, config2)
//    }
    
    var body: some Scene {
        WindowGroup {
            //NavigationStack {
            ContentView()
            //}
        }//.modelContainer(container)
        .modelContainer(for: TicketItem.self, isAutosaveEnabled: false)
    }
}
