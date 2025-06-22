//
//  APIObjectListView.swift
//  Report Manager
//
//  Created by Rahul choudhary on 22/06/25.
//


import SwiftUI

struct APIObjectListView: View {
    @StateObject private var viewModel = APIObjectViewModel()
    @State private var objectToEdit: APIObject?
    
    var body: some View {
        List {
            ForEach(viewModel.objects) { object in
                APIObjectRow(object: object)
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button(role: .destructive) {
                            viewModel.deleteObject(object)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                        
                        Button {
                            objectToEdit = object
                        } label: {
                            Label("Edit", systemImage: "pencil")
                        }
                        .tint(.blue)
                    }
            }
        }
        .navigationTitle("Products")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    viewModel.fetchAndStoreObjects()
                } label: {
                    Image(systemName: "arrow.clockwise")
                }
                .disabled(viewModel.isLoading)
            }
        }
        .overlay {
            if viewModel.isLoading {
                ProgressView("Loading...")
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(8)
                    .shadow(radius: 2)
            }
        }
        .sheet(item: $objectToEdit) { object in
            EditObjectSheet(
                object: object,
                viewModel: viewModel,
                isPresented: Binding(
                    get: { objectToEdit != nil },
                    set: { if !$0 { objectToEdit = nil } }
                )
            )
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
        .onAppear {
            viewModel.fetchAndStoreObjects()
        }
    }
}

struct APIObjectRow: View {
    let object: APIObject
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(object.name)
                .font(.headline)
            
            if let data = object.data {
                ForEach(Array(data.keys.sorted()), id: \.self) { key in
                    HStack {
                        Text(key)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text(object.getFormattedValue(for: key))
                    }
                    .font(.subheadline)
                }
            }
        }
        .padding(.vertical, 4)
    }
}

struct EditObjectSheet: View {
    let object: APIObject
    let viewModel: APIObjectViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var name: String
    @State private var editedData: [String: String] = [:]
    
    init(object: APIObject, viewModel: APIObjectViewModel, isPresented: Binding<Bool>) {
        self.object = object
        self.viewModel = viewModel
        self._name = State(initialValue: object.name)
        
        var initialData: [String: String] = [:]
        object.data?.forEach { key, value in
            initialData[key] = object.getFormattedValue(for: key)
        }
        self._editedData = State(initialValue: initialData)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section("Basic Info") {
                    TextField("Name", text: $name)
                }
                
                Section("Details") {
                    ForEach(Array(editedData.keys.sorted()), id: \.self) { key in
                        if let binding = Binding($editedData[key]) {
                            HStack {
                                Text(key)
                                    .foregroundColor(.secondary)
                                TextField("Value", text: binding)
                                    .multilineTextAlignment(.trailing)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Edit Product")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveChanges()
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func saveChanges() {
        var newData: [String: AnyCodable] = [:]
        editedData.forEach { key, value in
            guard !value.isEmpty else {
                newData[key] = AnyCodable("")
                return
            }
            
            if let doubleValue = Double(value), !doubleValue.isNaN {
                newData[key] = AnyCodable(doubleValue)
            } else if let intValue = Int(value) {
                newData[key] = AnyCodable(intValue)
            } else {
                newData[key] = AnyCodable(value)
            }
        }
        
        let updatedObject = APIObject(id: object.id, name: name, data: newData)
        viewModel.updateObject(updatedObject)
    }
}
