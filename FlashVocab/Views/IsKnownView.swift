//
//  IsKnownView.swift
//  FlashVocab
//
//  Created by Emir Keleş on 25.08.2024.
//

import SwiftUI
import SwiftData

struct IsKnownView: View {
    var isKnown: Bool
    var navigationTitle: String
    @Query var items: [Word]
    @State private var selectedWord: Word?
    @State private var searchText = ""
    
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
                if filteredItems.isEmpty {
                    emptyStateView
                } else {
                    wordList
                }
            }
            .navigationTitle(navigationTitle)
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Kelime ara")
            .sheet(item: $selectedWord) { word in
                WordDetailView(word: word)
            }
        }
    
    private var filteredItems: [Word] {
            if searchText.isEmpty {
                return items
            } else {
                return items.filter { word in
                    word.english.lowercased().contains(searchText.lowercased()) ||
                    word.turkish.lowercased().contains(searchText.lowercased())
                }
            }
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
}

struct WordCard: View {
    let word: Word
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(word.english)
                    .font(.title2)
                    .fontWeight(.bold)
                Spacer()
                Text("(\(word.partOfSpeech))")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Text(word.englishMeanings.first ?? "")
                .font(.body)
            
            Text(word.sentence)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .padding(.top, 4)
            
            HStack {
                Text(word.learnedDate ?? Date(), style: .date)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Spacer()
                Button(action: {
                    withAnimation {
                        word.bookmarked.toggle()
                    }
                }) {
                    Image(systemName: word.bookmarked ? "bookmark.fill" : "bookmark")
                }
            }
            .padding(.top, 8)
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}
