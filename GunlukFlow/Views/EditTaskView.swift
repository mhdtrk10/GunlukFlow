//
//  EditTaskView.swift
//  GunlukFlow
//
//  Created by Mehdi Oturak on 6.05.2025.
//

import SwiftUI

struct EditTaskView: View {
    
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: TaskViewModel
    
    var task: TaskModel
    
    @State private var title: String
    @State private var date: Date
    @State private var category: String
    @State private var reminderOffSet: TimeInterval
    
    
    init(viewModel: TaskViewModel, task: TaskModel) {
        self.viewModel = viewModel
        self.task = task
        
        _title = State(initialValue: task.title)
        _date = State(initialValue: task.date)
        _category = State(initialValue: task.category)
        _reminderOffSet = State(initialValue: task.reminderOffset)
    }
    
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Görev")) {
                    TextField("Başlık", text: $title)
                }
                Section(header: Text("Tarih")) {
                    DatePicker("Tarih", selection: $date)
                }
                Section(header: Text("Kategori")) {
                    TextField("Kategori", text: $category)
                }
                Section(header: Text("Hatırlatma Süresi")) {
                    Picker("Hatırlatma", selection: $reminderOffSet) {
                        Text("Görev saatinde").tag(0.0)
                        Text("5 dakika önce").tag(-300.0)
                        Text("15 dakika önce").tag(-900.0)
                        Text("1 saat önce").tag(-3600.0)
                    }
                }
                Button("Kaydet") {
                    viewModel.updateTask(task, title: title, date: date, category: category, reminderOffSet: reminderOffSet)
                }
            }
            .navigationTitle("Görev Düzenle")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                    }
                }
            }
        }
    }
}

