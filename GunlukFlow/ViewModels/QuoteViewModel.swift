//
//  QuoteViewModel.swift
//  GunlukFlow
//
//  Created by Mehdi Oturak on 15.04.2025.
//

import Foundation
// motivasyon sözlerini yöneten viewModel
class QuoteViewModel: ObservableObject {
    // uygulamada gösterilecek aktif söz
    @Published var currentQuote: Quote?
    
    // tüm sözler(JSON'dan çekilecek)
    private var allQuotes: [Quote] = []
    
    init() {
        loadQuotes()
    }
    //JSON dosyasından tüm sözleri yükler ve bir tanesini seçer
    
    private func loadQuotes() {
        guard let url = Bundle.main.url(forResource: "MotivasyonSozleri", withExtension: "json") else {
            print("MotivasyonSozleri.json bulunamadı")
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let quotes = try JSONDecoder().decode([Quote].self, from: data)
            self.allQuotes = quotes
            pickRandomQuote()
        } catch {
            print("JSON parse hatası: \(error.localizedDescription)")
        }
    }
    // rastgele bir sözü seçip ekranda göstermek için currentQuote'a atar.
    func pickRandomQuote() {
        guard !allQuotes.isEmpty else { return }
        currentQuote = allQuotes.randomElement()
    }
}
