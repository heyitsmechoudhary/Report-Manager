import SwiftUI
import FirebaseAuth
import GoogleSignIn
import CoreData

class AuthenticationViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var currentUser: User?
    
    private let authService: AuthenticationService
    private let persistence: PersistenceController
    
    init(authService: AuthenticationService = AuthenticationService(),
         persistence: PersistenceController = .shared) {
        self.authService = authService
        self.persistence = persistence
        checkAuthenticationState()
    }
    
    func checkAuthenticationState() {
        if Auth.auth().currentUser != nil {
            self.isAuthenticated = true
            self.currentUser = persistence.getUser()
        }
    }
    
    func signInWithGoogle() {
        isLoading = true
        
        authService.signInWithGoogle { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                switch result {
                case .success(let user):
                    self?.currentUser = user
                    self?.isAuthenticated = true
                    self?.persistence.saveUser(user)
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
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
