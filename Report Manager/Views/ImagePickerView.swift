//
//  ImgPickerView.swift
//  Report Manager
//
//  Created by Rahul choudhary on 22/06/25.
//


import SwiftUI
import PhotosUI

struct ImagePickerView: View {
    @StateObject private var viewModel = ImagePickerViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                if let image = viewModel.selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 300)
                        .cornerRadius(10)
                        .padding()
                } else {
                    Image(systemName: "photo.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 300)
                        .foregroundColor(.gray)
                        .padding()
                }
                
                HStack(spacing: 20) {
                    Button(action: {
                        viewModel.checkCameraPermission()
                    }) {
                        VStack {
                            Image(systemName: "camera.fill")
                                .font(.system(size: 24))
                            Text("Camera")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    
                    Button(action: {
                        viewModel.sourceType = .photoLibrary
                        viewModel.isImagePickerPresented = true
                    }) {
                        VStack {
                            Image(systemName: "photo.fill")
                                .font(.system(size: 24))
                            Text("Gallery")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                }
                .padding()
            }
            .navigationTitle("Image Picker")
            .sheet(isPresented: $viewModel.isImagePickerPresented) {
                if let sourceType = viewModel.sourceType {
                    ImagePicker(selectedImage: $viewModel.selectedImage, sourceType: sourceType)
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
}

// UIKit wrapper for Image Picker
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    let sourceType: UIImagePickerController.SourceType
    @Environment(\.presentationMode) var presentationMode
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
