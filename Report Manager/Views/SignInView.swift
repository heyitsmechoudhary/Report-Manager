//
//  SignInView.swift
//  Report Manager
//
//  Created by Rahul choudhary on 20/06/25.
//
import SwiftUI

struct SignInView: View {
    @StateObject private var viewModel = AuthenticationViewModel()
    @State private var isButtonPressed = false
    
    var body: some View {
        VStack(spacing: 30) {
            // Animated App Logo
            Image(systemName: "doc.text.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .foregroundColor(.blue)
                .scaleEffect(isButtonPressed ? 0.9 : 1.0)
                .animation(.spring(), value: isButtonPressed)
            
            if viewModel.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(1.5)
            } else {
                // Animated Sign In Button
                Button(action: {
                    withAnimation {
                        isButtonPressed = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        isButtonPressed = false
                        viewModel.signInWithGoogle()
                    }
                }) {
                    HStack(spacing: 12) {
                        Image(systemName: "person.badge.key.fill")
                            .imageScale(.large)
                        Text("Sign in with Google")
                            .font(.headline)
                    }
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(12)
                    .shadow(radius: isButtonPressed ? 1 : 3)
                    .scaleEffect(isButtonPressed ? 0.95 : 1.0)
                }
                .padding(.horizontal)
            }
        }
        .alert("Error", isPresented: Binding(
            get: { viewModel.errorMessage != nil },
            set: { _ in viewModel.errorMessage = nil }
        )) {
            Button("OK", role: .cancel) {}
        } message: {
            if let error = viewModel.errorMessage {
                Text(error)
            }
        }
    }
}

// Preview
struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
