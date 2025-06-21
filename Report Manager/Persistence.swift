import CoreData
import FirebaseAuth

class PersistenceController {
    static let shared = PersistenceController()
    
    let container: NSPersistentContainer
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Report_Manager")
        
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Error: \(error.localizedDescription)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    // MARK: - User Management
    func saveUser(_ user: User) {
        let context = container.viewContext
        
        let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        
        do {
            let existingUsers = try context.fetch(fetchRequest)
            existingUsers.forEach { context.delete($0) }
            
            let userEntity = UserEntity(context: context)
            userEntity.user_id = user.id
            userEntity.user_email = user.email
            userEntity.user_name = user.name
            userEntity.photo_url = user.photoURL?.absoluteString
            
            try context.save()
        } catch {
            print("Error saving user to Core Data: \(error)")
        }
    }
    
    func getUser() -> User? {
        let context = container.viewContext
        let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        
        do {
            let userEntities = try context.fetch(fetchRequest)
            guard let userEntity = userEntities.first else { return nil }
            
            return User(
                id: userEntity.user_id ?? "",
                email: userEntity.user_email ?? "",
                name: userEntity.user_name ?? "",
                photoURL: URL(string: userEntity.photo_url ?? "")
            )
        } catch {
            print("Error fetching user from Core Data: \(error)")
            return nil
        }
    }
    
    func deleteUser() {
        let context = container.viewContext
        let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        
        do {
            let users = try context.fetch(fetchRequest)
            users.forEach { context.delete($0) }
            try context.save()
        } catch {
            print("Error deleting user from Core Data: \(error)")
        }
    }
}
