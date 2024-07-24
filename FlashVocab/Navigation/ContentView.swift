//
//  ContentView.swift
//  FlashVocab
//
//  Created by Emir Keleş on 17.07.2024.
//

import SwiftUI
import SwiftData
import SwiftfulUI

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query
    private var items: [Word]
    
    var body: some View {
        
        TabView {
            NavigationStack {
                FlashCardsView()
            }
            .tabItem {
                Label("Menu", systemImage: "list.dash")
            }
            NavigationStack {
                ProfileView()
            }
            .tabItem { Label("Profil", systemImage: "person.circle") }
            NavigationStack {
                SettingsView()
            }
            .tabItem { Label("Settings", systemImage: "gear") }
        }
    }
}


struct IsKnownView: View {
    @Namespace private var namespace
    @Query
    var items: [Word]
    @State private var knownWords: [Word] = []
    @State private var unknownWords: [Word] = []
    var body: some View {
        Group {
            if items.isEmpty {
                emptyStateView
            } else {
                wordList
            }
        }
        .navigationTitle("Kelimelerim")
        .onAppear(perform: sortWords)
    }
    
    private func markAsUnknown(_ word: Word) {
        withAnimation {
            word.isKnown.toggle()
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
                Section(header: Text("Bildiğim Kelimeler")) {
                    ForEach(knownWords) { word in
                        wordRow(word, isKnown: true)
                    }
                }
                
                Section(header: Text("Bilmediğim Kelimeler")) {
                    ForEach(unknownWords) { word in
                        wordRow(word, isKnown: false)
                    }
                }
            }
        }
    
    private func wordRow(_ word: Word, isKnown: Bool) -> some View {
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
    
    private func toggleKnownStatus(_ word: Word) {
            withAnimation {
                if let index = knownWords.firstIndex(where: { $0.id == word.id }) {
                    knownWords.remove(at: index)
                    unknownWords.append(word)
                } else if let index = unknownWords.firstIndex(where: { $0.id == word.id }) {
                    unknownWords.remove(at: index)
                    knownWords.append(word)
                }
                word.isKnown.toggle()
            }
        }
    
    private func sortWords() {
        knownWords = items.filter { $0.isKnown }
        unknownWords = items.filter { !$0.isKnown }
    }

}

struct ProfileView: View {
    var body: some View {
        List {
            NavigationLink("Kelimelerim") {
                IsKnownView()
            }
        }
        .navigationTitle("Profil")
    }
}
