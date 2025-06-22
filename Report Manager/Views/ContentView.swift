//
//  ContentView.swift
//  Report Manager
//
//  Created by Rahul choudhary on 20/06/25.
//

// ContentView.swift

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    
    var body: some View {
        Group {
            if authViewModel.isAuthenticated {
                MainView()
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
                
                Section("Features") {
                    NavigationLink(destination: PDFViewerView()) {
                        HStack {
                            Image(systemName: "doc.text.fill")
                                .foregroundColor(.blue)
                            Text("Balance Sheet")
                        }
                    }
                    
                    NavigationLink(destination: ImagePickerView()) {
                        HStack {
                            Image(systemName: "camera.fill")
                                .foregroundColor(.green)
                            Text("Image Capture")
                        }
                    }
                    
                    NavigationLink(destination: APIObjectListView()) {
                        HStack {
                            Image(systemName: "list.bullet.rectangle")
                                .foregroundColor(.purple)
                            Text("API Objects")
                        }
                    }
                    NavigationLink(destination: SettingsView()) {
                        HStack {
                            Image(systemName: "gear")
                                .foregroundColor(.red)
                            Text("Settings")
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

// Preview provider
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AuthenticationViewModel.shared)
    }
}
