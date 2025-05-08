//
//  TaskListView.swift
//  GunlukFlow
//
//  Created by Mehdi Oturak on 15.04.2025.
//

import SwiftUI

struct TaskListView: View {
    
    // Edit sayfası için oluşturduğumuz değişkenler
    @State private var selectedTask: TaskModel?
    @State private var isEditing: Bool = false
    
    // Core Data'dan context'i alıyoruz.
    @Environment(\.managedObjectContext) var context
    //viewModel oluşturuldu.
    @StateObject private var viewModel: TaskViewModel
    // yeni görev ekleme için kullanılan değişkenler
    @State private var newTaskTitle: String = ""
    @State private var newTaskDate: Date = Date()
    @State private var selectedCategory: String = "İş"
    
    // kullanıcıya kaydetme bildirimi için
    @State private var showSuccessAlert = false
    
    @State private var  categories: [String] = ["İş","Kişisel","Sağlık","Eğitim","Alışveriş","Eğlence"]
    
    @State private var filteredCategories: [String] = []
    
    @State private var selectedFilterCategory: String = "Tüm Kategoriler"
    
    // varsayılan görev saati
    @State private var selectedReminderOffSet: TimeInterval = 0
    
    let reminderOptions: [(label: String, offset: TimeInterval) ] = [
        ("Görev saatinde", 0),
        ("5 dakika önce", -300),
        ("15 dakika önce ", -900),
        ("1 saat önce ", -3600)
        
    ]
        

    
    // haftalık istatistik verilere ulaşmak için
    @State private var ShowStats = false
    
    @State private var ShowSounds = false
   
    private var filteredTasks: [TaskModel] {
        let preliminaryTasks: [TaskModel]
        
        if selectedFilterCategory == "Tüm Kategoriler" {
            preliminaryTasks = viewModel.tasks
        } else if selectedFilterCategory == "Sadece Favoriler" {
            preliminaryTasks = viewModel.tasks.filter { $0.isFavorite }
        } else {
            preliminaryTasks = viewModel.tasks.filter { $0.category == selectedFilterCategory }
        }
        
        return preliminaryTasks.sorted { first, second in
            if first.isFavorite && !second.isFavorite {
                return true
            } else if !first.isFavorite && second.isFavorite {
                return false
            } else {
                return first.date < second.date
            }
        }
    }

    
    //viewModel'i init ile bağla
    init() {
        //Core Data contexxt App içinde environment ile verilecek
        let context = PersistenceController.shared.container.viewContext
        _viewModel = StateObject(wrappedValue: TaskViewModel(context: context))
        
        _filteredCategories = State(initialValue: ["Tüm Kategoriler","Sadece Favoriler","İş","Kişisel","Sağlık","Eğitim","Alışveriş","Eğlence"])
    }
    
    var body: some View {
        
        NavigationView {
            ZStack {
                Color.blue.opacity(0.15)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack {
                        //Görev ekleme alanı
                        
                        HStack {
                            Button(action: {
                                ShowStats.toggle()
                            }) {
                                Text("Haftalık İstatistik")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.blue)
                                    .cornerRadius(10)
                                    .shadow(radius: 5)
                            }
                            .padding(.horizontal)
                        }
                        .frame(maxWidth: .infinity, alignment: .bottomTrailing)
                        VStack {
                            
                            
                            TextField("Yeni görev..", text: $newTaskTitle)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .frame(width: 330)
                                .padding()
                                
                            
                            HStack {
                                
                                HStack {
                                    Text("Kategori:")
                                        .frame(width: 70,alignment: .leading)
                                        
                                    
                                    
                                    
                                    Picker("",selection: $selectedCategory) {
                                        ForEach(categories, id: \.self) { category in
                                            Text(category)
                                        }
                                    }
                                    .pickerStyle(MenuPickerStyle()) // açılır menü
                                    .background(Color(.systemGray6))
                                    .cornerRadius(10)
                                    
                                    Spacer()
                                }
                                .frame(width: 200, height: 50)
                                
                                HStack {
                                    Button(action: {
                                        ShowSounds.toggle()
                                    }) {
                                        Text("Bildirim Sesi")
                                            .frame(width: 120,height: 35)
                                            .background(Color.blue)
                                            .foregroundColor(Color.white)
                                            .cornerRadius(10)
                                            
                                    }
                                }
                                .frame(width: 110, alignment: .bottomTrailing)
                                
                            }
                            //.background(Color.blue.opacity(0.25))
                            .frame(width: 350)
                            
                            HStack {
                                HStack {
                                    DatePicker("Tarih:",selection: $newTaskDate,displayedComponents: [.date,.hourAndMinute])
                                        .frame(maxWidth:.infinity,alignment: .leading)
                                    
                                }
                                .frame(width:250)
                                
                                Spacer()
                            }
                            .padding()
                            .frame(width: 350)
                            
                            
                            HStack {
                                Text("Hatırlatma Zamanı :")
                                
                                Picker("",selection: $selectedReminderOffSet) {
                                    ForEach(reminderOptions, id: \.offset) { option in
                                        Text(option.label).tag(option.offset)
                                    }
                                }
                                .pickerStyle(MenuPickerStyle())
                                
                            }
                            .frame(width: 350)
                            
                            
                            
                            Button(action: {
                                if !newTaskTitle.isEmpty {
                                    viewModel.addTask(title: newTaskTitle, date: newTaskDate, category: selectedCategory, reminderOffset: selectedReminderOffSet)
                                    
                                    
                                    // bildirimi zamanlama
                                    
                                    NotificationManager.scheduleNotification(
                                        title: "Görevin Zamanı Geldi!",
                                        body: newTaskTitle,
                                        date: newTaskDate,
                                        reminderOffSet: selectedReminderOffSet
                                    )
                                    // formu sıfırlama
                                    newTaskTitle = ""
                                    
                                    // alerti tetikleme
                                    showSuccessAlert = true
                                }
                            }) {
                                Text("Ekle")
                                    .frame(width: 130,height: 35)
                                    .background(Color.blue)
                                    .foregroundColor(Color.white)
                                    .cornerRadius(10)
                                    
                            }
                            
                        }
                        .frame(width: 350, height: 330)
                        .cornerRadius(10)
                        .background(Color.blue.opacity(0.1))
                        .padding(10)
                        
                        //görevleri listele
                        MotivationBannerView()
                        
                        
                        
                        
                        HStack {
                            Text("Kategoriye göre filtrele:")
                                .frame(width: 180)
                                
                            Picker("Kategori", selection: $selectedFilterCategory) {
                                ForEach(filteredCategories, id: \.self) { category in
                                    Text(category)
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .center)
                            .pickerStyle(MenuPickerStyle())

                        }
                        .frame(width: 350)
                        List {
                            ForEach(filteredTasks) { task in
                                TaskRowView(task: task, viewModel: viewModel)
                                    .listRowBackground(Color.blue.opacity(0.1))
                                    .onTapGesture {
                                        self.selectedTask = task
                                        self.isEditing = true
                                    }
                                   
                            }
                            .onDelete { IndexSet in
                                IndexSet.forEach { index in
                                    let task = filteredTasks[index]
                                    viewModel.deleteTask(task)
                                }
                            }
                        }
                        .frame(width: 400,height: 300)
                        .scrollContentBackground(.hidden)
                        .cornerRadius(10)
                        
                        //reklamı gösterdiğimiz yer
                        BannerAdView(adUnitID: "ca-app-pub-3940256099942544/2934735716")
                            .frame(width: 320, height: 50)
                            .padding(.top)
                        
                    }
                    .navigationTitle("GünlükFlow")
                    .sheet(isPresented: $ShowStats) {
                        StaticsView(viewModel: viewModel)
                    }
                    .sheet(isPresented: $isEditing, content: {
                        if let taskToEdit = selectedTask {
                            EditTaskView(viewModel: viewModel, task: taskToEdit)
                        }
                    })
                    .sheet(isPresented: $ShowSounds) {
                        SoundPickerView()
                    }
                    .alert("Başarılı!", isPresented: $showSuccessAlert) {
                        Button("Tamam", role: .cancel) {
                            
                        }
                    } message: {
                        Text("Yeni görev eklendi.")
                    }
                }
            }
        }
    }

}

#Preview {
    TaskListView()
}
