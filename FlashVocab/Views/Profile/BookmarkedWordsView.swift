//
//  BookmarkedWordsView.swift
//  FlashVocab
//
//  Created by Emir Keleş on 25.08.2024.
//

import SwiftUI
import SwiftData
import FirebaseAnalytics

struct BookmarkedWordsView: View {
    @Query(FetchDescriptor(predicate: #Predicate<Word> { $0.bookmarked }, sortBy: [SortDescriptor<Word>(\.english)]))
    private var bookmarkedWords: [Word]
    @State private var selectedWord: Word?
    @State private var searchText: String = ""
    
    var body: some View {
        Group {
            if filteredItems.isEmpty {
                emptyStateView
            } else {
                wordList
            }
        }
        .navigationTitle("Yer İşaretli Kelimeler")
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Kelime ara")
        .sheet(item: $selectedWord) { word in
            WordDetailView(word: word)
        }
        .analyticsScreen(name: "Bookmarked Words")
    }
    
    private var emptyStateView: some View {
        ContentUnavailableView {
            Label("Kelime bulunamadı", systemImage: "book.fill")
        } description: {
            Text(searchText.isEmpty ? "Hiç kelime eklenmemiş" : "Arama sonucu bulunamadı")
        }
    }
    
    private var wordList: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(filteredItems) { word in
                    WordCard(word: word)
                        .onTapGesture {
                            selectedWord = word
                        }
                }
            }
            .padding()
        }
    }
    
    private var filteredItems: [Word] {
        if searchText.isEmpty {
            return bookmarkedWords
        } else {
            return bookmarkedWords.filter { word in
                word.english.lowercased().contains(searchText.lowercased()) ||
                word.turkish.lowercased().contains(searchText.lowercased())
            }
        }
    }
}
