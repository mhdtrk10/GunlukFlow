//
//  TaskListView.swift
//  GunlukFlow
//
//  Created by Mehdi Oturak on 15.04.2025.
//

import SwiftUI

struct TaskListView: View {
    
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
    
    let categories = ["İş","Kişisel","Sağlık","Eğitim","Alışveriş","Eğlence"]
    
    @State private var selectedFilterCategory: String = "Tüm Kategoriler"
    let filterCagetories = ["Tüm Kategoriler"]+["İş","Kişisel","Sağlık","Eğitim","Alışveriş","Eğlence"]
    
    // haftalık istatistik verilere ulaşmak için
    @State private var ShowStats = false
    
    @State private var ShowSounds = false
   
    //viewModel'i init ile bağla
    init() {
        //Core Data contexxt App içinde environment ile verilecek
        let context = PersistenceController.shared.container.viewContext
        _viewModel = StateObject(wrappedValue: TaskViewModel(context: context))
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
                                Label("Haftalık İstatistik",systemImage: "char.bar.xaxis")
                            }
                            .buttonStyle(.borderedProminent)
                            .padding(.horizontal)
                        }
                        .frame(maxWidth: .infinity, alignment: .bottomTrailing)
                        VStack {
                            
                            
                            TextField("Yeni görev..", text: $newTaskTitle)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .frame(width: 340)
                                .padding()
                                
                            
                            HStack {
                                
                                HStack {
                                    Text("Kategori:")
                                        .frame(width: 70,alignment: .leading)
                                    
                                    
                                    
                                    Picker("Kategori",selection: $selectedCategory) {
                                        ForEach(categories, id: \.self) { category in
                                            Text(category)
                                        }
                                    }
                                    .pickerStyle(MenuPickerStyle()) // açılır menü
                                    .background(Color(.systemGray6))
                                    .cornerRadius(10)
                                    
                                    Spacer()
                                }
                                .frame(width: 200)
                                
                                
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
                                .frame(width: 120, alignment: .bottomTrailing)
                                
                            }
                            .frame(width: 350)
                            
                            HStack {
                                DatePicker("Tarih:",selection: $newTaskDate,displayedComponents: [.date,.hourAndMinute])
                                    .frame(maxWidth:.infinity,alignment: .leading)
                                    
                            }
                            .frame(width:250)
                                
                            Button(action: {
                                if !newTaskTitle.isEmpty {
                                    viewModel.addTask(title: newTaskTitle, date: newTaskDate, category: selectedCategory)
                                    
                                    
                                    // bildirimi zamanlama
                                    
                                    NotificationManager.scheduleNotification(
                                        title: "Görevin Zamanı Geldi!",
                                        body: newTaskTitle,
                                        date: newTaskDate
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
                        .frame(width: 350, height: 300)
                        .cornerRadius(10)
                        .background(Color.blue.opacity(0.1))
                        .padding(10)
                        .alert("Başarılı!", isPresented: $showSuccessAlert) {
                            Button("Tamam", role: .cancel) {
                                
                            }
                        } message: {
                            Text("Yeni görev eklendi.")
                        }
                        //görevleri listele
                        MotivationBannerView()
                        
                        
                        
                        let filteredTasks = selectedFilterCategory == "Tüm Kategoriler" ?
                            viewModel.tasks :
                            viewModel.tasks.filter { $0.category == selectedFilterCategory }
                        
                        HStack {
                            Text("Kategoriye göre filtrele:")
                                .frame(width: 180)
                                
                            Picker("Kategori", selection: $selectedFilterCategory) {
                                ForEach(filterCagetories, id: \.self) { category in
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
                    .sheet(isPresented: $ShowSounds) {
                        SoundPickerView()
                    }
                    
                }
            }
        }
    }

}

#Preview {
    TaskListView()
}
