//
//  ProfileView.swift
//  FlashVocab
//
//  Created by Emir Keleş on 25.07.2024.
//

import SwiftUI
import SwiftData

import SwiftUI
import SwiftData

struct BookmarkedWordsView: View {
    @Query(FetchDescriptor(predicate: #Predicate<Word> { $0.bookmarked }, sortBy: [SortDescriptor<Word>(\.english)]))
    private var bookmarkedWords: [Word]
    
    var body: some View {
        List(bookmarkedWords) { word in
            VStack(alignment: .leading) {
                Text(word.english)
                    .font(.headline)
                Text(word.turkish)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .navigationTitle("Yer İşaretli Kelimeler")
    }
}

struct ProfileView: View {
    @Query
    private var appstates: [AppState]
    
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
                
                Section(header: Text("Sistem Bilgileri")) {
                    NavigationLink("AppStates") {
                        List {
                            ForEach(appstates) { appstate in
                                Text("Son Kart Indeksi: \(appstate.lastCardIndex)")
                            }
                        }
                    }
                }
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

struct IsKnownView: View {
    var isKnown: Bool
    var navigationTitle: String
    @Namespace private var namespace
    @Query
    var items: [Word]
    @State private var selectedWord: Word?
    
    init(isKnown: Bool, navigationTitle: String) {
        self.isKnown = isKnown
        self.navigationTitle = navigationTitle
        let predicate = #Predicate<Word> { word in
            word.isKnown == isKnown
        }
        let descriptor = FetchDescriptor<Word>(predicate: predicate, sortBy: [SortDescriptor<Word>(\.index)])
        _items = Query(descriptor)
    }
    
    var body: some View {
        Group {
            if items.isEmpty {
                emptyStateView
            } else {
                wordList
            }
        }
        .navigationTitle(navigationTitle)
        .sheet(item: $selectedWord) { word in
            WordDetailView(word: word)
        }
       
    }
    
    private func markAsUnknown(_ word: Word) {
        withAnimation {
            word.isKnown?.toggle()
        }
        
    }
    
    private var emptyStateView: some View {
            VStack {
                GroupBox {
                    ContentUnavailableView("Hiç kelime bulunamadı", systemImage: "book.fill")
                }
                .padding()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }
    
    private var wordList: some View {
            List {
                ForEach(items) { word in
                    wordRow(word, isKnown: true)
                        .onTapGesture {
                            selectedWord = word
                        }
                }
            }
        }
    
    private func wordRow(_ word: Word, isKnown: Bool) -> some View {
        HStack {
            Text(word.english)
                .id(word.id)
                .transition(.asymmetric(insertion: .scale.combined(with: .opacity),
                                        removal: .scale.combined(with: .opacity)))
                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                    Button(role: isKnown ? .destructive : .destructive) {
                        toggleKnownStatus(word)
                    } label: {
                        Label(isKnown ? "Bilmiyorum" : "Biliyorum", systemImage: isKnown ? "xmark" : "checkmark")
                            .foregroundColor(isKnown ? .red : .green)
                    }
                    .tint(isKnown ? .red : .green)
                }
        }
        }
    
    private func toggleKnownStatus(_ word: Word) {
        withAnimation {
            word.isKnown?.toggle()
        }
    }

}

struct WordDetailView: View {
    let word: Word
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Temel Bilgiler")) {
                    detailRow(title: "İngilizce", value: word.english)
                    detailRow(title: "Türkçe", value: word.turkish)
                    detailRow(title: "Cümle", value: word.sentence)
                }
                
                Section(header: Text("Öğrenme Durumu")) {
                    detailRow(title: "Durum", value: word.isKnown == true ? "Biliniyor" : "Bilinmiyor")
                    detailRow(title: "Tekrar Sayısı", value: "\(word.reviewCount)")
                    if let learnedDate = word.learnedDate {
                        detailRow(title: "Öğrenme Tarihi", value: formatDate(learnedDate))
                    }
                    if let lastReviewDate = word.lastReviewDate {
                        detailRow(title: "Son Tekrar Tarihi", value: formatDate(lastReviewDate))
                    }
                    if let nextReviewDate = word.nextReviewDate {
                        detailRow(title: "Sonraki Tekrar Tarihi", value: formatDate(nextReviewDate))
                    }
                }
                
                Section(header: Text("Diğer")) {
                    detailRow(title: "Yer İmi", value: word.bookmarked ? "Evet" : "Hayır")
                }
            }
            .navigationTitle("Kelime Detayları")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func detailRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
            Spacer()
            Text(value)
                .foregroundColor(.secondary)
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
