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
