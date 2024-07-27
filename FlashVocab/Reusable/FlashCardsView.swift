//
//  FlashCardsView.swift
//  FlashVocab
//
//  Created by Emir Keleş on 24.07.2024.
//

import SwiftUI
import SwiftData

struct FlashCardsView: View {
    @Query(filter: #Predicate<Word>{ word in
        word.index >= 0
    }, sort: \Word.index)
    private var items: [Word]
    
    @State private var currentIndex = 0
    @State private var currentSwipeOffset: CGFloat = .zero
    @State private var cardOffsets: [String:Bool] = [:]
    @State private var showCurrentCardOnly = false
    
    var body: some View {
        ZStack {
            if currentIndex < items.count {
                VStack {
                    ZStack {
                        ForEach(Array(items.enumerated()), id: \.offset) { (index, word) in
                            if shouldShowCard(at: index) {
                                cardView(word: word, index: index)
                                    .zIndex(Double(items.count - index))
                                    .offset(x: cardOffset(for: word.english))
                            }
                        }
                    }
                    
                }
                OverlaySwipingIndicators(currentSwipeOffset: $currentSwipeOffset)
                    .zIndex(.infinity)
            } else {
                GroupBox {
                    ContentUnavailableView("No more cards to show", systemImage: "figure.wave")
                }
                .frame(width: 350, height: 450)
            }
        }
        .navigationTitle("KARTLAR")
        .animation(.smooth, value: cardOffsets)
        
    }
    
    private func cardOffset(for key: String) -> CGFloat {
            switch cardOffsets[key] {
            case true: return 900
            case false: return -900
            case .none: return 0
            case .some(_):
                return 0
            }
        }
    
    private func shouldShowCard(at index: Int) -> Bool {
        (currentIndex - 1...currentIndex + 1).contains(index)
        }
    
    private func cardView(word: Word, index: Int) -> some View {
        Card(word: word)
            .withDragGesture(.horizontal, minimumDistance: 30, resets: true, rotationMultiplier: 1.05) { dragOffset in
                currentSwipeOffset = dragOffset.width
            } onEnded: { dragOffset in
                handleSwipe(dragOffset: dragOffset, for: index)
            }
    }
    
    private func handleSwipe(dragOffset: CGSize, for index: Int) {
            if abs(dragOffset.width) > 100 {
                let isKnown = dragOffset.width > 0
                userDidSelect(index: index, isKnown: isKnown)
            }
        }
    
    private func userDidSelect(index: Int, isKnown: Bool) {
        let word = items[index]
        word.isKnown = isKnown
        cardOffsets[word.english] = isKnown
        currentIndex += 1
    }
}
