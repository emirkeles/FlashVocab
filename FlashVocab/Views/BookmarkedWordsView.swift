//
//  BookmarkedWordsView.swift
//  FlashVocab
//
//  Created by Emir Keleş on 25.08.2024.
//

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
