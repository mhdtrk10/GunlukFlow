//
//  Persistence.swift
//  GunlukFlow
//
//  Created by Mehdi Oturak on 15.04.2025.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()


    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "GunlukFlow")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { description, error in
            
            if let error = error as NSError? {
                fatalError("Core Data yüklenemedi. \(error), \(error.userInfo)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
