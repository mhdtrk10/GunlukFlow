//
//  TaskRowView.swift
//  GunlukFlow
//
//  Created by Mehdi Oturak on 15.04.2025.
//

import SwiftUI
// Bir görevi liste üzerinde gösteren satırın view'i
struct TaskRowView: View {
    
    let task: TaskModel
    let viewModel: TaskViewModel
    
    var body: some View {
        HStack {
            //tamamlandı mı ikon
            Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                .onTapGesture {
                    viewModel.toggleTask(task)
                }
                .foregroundColor(task.isCompleted ? .green : .gray)
            
            VStack(alignment: .leading) {
                //başlık (üstü çizgili veya normal) ve kategori
                Text(task.title)
                    .strikethrough(task.isCompleted, color: .gray)
                    .font(.headline)
                
                HStack(spacing: 6) {
                    
                    Text(task.category)
                        .font(.caption)
                        .padding(.horizontal,8)
                        .padding(.vertical,4)
                        .background(categoryColor(task.category))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    
                    Text(reminderOffSetDescription(task.reminderOffset))
                        .font(.caption2)
                        .foregroundColor(Color.gray)
                    
                    Text(formatDate(task.date))
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                Spacer()
                
                Image(systemName: task.isFavorite ? "star.fill" : "star")
                    .foregroundColor(task.isFavorite ? .yellow : .gray)
                    .onTapGesture {
                        viewModel.toggleFavorite(task)
                    }
            }
            .padding(.vertical,6)
        }
        
        .padding(.vertical,6)
    }
    func categoryColor(_ category: String) -> Color {
        switch category {
            case "İş":
            return .blue
        case "Kişisel":
            return .orange
        case "Sağlık":
            return .green
        case "Eğitim":
            return .purple
        case "Alışveriş":
            return .pink
        case "Eğlence":
            return .cyan
        default:
            return .gray
            
        }
    }
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    func reminderOffSetDescription(_ offset: TimeInterval) -> String {
        switch offset {
        case 0: return "Zamanında hatırlatır"
        case -300: return "5 dakika önce hatırlatır"
        case -900: return "15 dk önce hatırlatır"
        case -3600: return "1 saat önce hatırlatır"
        default:
            let dakika = Int(abs(offset) / 60)
            return "\(dakika) dakika önce hatırlatır"
        }
    }
    
}


