//
//  SoundPickerView.swift
//  GunlukFlow
//
//  Created by Mehdi Oturak on 23.04.2025.
//

import SwiftUI
import AVFoundation

struct SoundPickerView: View {
    
    @Environment(\.dismiss) var dismiss
    @State private var searchText = ""
    @State private var selectedSound: String = UserDefaults.standard.string(forKey: "selectedSound") ?? "kus.caf"
    
    @State private var audioPlayer: AVAudioPlayer?
    
    let sounds: [SoundModel] = [
        SoundModel(name: "Kuş Sesi", fileName: "kussesi.caf"),
        SoundModel(name: "Big Alarm", fileName: "bigalarm.caf"),
        SoundModel(name: "Piyano", fileName: "piano.caf"),
        SoundModel(name: "Doğa Sesi", fileName: "nature.caf"),
        SoundModel(name: "Komik alarm", fileName: "funnyalarm.caf"),
        SoundModel(name: "Komik Kazak", fileName: "kazakalarm.caf")
    ]
    
    var filteredSounds: [SoundModel] {
        if searchText.isEmpty {
            return sounds
        } else {
            return sounds.filter { $0.name.localizedStandardContains(searchText) }
        }
    }
    
    
    var body: some View {
        NavigationView {
            ZStack {
                
                Color.blue.opacity(0.15)
                    .ignoresSafeArea()
                
                List {
                    ForEach(filteredSounds) { sound in
                        HStack {
                            Text(sound.name)
                                
                            Spacer()
                            if sound.fileName == self.selectedSound {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                        .listRowBackground(Color.blue.opacity(0.1))
                        .contentShape(Rectangle())
                        .onTapGesture {
                            // ses önizleme
                            playSound(name: sound.fileName)
                            
                            // seçilen sesi kaydetmen
                            selectedSound = sound.fileName
                            UserDefaults.standard.set(sound.fileName, forKey: "selectedSound")
                            
                            // ekranı kapama
                            //dismiss()
                        }
                    }
                }
                .scrollContentBackground(.hidden)
                .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Ses ara..")
                .navigationTitle("Bildirim Sesi Seç")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button(action: {
                            dismiss()
                        }) {
                            Text("Kapat")
                                .frame(width: 90,height: 30)
                                .background(Color.blue)
                                .foregroundColor(Color.white)
                                .cornerRadius(10)
                        }
                    }
                }
            }
        }
        
    }
    
    func playSound(name fileName: String) {
        
        if let player = audioPlayer, player.isPlaying {
            player.stop()
        }
        
        if let url = Bundle.main.url(forResource: fileName.replacingOccurrences(of: ".caf", with: ""), withExtension: "caf") {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.prepareToPlay()
                audioPlayer?.play()
            } catch {
                print("Ses çalınamadı: \(error.localizedDescription)")
            }
        }
    }
}

#Preview {
    SoundPickerView()
}
