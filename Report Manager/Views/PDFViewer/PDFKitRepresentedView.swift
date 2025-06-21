//
//  PDFKitRepresentedView.swift
//  Report Manager
//
//  Created by Rahul choudhary on 21/06/25.
//

// Views/PDFKitRepresentedView.swift
import SwiftUI
import PDFKit

struct PDFKitRepresentedView: UIViewRepresentable {
    let document: PDFKit.PDFDocument
    @Binding var currentPage: Int
    
    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.document = document
        pdfView.autoScales = true
        pdfView.displayMode = .singlePage
        pdfView.displayDirection = .horizontal
        pdfView.delegate = context.coordinator
        return pdfView
    }
    
    func updateUIView(_ pdfView: PDFView, context: Context) {
        if let page = document.page(at: currentPage) {
            pdfView.go(to: page)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, PDFViewDelegate {
        var parent: PDFKitRepresentedView
        
        init(_ parent: PDFKitRepresentedView) {
            self.parent = parent
        }
        
        func pdfViewPageChanged(_ pdfView: PDFView) {
            if let currentPage = pdfView.currentPage,
               let pageIndex = pdfView.document?.index(for: currentPage) {
                parent.currentPage = pageIndex
            }
        }
    }
}
