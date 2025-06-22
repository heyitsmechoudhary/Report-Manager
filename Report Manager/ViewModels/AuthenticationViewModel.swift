// ViewModels/AuthenticationViewModel.swift

import SwiftUI
import FirebaseAuth
import GoogleSignIn
import CoreData

@MainActor
class AuthenticationViewModel: ObservableObject {
    static let shared = AuthenticationViewModel()
    
    @Published var isAuthenticated = false
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var currentUser: User?
    
    private let authService: AuthenticationService
    private let persistence: PersistenceController
    
    private init() {
        self.authService = AuthenticationService()
        self.persistence = .shared
        
        // Check initial auth state
        checkAuthenticationState()
        
        // Add auth state listener
        Auth.auth().addStateDidChangeListener { [weak self] _, user in
            Task { @MainActor in
                if let user = user {
                    self?.isAuthenticated = true
                    self?.currentUser = User(
                        id: user.uid,
                        email: user.email ?? "",
                        name: user.displayName ?? "",
                        photoURL: user.photoURL
                    )
                    print("User authenticated: \(user.email ?? "")")
                } else {
                    self?.isAuthenticated = false
                    self?.currentUser = nil
                    print("User signed out")
                }
            }
        }
    }
    
    func checkAuthenticationState() {
        if let firebaseUser = Auth.auth().currentUser {
            print("User is signed in: \(firebaseUser.email ?? "")")
            isAuthenticated = true
            currentUser = User(
                id: firebaseUser.uid,
                email: firebaseUser.email ?? "",
                name: firebaseUser.displayName ?? "",
                photoURL: firebaseUser.photoURL
            )
        } else {
            print("No user is signed in")
            isAuthenticated = false
            currentUser = nil
        }
    }
    
    func signInWithGoogle() {
        print("Starting Google Sign In")
        isLoading = true
        
        Task {
            do {
                let result = try await authService.signInWithGoogle()
                print("Sign in successful: \(result.email)")
                await MainActor.run {
                    self.currentUser = result
                    self.isAuthenticated = true
                    self.isLoading = false
                }
                persistence.saveUser(result)
            } catch {
                print("Sign in failed: \(error.localizedDescription)")
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                    self.isAuthenticated = false
                    self.isLoading = false
                }
            }
        }
    }
    
    func signOut() {
        do {
            try authService.signOut()
            isAuthenticated = false
            currentUser = nil
            persistence.deleteUser()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
