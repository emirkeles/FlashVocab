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
    @Query private var items: [Word]
    @Query private var quizs: [Quiz]
    @Query private var questions: [QuizQuestion]
    @Environment(\.modelContext) private var modelContext
    @State private var deleteAlert = false

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
            
            Section("Verileri Temizle") {
                Button("Bütün Verileri Sil", role: .destructive) {
                    HapticFeedbackManager.shared.playSelection()
                    deleteAlert.toggle()
                }
                .buttonStyle(.borderless)
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
        .alert(isPresented: $deleteAlert) {
            Alert(title: Text("Bütün Verileri Sil"), message: Text("Bütün verileri sileceğinizden emin misiniz"), primaryButton: .destructive(Text("Sil"), action: {
                for item in items {
                    print("siliyom")
                    modelContext.delete(item)
                }
                for appstate in appStates {
                    modelContext.delete(appstate)
                }
                for question in questions {
                    modelContext.delete(question)
                }
                for quiz in quizs {
                    modelContext.delete(quiz)
                }
            }), secondaryButton: .cancel())
        }
    }
}
