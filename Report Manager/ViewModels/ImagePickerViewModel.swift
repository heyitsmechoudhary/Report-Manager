//
//  ImagePickerViewModel.swift
//  Report Manager
//
//  Created by Rahul choudhary on 22/06/25.
//


import SwiftUI
import PhotosUI

@MainActor
final class ImagePickerViewModel: ObservableObject {
    @Published var selectedImage: UIImage?
    @Published var isImagePickerPresented = false
    @Published var isSourceTypeSheetPresented = false
    @Published var sourceType: UIImagePickerController.SourceType?
    @Published var errorMessage: String?
    
    func checkCameraPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            self.sourceType = .camera
            self.isImagePickerPresented = true
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                DispatchQueue.main.async {
                    if granted {
                        self?.sourceType = .camera
                        self?.isImagePickerPresented = true
                    } else {
                        self?.errorMessage = "Camera access denied"
                    }
                }
            }
        case .denied, .restricted:
            self.errorMessage = "Camera access denied. Please enable it in Settings."
        @unknown default:
            break
        }
    }
}
