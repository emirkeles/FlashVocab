//
//  ProfileView.swift
//  FlashVocab
//
//  Created by Emir Keleş on 25.07.2024.
//

import SwiftUI
import SwiftData

struct ProfileView: View {
    var body: some View {
        List {
            NavigationLink("Bildiğim kelimeler") {
                IsKnownView(isKnown: true, navigationTitle: "Bildiğim Kelimeler")
            }
            NavigationLink("Bilmediğim Kelimeler") {
                IsKnownView(isKnown: false, navigationTitle: "Bilmediğim Kelimeler")
            }
        }
        .navigationTitle("Profil")
    }
}
struct IsKnownView: View {
    var isKnown: Bool
    var navigationTitle: String
    @Namespace private var namespace
    @Query
    var items: [Word]
    @State private var words: [Word] = []
    var body: some View {
        Group {
            if items.isEmpty {
                emptyStateView
            } else {
                wordList
            }
        }
        .navigationTitle(navigationTitle)
        .onAppear {
            sortWords(for: isKnown)
        }
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
                ForEach(words) { word in
                    wordRow(word, isKnown: true)
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
            if let index = words.firstIndex(where: { $0.id == word.id }) {
                words.remove(at: index)
                word.isKnown.toggle()
            }
        }
    }
    
    private func sortWords(for isKnown: Bool) {
        if isKnown {
            words = items.filter { $0.isKnown }
        } else {
            words = items.filter { !$0.isKnown }
        }
    }

}
