//
//  SoundModel.swift
//  GunlukFlow
//
//  Created by Mehdi Oturak on 23.04.2025.
//

import Foundation

struct SoundModel: Identifiable {
    
    // kullanıcının seçebileceği bildirim sesi için
    
    // listelemelerde kolaylık için
    let id = UUID()
    
    // gösterilecek isim
    let name: String
    
    // .caf dosyası adı
    let fileName: String
    
}
