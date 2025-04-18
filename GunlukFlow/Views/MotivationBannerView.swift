//
//  MotivationBannerView.swift
//  GunlukFlow
//
//  Created by Mehdi Oturak on 15.04.2025.
//

import SwiftUI
// motivasyon sözünü gösteren sade bir banner view
struct MotivationBannerView: View {
    //viewModel ile veri bağlar
    @StateObject private var viewModel = QuoteViewModel()
    var body: some View {
        VStack(alignment: .leading) {
            Text("Günün Sözü")
                .font(.headline)
                .foregroundColor(.secondary)
            if let quote = viewModel.currentQuote {
                Text("\(quote.text)")
                    .font(.body)
                    .italic()
                    .padding(.top,2)
            } else {
                Text("Söz yükleniyor...")
                    .font(.body)
                    .foregroundColor(.gray)
            }
        }
        .frame(width: 320)
        .padding()
        .background(Color.yellow.opacity(0.2))
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 2)
    }
}

#Preview {
    MotivationBannerView()
}
