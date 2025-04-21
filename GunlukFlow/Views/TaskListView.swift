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
    
    let categories = ["İş","Kişisel","Sağlık","Eğitim","Alışveriş","Eğlence"]
    
    @State private var selectedFilterCategory: String = "Tüm Kategoriler"
    let filterCagetories = ["Tüm Kategoriler"]+["İş","Kişisel","Sağlık","Eğitim","Alışveriş","Eğlence"]
    
    // haftalık istatistik verilere ulaşmak için
    @State private var ShowStats = false
    
   
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
                    .ignoresSafeArea(edges: .all)
                
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
                                .frame(width: 300)
                                
                            
                            HStack {
                                Text("Kategori:")
                                    .frame(maxWidth:90,alignment: .leading)
                                
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
                            .frame(width: 250)
                            HStack {
                                DatePicker("Tarih:",selection: $newTaskDate,displayedComponents: [.date,.hourAndMinute])
                                    .frame(maxWidth:.infinity,alignment: .leading)
                                    
                            }
                            .frame(width:250)
                                
                            Button(action: {
                                if !newTaskTitle.isEmpty {
                                    viewModel.addTask(title: newTaskTitle, date: newTaskDate, category: selectedCategory)
                                    newTaskTitle = ""
                                }
                            }) {
                                Text("Ekle")
                                    .frame(width: 130,height: 35)
                                    .background(Color.blue)
                                    .foregroundColor(Color.white)
                                    .cornerRadius(10)
                            }
                        }
                        .frame(width: 350, height: 250)
                        .cornerRadius(10)
                        .background(Color.blue.opacity(0.1))
                        .padding(10)
                        
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
                        
                        BannerAdView(adUnitID: "ca-app-pub-3940256099942544/2934735716")
                            .frame(width: 320, height: 50)
                            .padding(.top)
                        
                    }
                    .navigationTitle("GünlükFlow")
                    .sheet(isPresented: $ShowStats) {
                        StaticsView(viewModel: viewModel)
                    }
                }
            }
        }
    }

}

#Preview {
    TaskListView()
}
