//
//  ProfileView.swift
//  FlashVocab
//
//  Created by Emir Keleş on 25.07.2024.
//

import SwiftUI
import SwiftData
import MessageUI

struct ProfileView: View {
    @Query private var appStates: [AppState]
    @Query private var items: [Word]
    @Query private var quizs: [Quiz]
    @Query private var questions: [QuizQuestion]
    @Environment(\.modelContext) private var modelContext
    @State private var showingDeleteAlert = false
    @State private var showingLearningProgress = false
    @AppStorage("currentWordVersion") var currentWordVersion = 0
    @State private var isShowingMailView = false
    @State private var showingMailErrorAlert = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                sectionView(title: "Kelime Listeleri") {
                    navigationCard(title: "Bildiğim Kelimeler", icon: "checkmark.circle.fill", color: .green) {
                        IsKnownView(isKnown: true, navigationTitle: "Bildiğim Kelimeler")
                    }
                    Divider()
                    navigationCard(title: "Bilmediğim Kelimeler", icon: "xmark.circle.fill", color: .red) {
                        IsKnownView(isKnown: false, navigationTitle: "Bilmediğim Kelimeler")
                    }
                    Divider()
                    navigationCard(title: "Yer İşaretli Kelimeler", icon: "bookmark.fill", color: .blue) {
                        BookmarkedWordsView()
                    }
                }
                
                sectionView(title: "İstatistikler ve Ayarlar") {
                    navigationCard(title: "Detaylı İstatistikler", icon: "chart.bar.fill", color: .purple) {
                        StatisticsView()
                    }
                    Divider()
                    navigationCard(title: "Bildirim Ayarları", icon: "bell.fill", color: .orange) {
                        NotificationSettingsView()
                    }
                }
                
                sectionView(title: "Uygulama") {
                    feedbackButton
                    Divider()
                    deleteDataButton
                }
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Profil")
        .navigationBarTitleDisplayMode(.large)
        .alert("Bütün Verileri Sil", isPresented: $showingDeleteAlert) {
            Button("Sil", role: .destructive, action: deleteAllData)
            Button("İptal", role: .cancel) {}
        } message: {
            Text("Bütün verileri sileceğinizden emin misiniz?")
        }
        .sheet(isPresented: $showingLearningProgress) {
            NavigationView {
                LearningProgressView()
                    .navigationTitle("Öğrenme İlerlemesi")
                    .navigationBarItems(trailing: Button("Kapat") {
                        showingLearningProgress = false
                    })
            }
        }
        .sheet(isPresented: $isShowingMailView) {
            MailView(isShowing: $isShowingMailView, result: handleMailResult)
        }
        .alert(isPresented: $showingMailErrorAlert) {
            Alert(
                title: Text("E-posta Gönderilemedi"),
                message: Text("E-posta gönderme işlemi başarısız oldu. Lütfen e-posta ayarlarınızı kontrol edin veya daha sonra tekrar deneyin."),
                dismissButton: .default(Text("Tamam"))
            )
        }
    }
    
    private var deleteDataButton: some View {
        Button(action: {
            showingDeleteAlert = true
            print("Delete button tapped")
        }) {
            HStack {
                Image(systemName: "trash.fill")
                    .foregroundColor(.red)
                    .frame(width: 30, height: 30)
                Text("Bütün Verileri Sil")
                    .foregroundColor(.red)
                    .fontWeight(.medium)
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
            
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
        } catch {
            print("Yeni verileri yükleme sırasında hata oluştu: \(error)")
        }
    }
}

extension ProfileView {
    
    // MARK: - Header
    private var userHeader: some View {
        VStack(spacing: 10) {
            Image(systemName: "person.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 80, height: 80)
                .foregroundColor(.blue)
            Text("Kullanıcı Adı")
                .font(.title2)
                .fontWeight(.bold)
            Text("Öğrenilen Kelime: \(items.filter{ $0.isKnown == true }.count)")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
    
    // MARK: - Reusable Components
    private func sectionView<Content: View>(title: String, @ViewBuilder content: @escaping () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.headline)
                .padding(.horizontal)
            VStack(spacing: 10) {
                content()
            }
            .padding()
            .background(Color(.secondarySystemGroupedBackground))
            .cornerRadius(15)
        }
    }
    
    private func navigationCard<Destination: View>(title: String, icon: String, color: Color, destination: @escaping () -> Destination) -> some View {
        NavigationLink(destination: destination) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                    .font(.system(size: 20))
                    .frame(width: 30, height: 30)
                Text(title)
                    .fontWeight(.medium)
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
                    .font(.system(size: 14))
            }
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
            .background(Color.clear)
        }
        .buttonStyle(PlainButtonStyle())
    }
    // MARK: - Mail
    private func attemptToOpenMailApp() {
        if let url = URL(string: "mailto:16emirkeles@gmail.com") {
            UIApplication.shared.open(url) { success in
                if !success {
                    self.showingMailErrorAlert = true
                }
            }
        } else {
            self.showingMailErrorAlert = true
        }
    }
    
    private func handleMailResult(_ result: Result<MFMailComposeResult, Error>) {
        var resultString: String?
        switch result {
        case .success(let result):
            switch result {
            case .sent: resultString = "Gönderildi"
            case .saved: resultString = "Taslak"
            case .cancelled: resultString = "Iptal"
            case .failed:
                showingMailErrorAlert = true
                resultString = "Hata"
            @unknown default:
                resultString = "default"
                break
            }
        case .failure(_):
            showingMailErrorAlert = true
        }
        if let resultString = resultString {
            AnalyticsManager.shared.logFeedbackButtonTapped(result: resultString)
        }
    }
    
    private var feedbackButton: some View {
        Button(action: {
            if MFMailComposeViewController.canSendMail() {
                isShowingMailView = true
            } else {
                attemptToOpenMailApp()
            }
        }) {
            HStack {
                Image(systemName: "envelope.fill")
                    .foregroundColor(.blue)
                    .frame(width: 30, height: 30)
                Text("Geri Bildirim Gönder")
                    .fontWeight(.medium)
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
            
        }
        .buttonStyle(PlainButtonStyle())
    }
}
