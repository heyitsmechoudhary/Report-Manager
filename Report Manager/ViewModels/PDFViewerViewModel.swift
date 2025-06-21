//
//  PDFViewerViewModel.swift
//  Report Manager
//
//  Created by Rahul choudhary on 21/06/25.
//



import PDFKit
import SwiftUI

extension PDFViewerViewModel {
    enum PDFError: Error {
        case invalidURL
        case loadFailed
        case downloadFailed
    }
}

@MainActor
final class PDFViewerViewModel: ObservableObject {
    // Published properties
    @Published var pdfDocument: PDFKit.PDFDocument?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var currentPage = 0
    @Published var totalPages = 0
    
    // Constants
    private let pdfURL = "https://fssservices.bookxpert.co/GeneratedPDF/Companies/nadc/2024-2025/BalanceSheet.pdf"
    
    // Methods
    func loadPDF() {
        guard let url = URL(string: pdfURL) else {
            errorMessage = PDFError.invalidURL.localizedDescription
            return
        }
        
        isLoading = true
        
        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                
                guard let document = PDFKit.PDFDocument(data: data) else {
                    throw PDFError.loadFailed
                }
                
                pdfDocument = document
                totalPages = document.pageCount
            } catch {
                errorMessage = error.localizedDescription
            }
            
            isLoading = false
        }
    }
    
    func goToNextPage() {
        guard let document = pdfDocument,
              currentPage < document.pageCount - 1 else { return }
        currentPage += 1
    }
    
    func goToPreviousPage() {
        guard currentPage > 0 else { return }
        currentPage -= 1
    }
}
