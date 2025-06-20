//
//  Report_ManagerApp.swift
//  Report Manager
//
//  Created by Rahul choudhary on 20/06/25.
//

import SwiftUI

@main
struct Report_ManagerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
