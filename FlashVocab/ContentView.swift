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
    @Query(filter: #Predicate<Word>{ word in
        word.index >= 0
    }, sort: \Word.index)
    private var items: [Word]
    @State private var currentIndex = 0
    @State private var currentSwipeOffset: CGFloat = .zero
    @State private var cardOffsets: [String:Bool] = [:]
    
    var body: some View {
        NavigationStack {
            TabView {
                ZStack {
                    ForEach(Array(items.enumerated()), id: \.offset) { (index, word) in
                        let isPrevious = (currentIndex - 1) == index
                        let isCurrent = currentIndex == index
                        let isNext = (currentIndex + 1) == index
                        
                        if isPrevious || isCurrent || isNext {
                            let offsetValue = cardOffsets[word.english]
                            cardView(word: word, index: index)
                                .zIndex(Double(items.count - index))
                                .offset(x: offsetValue == nil ? 0 : offsetValue == true ? 900 : -900)
                            
                        }
                    }
                    OverlaySwipingIndicators(currentSwipeOffset: $currentSwipeOffset)
                                    .zIndex(999999)
                }
                .animation(.smooth, value: cardOffsets)
                .tabItem {
                    Label("Menu", systemImage: "list.dash")
                }
                Text("ayarlar")
                    .tabItem { Label("Settings", systemImage: "gear") }
                    .onAppear {
                        for i in items {
                            print("siliyom")
                            modelContext.delete(i)
                        }
                    }
            }
        }
    }
    
    private func userDidSelect(index: Int, isKnown: Bool) {
        let word = items[index]
        cardOffsets[word.english] = isKnown
        currentIndex += 1
    }
}


extension ContentView {
    private func cardView(word: Word, index: Int) -> some View {
        Card(word: word)
            .withDragGesture(.horizontal, minimumDistance: 10, resets: true, rotationMultiplier: 1.05) { dragOffset in
                currentSwipeOffset = dragOffset.width
            } onEnded: { dragOffset in
                if dragOffset.width < -50 {
                    userDidSelect(index: index, isKnown: false)
                } else if dragOffset.width > 50 {
                    userDidSelect(index: index, isKnown: true)
                }
            }
    }
}

#Preview(body: {
    ContentView()
        .flashCardDataContainer()
})
