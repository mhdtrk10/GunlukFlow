//
//  GunlukFlowApp.swift
//  GunlukFlow
//
//  Created by Mehdi Oturak on 15.04.2025.
//

import SwiftUI

@main
struct GunlukFlowApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    let persistenceController = PersistenceController.shared
    @Environment(\.scenePhase) private var scenePhase

    init() {
        requestNotificationPermission()
    }
    
    var body: some Scene {
        WindowGroup {
            TaskListView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .onChange(of: scenePhase) { oldPhase, newPhase in
                    if newPhase == .active {
                        checkForMissedTasks()
                    }
                }
        }
    }
    
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Bildirim izni verildi!")
            } else {
                print("Bildirim izni reddedildi: \(error?.localizedDescription ?? "Bilinmeyen hata")")
            }
        }
    }
    
    func checkForMissedTasks() {
        let viewModel = TaskViewModel(context: persistenceController.container.viewContext)
        let now = Date()
        
        for task in viewModel.tasks {
            let timeDifference = now.timeIntervalSince(task.date)
            
            if  timeDifference >= 0 && timeDifference <= 60 {
                cancelLateReminder(for: task)
            }
        }
    }
    func cancelLateReminder(for task: TaskModel) {
        let identifier = "late_(\(task.id.uuidString))"
        NotificationManager.cancelNotification(identifier: identifier)
    }
}
