//
//  QuoteModel.swift
//  GunlukFlow
//
//  Created by Mehdi Oturak on 15.04.2025.
//

import Foundation
// motivasyon sözü modelini temsil eder
struct Quote: Identifiable, Codable {
    // her sözün benzersiz ID'si (jsondan geliyor)
    let id: Int
    
    // sözün metni
    let text: String
}
