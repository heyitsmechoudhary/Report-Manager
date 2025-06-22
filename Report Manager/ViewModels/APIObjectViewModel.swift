//
//  APIObjectViewModel.swift
//  Report Manager
//
//  Created by Rahul choudhary on 22/06/25.
//


import SwiftUI
import CoreData

@MainActor
class APIObjectViewModel: ObservableObject {
    @Published var objects: [APIObject] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let apiService: APIService
    private let persistence: PersistenceController
    
    init(apiService: APIService = .shared,
         persistence: PersistenceController = .shared) {
        self.apiService = apiService
        self.persistence = persistence
    }
    
    func fetchAndStoreObjects() {
        isLoading = true
        
        Task {
            do {
                let fetchedObjects = try await apiService.fetchObjects()
                await MainActor.run {
                    self.objects = fetchedObjects
                }
                try await storeObjectsInCoreData(fetchedObjects)
            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                }
            }
            await MainActor.run {
                self.isLoading = false
            }
        }
    }
    
    func deleteObject(_ object: APIObject) {
        Task {
            do {
                let context = persistence.container.viewContext
                let fetchRequest: NSFetchRequest<APIObjectEntity> = APIObjectEntity.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "id == %@", object.id)
                
                let results = try context.fetch(fetchRequest)
                if let entityToDelete = results.first {
                    context.delete(entityToDelete)
                    try context.save()
                    
                    objects.removeAll { $0.id == object.id }
                    NotificationManager.shared.sendDeletionNotification(for: object)
                }
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }
    
    func updateObject(_ object: APIObject) {
        Task {
            do {
                let context = persistence.container.viewContext
                let fetchRequest: NSFetchRequest<APIObjectEntity> = APIObjectEntity.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "id == %@", object.id)
                
                let results = try context.fetch(fetchRequest)
                if let entityToUpdate = results.first {
                    entityToUpdate.name = object.name
                    if let data = object.data {
                        let jsonData = try JSONEncoder().encode(data)
                        entityToUpdate.jsonData = jsonData
                    }
                    try context.save()
                    
                    if let index = objects.firstIndex(where: { $0.id == object.id }) {
                        objects[index] = object
                    }
                }
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }
    
    private func storeObjectsInCoreData(_ objects: [APIObject]) async throws {
        let context = persistence.container.viewContext
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = APIObjectEntity.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        try context.execute(deleteRequest)
        
        for object in objects {
            let entity = APIObjectEntity(context: context)
            entity.id = object.id
            entity.name = object.name
            
            if let data = object.data {
                let jsonData = try JSONEncoder().encode(data)
                entity.jsonData = jsonData
            }
        }
        
        try context.save()
    }
}
