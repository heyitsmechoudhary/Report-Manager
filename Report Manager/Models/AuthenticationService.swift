//
//  AuthenticationService.swift
//  Report Manager
//
//  Created by Rahul choudhary on 21/06/25.
//

import FirebaseAuth
import GoogleSignIn
import UIKit
import FirebaseCore

class AuthenticationService {
    private let auth = Auth.auth()
    
    func signInWithGoogle(completion: @escaping (Result<User, Error>) -> Void) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first,
              let rootViewController = window.rootViewController else {
            return
        }
        
        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { [weak self] result, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to get ID token"])))
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                         accessToken: user.accessToken.tokenString)
            
            self?.auth.signIn(with: credential) { authResult, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                if let firebaseUser = authResult?.user {
                    let user = User(
                        id: firebaseUser.uid,
                        email: firebaseUser.email ?? "",
                        name: firebaseUser.displayName ?? "",
                        photoURL: firebaseUser.photoURL
                    )
                    completion(.success(user))
                }
            }
        }
    }
    
    func signOut() throws {
        try auth.signOut()
        GIDSignIn.sharedInstance.signOut()
    }
}
