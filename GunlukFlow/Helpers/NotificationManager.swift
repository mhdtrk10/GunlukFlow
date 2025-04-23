//
//  NotificationManager.swift
//  GunlukFlow
//
//  Created by Mehdi Oturak on 23.04.2025.
//

import Foundation
import UserNotifications

// bildirimleri yöneten sınıf
struct NotificationManager {
    // belirtilen tarihte seçilen ses ile bildirim zamanlar
    
    static func scheduleNotification(title: String, body: String, date: Date) {
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        
        // kullanıcının seçtiği sesi UserDefaults'tan alma
        let selectedSoundFile = UserDefaults.standard.string(forKey: "selectedSound") ?? "kus.caf"
        
        // bildirime özel ses atama
        content.sound = UNNotificationSound(named: UNNotificationSoundName(selectedSoundFile))
        
        // tarih bileşenlerini çıkar
        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        
        
        // tek seferlik zamanlayıcı tetikleyici
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        
        
        // benzeersiz kimlik oluşturma
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        // bildirimi planlama
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Bildirim zamanlanamadı: \(error.localizedDescription)")
            } else {
                print("Bildirim başarı ile zamanlandı.")
            }
        }
        
    }
    
    
}
