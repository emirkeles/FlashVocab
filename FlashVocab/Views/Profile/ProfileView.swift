//
//  ProfileView.swift
//  FlashVocab
//
//  Created by Emir Keleş on 25.07.2024.
//

import SwiftUI
import SwiftData
import Charts

struct ProfileView: View {
    @Query
    private var appStates: [AppState]
    @State private var showingLearningProgress = false
    
    var body: some View {
        List {
            Section(header: Text("Kelime Listeleri")) {
                NavigationLink("Bildiğim kelimeler") {
                    IsKnownView(isKnown: true, navigationTitle: "Bildiğim Kelimeler")
                }
                NavigationLink("Bilmediğim Kelimeler") {
                    IsKnownView(isKnown: false, navigationTitle: "Bilmediğim Kelimeler")
                }
                NavigationLink("Yer İşaretli Kelimeler") {
                    BookmarkedWordsView()
                }
            }
#if DEBUG
            Section(header: Text("İlerleme")) {
                LearningProgressView()
                    .frame(height: 300)
                    .listRowInsets(EdgeInsets(top: 20, leading: 10, bottom: 20, trailing: 10))
                    .listRowSeparator(.hidden)
                
                HStack {
                    Button("Tam Ekran Göster") {
                        showingLearningProgress = true
                    }
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
#endif
            Section(header: Text("Detaylı İstatistikler")) {
                NavigationLink("İstatistiklerim") {
                    StatisticsView()
                }
            }
#if DEBUG
            Section(header: Text("Sistem Bilgileri")) {
                NavigationLink("AppStates") {
                    List {
                        ForEach(appStates) { appstate in
                            Text("Son Kart Indeksi: \(appstate.lastCardIndex)")
                        }
                    }
                }
            }
#endif
        }
        .navigationTitle("Profil")
        .sheet(isPresented: $showingLearningProgress) {
            NavigationView {
                LearningProgressView()
                    .navigationTitle("Öğrenme İlerlemesi")
                    .navigationBarItems(trailing: Button("Kapat") {
                        showingLearningProgress = false
                    })
            }
        }
    }
}

