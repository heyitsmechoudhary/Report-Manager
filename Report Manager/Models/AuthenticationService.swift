//
//  AuthenticationService.swift
//  Report Manager
//
//  Created by Rahul choudhary on 21/06/25.
//

// Services/AuthenticationService.swift

import FirebaseAuth
import GoogleSignIn
import FirebaseCore

class AuthenticationService {
    func signInWithGoogle() async throws -> User {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            throw AuthError.clientIDNotFound
        }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first,
              let rootViewController = window.rootViewController else {
            throw AuthError.presentationContextMissing
        }
        
        let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
        
        guard let idToken = result.user.idToken?.tokenString else {
            throw AuthError.tokenMissing
        }
        
        let credential = GoogleAuthProvider.credential(
            withIDToken: idToken,
            accessToken: result.user.accessToken.tokenString
        )
        
        let authResult = try await Auth.auth().signIn(with: credential)
        
        return User(
            id: authResult.user.uid,
            email: authResult.user.email ?? "",
            name: authResult.user.displayName ?? "",
            photoURL: authResult.user.photoURL
        )
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
        GIDSignIn.sharedInstance.signOut()
    }
}

enum AuthError: Error {
    case clientIDNotFound
    case presentationContextMissing
    case tokenMissing
}
