//
//  Report_ManagerApp.swift
//  Report Manager
//
//  Created by Rahul choudhary on 20/06/25.
//

import SwiftUI
import Firebase
import GoogleSignIn

@main
struct Report_ManagerApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var authViewModel = AuthenticationViewModel.shared
    let persistenceController = PersistenceController.shared

    init() {
        NotificationManager.shared.requestAuthorization()
    }

    
    var body: some Scene {
        
        
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(authViewModel)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
    
    func application(_ app: UIApplication,
                    open url: URL,
                    options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }
}
