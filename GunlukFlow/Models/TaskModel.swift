//
//  TaskModel.swift
//  GunlukFlow
//
//  Created by Mehdi Oturak on 15.04.2025.
//

import Foundation
import CoreData

// görevi temsil eden model

struct TaskModel: Identifiable {
    var id: UUID // Core Datadaki nesnenin kimliği
    var title: String // Görev başlığı
    var isCompleted: Bool // tamamlandı mı?
    var date: Date // tarih
    var category: String // Yeni kategori
    var isFavorite: Bool // favorilere ekleme için
    var reminderOffset: TimeInterval // hatırlatma için
}
