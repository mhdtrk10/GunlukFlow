//
//  GünlükFlowViewModelTests.swift
//  GunlukFlow
//
//  Created by Mehdi Oturak on 23.06.2025.
//

import XCTest
import CoreData
@testable import GunlukFlow

final class GunlukFlowViewModelTests: XCTestCase {
    
    var viewModel: TaskViewModel!
    var context: NSManagedObjectContext!
    
    override func setUpWithError() throws {
        let container = NSPersistentContainer(name: "GunlukFlow") // .xcdatamodeld adın bu mu? Kontrol et
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]

        var loadError: Error?
        let semaphore = DispatchSemaphore(value: 0)

        container.loadPersistentStores { _, error in
            loadError = error
            semaphore.signal()
        }

        semaphore.wait()

        if let error = loadError {
            XCTFail("Persistent store failed to load: \(error)")
            return
        }

        context = container.viewContext
        viewModel = TaskViewModel(context: context)
    }

    
    override func tearDownWithError() throws {
        viewModel = nil
        context = nil
    }
    
    func testToggleTask() {
        // 1. taskEntity oluşturma
        let newTask = TaskEntity(context: context)
        
        newTask.taskID = UUID()
        newTask.title = "test görevi"
        newTask.isCompleted = false
        
        guard let id = newTask.taskID else {
            XCTFail("taskID is nil")
            return
        }
        
        // 2. taskModeli oluşturma
        let model = TaskModel(
            id: id,
            title: newTask.title ?? "",
            isCompleted: newTask.isCompleted,
            date: Date(),
            category: newTask.category ?? "",
            isFavorite: newTask.isFavorite,
            reminderOffset: newTask.reminderOffset
        )
        // 3. Toggle işlemi uygulama
        viewModel.toggleTask(model)
        
        // 4. Task'ı tekrar çek
        let request: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        request.predicate = NSPredicate(format: "taskID == %@", model.id as CVarArg)
        let updateTask = try? context.fetch(request).first
        
        // 5. Sonucu kontrol et
        XCTAssertEqual(updateTask?.isCompleted, true)
        
    }
}
