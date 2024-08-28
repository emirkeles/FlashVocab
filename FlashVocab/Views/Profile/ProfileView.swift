//
//  ProfileView.swift
//  FlashVocab
//
//  Created by Emir Keleş on 25.07.2024.
//

import SwiftUI
import SwiftData

struct ProfileView: View {
    @Query private var appStates: [AppState]
    @Query private var items: [Word]
    @Query private var quizs: [Quiz]
    @Query private var questions: [QuizQuestion]
    @Environment(\.modelContext) private var modelContext
    @State private var deleteAlert = false
    @State private var showingLearningProgress = false
    @AppStorage("currentWordVersion") var currentWordVersion = 0
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                wordLists
                deleteDataButton
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Profil")
        .navigationBarTitleDisplayMode(.large)
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
            Alert(title: Text("Bütün Verileri Sil"),
                  message: Text("Bütün verileri sileceğinizden emin misiniz"),
                  primaryButton: .destructive(Text("Sil"), action: deleteAllData),
                  secondaryButton: .cancel())
        }
        
    }
    private var userHeader: some View {
        VStack {
            Image(systemName: "person.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .foregroundColor(.blue)
            Text("Kullanıcı Adı")
                .font(.title2)
                .fontWeight(.bold)
            Text("Toplam Kelime: \(items.count)")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
    
    private var wordLists: some View {
        VStack(spacing: 15) {
            navigationCard(title: "Bildiğim Kelimeler", icon: "checkmark.circle.fill", color: .green) {
                IsKnownView(isKnown: true, navigationTitle: "Bildiğim Kelimeler")
            }
            navigationCard(title: "Bilmediğim Kelimeler", icon: "xmark.circle.fill", color: .red) {
                IsKnownView(isKnown: false, navigationTitle: "Bilmediğim Kelimeler")
            }
            navigationCard(title: "Yer İşaretli Kelimeler", icon: "bookmark.fill", color: .blue) {
                BookmarkedWordsView()
            }
            navigationCard(title: "Detaylı İstatistikler", icon: "chart.bar.fill", color: .purple) {
                StatisticsView()
            }
            navigationCard(title: "Bildirim Ayarları", icon: "bell.fill", color: .orange) {
                NotificationSettingsView()
            }
        }
    }
    
    private var deleteDataButton: some View {
        Button(action: { deleteAlert = true }) {
            Label("Bütün Verileri Sil", systemImage: "trash.fill")
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.red)
                .cornerRadius(10)
        }
    }
    
    private func navigationCard<Destination: View>(title: String, icon: String, color: Color, destination: @escaping () -> Destination) -> some View {
        NavigationLink(destination: destination) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                    .font(.title2)
                Text(title)
                    .fontWeight(.medium)
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
            .padding()
            .background(Color(.secondarySystemGroupedBackground))
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func deleteAllData() {
        for item in items { modelContext.delete(item) }
        for appstate in appStates { modelContext.delete(appstate) }
        for question in questions { modelContext.delete(question) }
        for quiz in quizs { modelContext.delete(quiz) }
        currentWordVersion = 0
        
        loadNewData()
    }
    
    private func loadNewData() {
        do {
            guard let url = Bundle.main.url(forResource: "words", withExtension: "json") else {
                fatalError("Failed to find words.json")
            }
            let data = try Data(contentsOf: url)
            let wordVersion = try JSONDecoder().decode(WordVersion.self, from: data)
            
            for wordData in wordVersion.words {
                let newWord = Word(index: wordData.index,
                                   english: wordData.english,
                                   turkish: wordData.turkish,
                                   sentence: wordData.sentence,
                                   phonetic: wordData.phonetic,
                                   partOfSpeech: wordData.partOfSpeech,
                                   englishMeanings: wordData.englishMeanings)
                modelContext.insert(newWord)
            }
            
            currentWordVersion = wordVersion.version
            print("Yeni veriler başarıyla yüklendi. Yeni versiyon: \(currentWordVersion)")
        } catch {
            print("Yeni verileri yükleme sırasında hata oluştu: \(error)")
        }
    }
}
