//
//  ContentView.swift
//  Report Manager
//
//  Created by Rahul choudhary on 20/06/25.
//

// ContentView.swift
import SwiftUI

struct ContentView: View {
    @StateObject private var authViewModel = AuthenticationViewModel()
    
    var body: some View {
        Group {
            if authViewModel.isAuthenticated {
                MainView()
                    .environmentObject(authViewModel)
            } else {
                SignInView()
            }
        }
    }
}

struct MainView: View {
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    
    var body: some View {
        NavigationView {
            List {
                Section("User Info") {
                    Text("Welcome, \(authViewModel.currentUser?.name ?? "")")
                }
                
                Section("Reports") {
                    NavigationLink(destination: PDFViewerView()) {
                        HStack {
                            Image(systemName: "doc.text.fill")
                                .foregroundColor(.blue)
                            Text("Balance Sheet")
                        }
                    }
                }
                
                Section {
                    Button(action: {
                        authViewModel.signOut()
                    }) {
                        HStack {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                                .foregroundColor(.red)
                            Text("Sign Out")
                                .foregroundColor(.red)
                        }
                    }
                }
            }
            .navigationTitle("Dashboard")
            .listStyle(InsetGroupedListStyle())
        }
    }
}
