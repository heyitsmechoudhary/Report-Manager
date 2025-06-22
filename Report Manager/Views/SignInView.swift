//
//  SignInView.swift
//  Report Manager
//
//  Created by Rahul choudhary on 20/06/25.
//

// Views/SignInView.swift

import SwiftUI

struct SignInView: View {
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            // App Logo
            Image(systemName: "person.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .foregroundColor(.blue)
            
            if authViewModel.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
            } else {
                // Google Sign In Button
                Button(action: {
                    authViewModel.signInWithGoogle()
                }) {
                    HStack {
                        Image(systemName: "g.circle.fill")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(.red)
                        
                        Text("Sign in with Google")
                            .foregroundColor(.primary)
                            .font(.headline)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                }
                .padding(.horizontal)
            }
        }
        .alert("Error", isPresented: Binding(
            get: { authViewModel.errorMessage != nil },
            set: { _ in authViewModel.errorMessage = nil }
        )) {
            Button("OK", role: .cancel) {}
        } message: {
            if let error = authViewModel.errorMessage {
                Text(error)
            }
        }
    }
}

// Preview provider
struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
            .environmentObject(AuthenticationViewModel.shared)
    }
}
