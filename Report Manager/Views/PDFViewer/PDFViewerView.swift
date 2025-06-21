//
//  PDFViewerView.swift
//  Report Manager
//
//  Created by Rahul choudhary on 21/06/25.
//

// Views/PDFViewerView.swift
import SwiftUI
import PDFKit

struct PDFViewerView: View {
    @StateObject private var viewModel = PDFViewerViewModel()
    
    var body: some View {
        ZStack {
            if let pdfDocument = viewModel.pdfDocument {
                VStack {
                    PDFKitRepresentedView(document: pdfDocument,
                                        currentPage: $viewModel.currentPage)
                    
                    // Page Navigation Controls
                    HStack {
                        Button(action: {
                            if viewModel.currentPage > 0 {
                                viewModel.currentPage -= 1
                            }
                        }) {
                            Image(systemName: "chevron.left.circle.fill")
                                .imageScale(.large)
                                .foregroundColor(.blue)
                        }
                        .disabled(viewModel.currentPage == 0)
                        
                        Text("Page \(viewModel.currentPage + 1) of \(viewModel.totalPages)")
                            .padding(.horizontal)
                        
                        Button(action: {
                            if viewModel.currentPage < viewModel.totalPages - 1 {
                                viewModel.currentPage += 1
                            }
                        }) {
                            Image(systemName: "chevron.right.circle.fill")
                                .imageScale(.large)
                                .foregroundColor(.blue)
                        }
                        .disabled(viewModel.currentPage == viewModel.totalPages - 1)
                    }
                    .padding()
                }
            } else if viewModel.isLoading {
                ProgressView("Loading PDF...")
                    .scaleEffect(1.5)
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
        .navigationTitle("Balance Sheet")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button(action: {
                        // Share PDF
                    }) {
                        Label("Share", systemImage: "square.and.arrow.up")
                    }
                    
                    Button(action: {
                        // Download PDF
                    }) {
                        Label("Download", systemImage: "arrow.down.circle")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
        .onAppear {
            viewModel.loadPDF()
        }
    }
}
