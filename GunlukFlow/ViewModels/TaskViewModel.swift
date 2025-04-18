//
//  TaskViewModel.swift
//  GunlukFlow
//
//  Created by Mehdi Oturak on 15.04.2025.
//

import Foundation
import CoreData

class TaskViewModel: ObservableObject {
    
    //CoreData context(veri işlemleri için)
    let context: NSManagedObjectContext
    
    // view'de kullanmak için görev listesi
    @Published var tasks: [TaskModel] = []
    
    // başlatıcı(init), dışarıdan context alır(app içinde environment ile )
    init(context: NSManagedObjectContext) {
        self.context = context
        fetchTasks()
    }
    // COre Data'dan görevleri çekip 'TaskModel' dizisine dönüştürür
    func fetchTasks() {
        let request = NSFetchRequest<TaskEntity>(entityName: "TaskEntity")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \TaskEntity.date, ascending: true)]
        
        do {
            let result = try context.fetch(request)
            
            //Core Data'dan gelen veriyi TaskModel'e çeviriyoruz.
            
            self.tasks = result.map { entity in
                TaskModel(
                    id: entity.objectID,
                    title: entity.title ?? "",
                    isCompleted: entity.isCompleted,
                    date: entity.date ?? Date(),
                    category: entity.category ?? "Genel"
            )
            }
        } catch {
            print("Görevler çekilemedi: \(error.localizedDescription)")
        }
    }
    // yeni görev ekler
    
    func addTask(title: String, date: Date, category: String) {
        let newTask = TaskEntity(context: context)
        newTask.title = title
        newTask.isCompleted = false
        newTask.date = date
        newTask.category = category
        
        saveChanges()
        fetchTasks()
    }
    // Görevi tamamlandı(başlamadı olarak işaretler
    
    func toggleTask(_ task: TaskModel) {
        if let entity = try? context.existingObject(with: task.id) as? TaskEntity {
            entity.isCompleted.toggle()
            saveChanges()
            fetchTasks()
        }
    }
    // görevi siler
    func deleteTask(_ task: TaskModel) {
        if let entity = try? context.existingObject(with: task.id) as? TaskEntity {
            context.delete(entity)
            saveChanges()
            fetchTasks()
        }
    }
    //Core Data'ya değişiklikleri kaydeder.
    private func saveChanges() {
        do {
            try context.save()
            
        } catch {
            print("Değişiklikler kaydedilemedi. \(error.localizedDescription)")
        }
    }
    // haftalık görev tamamlama istatistiğini veren fonksiyon
    func getWeeklyCompletionData() -> [(day: String, count: Int)] {
        // takvim ve tarih ayarları
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        var data : [(String,Int)] = []
        
        for i in (0..<7).reversed() {
            // günü hesaplama
            if let date = calendar.date(byAdding: .day, value: -i, to: today) {
                let dayName = calendar.shortWeekdaySymbols[calendar.component(.weekday, from: date) - 1]
                
                // o gün tanımlanmış görev sayısını bulma
                let count = tasks.filter { task in
                    task.isCompleted &&
                    calendar.isDate(task.date ,inSameDayAs: date)
                    
                }.count
                
                data.append((dayName,count))
            }
        }
        return data
    }
}
