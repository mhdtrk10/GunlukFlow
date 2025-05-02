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
        HStack(alignment: .top, spacing: 10) {
            
            Rectangle()
                .fill(colorForCategory(task.category))
                .frame(width: 5)
                .cornerRadius(2)
            
            
            
            VStack(alignment: .leading,spacing: 6) {
                
                //başlık (üstü çizgili veya normal) ve kategori
                
                Text(task.category)
                    .font(.caption)
                    .padding(.horizontal,8)
                    .padding(.vertical,4)
                    .background(categoryColor(task.category))
                    .foregroundColor(.white)
                    .cornerRadius(8)
                
                Text(task.title)
                    .foregroundColor(task.isCompleted ? .gray : .primary)
                    .strikethrough(task.isCompleted, color: .gray)
                    .font(.headline)
                
                HStack {
                    
                   
                    
                    Text(reminderOffSetDescription(task.reminderOffset))
                        .font(.caption2)
                        .foregroundColor(Color.gray)
                    
                    Text(formatDate(task.date))
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                // tamamlandı butonu
                
            }
            .padding(.vertical,4)
            .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 2)
            .cornerRadius(10)
            
            Spacer()
            
            Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                .foregroundColor(task.isCompleted ? .green : .gray)
                .onTapGesture {
                    viewModel.toggleTask(task)
                }
            // favori butonu
            Image(systemName: task.isFavorite ? "star.fill" : "star")
                .foregroundColor(task.isFavorite ? .yellow : .gray)
                .onTapGesture {
                    viewModel.toggleFavorite(task)
                }
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
    func colorForCategory(_ category: String) -> Color {
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
        default:
            return .gray
        }
    }
}


