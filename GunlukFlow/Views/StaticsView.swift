//
//  StaticsView.swift
//  GunlukFlow
//
//  Created by Mehdi Oturak on 18.04.2025.
//

import SwiftUI

struct StaticsView: View {
    
    @ObservedObject var viewModel: TaskViewModel
    
    
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Haftalık Tamamlanan Görevler")
                .font(.title2)
                .bold()
                .padding(.bottom)
            
            let weeklyData = viewModel.getWeeklyCompletionData()
            
            HStack(alignment: .bottom) {
                ForEach(weeklyData, id: \.day) { data in
                    VStack {
                        Text("\(data.count)")
                            .font(.caption)
                        RoundedRectangle(cornerRadius: 4)
                            .fill(data.count > 0 ? Color.green : Color.gray.opacity(0.3))
                            .frame(width: 20, height: CGFloat(data.count) * 15)
                        Text(data.day.prefix(3))
                            .font(.caption2)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.top)
        }
        .padding()
    }
}

#Preview {
    StaticsView(viewModel: TaskViewModel(context: PersistenceController.shared.container.viewContext))
}


