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
                    id: entity.taskID ?? UUID(),
                    title: entity.title ?? "",
                    isCompleted: entity.isCompleted,
                    date: entity.date ?? Date(),
                    category: entity.category ?? "Genel",
                    isFavorite: entity.isFavorite,
                    reminderOffset: entity.reminderOffset
            )
            }
        } catch {
            print("Görevler çekilemedi: \(error.localizedDescription)")
        }
    }
    // görevin favori durumunu değiştirme
    
    func toggleFavorite(_ task: TaskModel) {
        
        let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "taskID == %@", task.id as CVarArg)
        
        do {
            
            if let entity = try context.fetch(fetchRequest).first {
                entity.isFavorite.toggle()
                saveChanges()
                fetchTasks()
            }
            
        } catch {
            print("Favori durumu değiştirilirken hata oluştu: \(error.localizedDescription)")
        }
        
    }
    
    
    
    // yeni görev ekler
    
    func addTask(title: String, date: Date, category: String, reminderOffset: TimeInterval) {
        let newTask = TaskEntity(context: context)
        newTask.title = title
        newTask.isCompleted = false
        newTask.date = date
        newTask.category = category
        newTask.reminderOffset = reminderOffset
        newTask.taskID = UUID()
        
        saveChanges()
        fetchTasks()
    }
    // Görevi tamamlandı(başlamadı olarak işaretler
    
    func toggleTask(_ task: TaskModel) {
        let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "taskID == %@", task.id as CVarArg)
        
        do {
            if let entity = try context.fetch(fetchRequest).first {
                entity.isCompleted.toggle()
                
                saveChanges()
                fetchTasks()
            }
        } catch {
            print("Görev onaylanırken hata oluştu: \(error.localizedDescription)")
        }
    }
    // görevi siler
    func deleteTask(_ task: TaskModel) {
        let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "taskID == %@", task.id as CVarArg)
        
        do {
            if let entityToDelete = try context.fetch(fetchRequest).first {
                context.delete(entityToDelete)
                
                saveChanges()
                fetchTasks()
            }
        } catch {
            print("Silme işleminde hata gerçekleşti: \(error.localizedDescription)")
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
    
    // güncelleme fonksiyonu
    func updateTask(_ task: TaskModel, title: String, date: Date, category: String, reminderOffSet: TimeInterval) {
        
        let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", task.id as CVarArg)
        
        do {
            
            if let entity = try context.fetch(fetchRequest).first {
                entity.category = category
                entity.title = title
                entity.date = date
                entity.reminderOffset = reminderOffSet
                saveChanges()
                
                NotificationManager.scheduleNotification(title: "Görev zamanı", body: title, date: date, reminderOffSet: reminderOffSet)
            }
            
            
        } catch {
            print("güncelleme esnasında hata oluştu: \(error.localizedDescription)")
        }
        
        
    }
    
    
}
