//
//  QuizMenuView.swift
//  FlashVocab
//
//  Created by Emir Keleş on 25.08.2024.
//

import SwiftUI
import SwiftData
import SwiftfulUI
import FirebaseAnalytics

struct BookmarkedFlashCardsView: View {
    @Query(Word.bookmarkedWords)
    private var items: [Word]
    @Environment(\.modelContext) private var modelContext
    
    @State private var currentIndex = 0
    @State private var currentSwipeOffset: CGFloat = .zero
    @State private var cardOffsets: [String:CGFloat] = [:]
    
    var body: some View {
        ZStack {
            if currentIndex < items.count {
                VStack {
                    ZStack {
                        ForEach(Array(items.enumerated()), id: \.offset) { (index, word) in
                            if shouldShowCard(at: index) {
                                cardView(word: word, index: index)
                                    .offset(x: cardOffset(for: word.english))
                                    .zIndex(Double(items.count - index))
                                    .animation(.spring(duration: 0.5), value: cardOffset(for: word.english))
                            }
                        }
                    }
                }
                OverlaySwipingIndicators(currentSwipeOffset: $currentSwipeOffset)
                    .zIndex(.infinity)
            } else {
                GroupBox {
                    ContentUnavailableView("Hiç yer işaretli kart bulunamadı.", systemImage: "bookmark.slash", description: Text("Yer işaretlerine kelime ekle."))
                }
                .padding()
            }
        }
        .navigationTitle("Yer İşaretli Kartlarım")
        .navigationBarTitleDisplayMode(.inline)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .animation(.smooth, value: cardOffsets)
        .onAppear {
            AnalyticsManager.shared.logBookmarkedFlashCardSessionStarted(cardCount: items.count)
            AnalyticsManager.shared.logScreenView(screenName: "Bookmarked FlashCards", screenClass: "BookmarkedFlashCardsView")
        }
    }
    
    private func cardOffset(for key: String) -> CGFloat {
        cardOffsets[key] ?? 0
    }
    
    private func shouldShowCard(at index: Int) -> Bool {
        (currentIndex...currentIndex+2).contains(index)
    }
    
    private func cardView(word: Word, index: Int) -> some View {
        Card(word: word)
            .withDragGesture(.horizontal, minimumDistance: 30, resets: true, rotationMultiplier: 1.05) { dragOffset in
                if index == currentIndex {
                    currentSwipeOffset = dragOffset.width
                }
            } onEnded: { dragOffset in
                handleSwipe(dragOffset: dragOffset, for: index)
            }
    }
    
    private func handleSwipe(dragOffset: CGSize, for index: Int) {
        let swipeThreshold: CGFloat = 100
        if abs(dragOffset.width) > swipeThreshold {
            let direction: CGFloat = dragOffset.width > 0 ? 1 : -1
            let keepBookmarked = direction > 0
            
            withAnimation(.spring(duration: 0.5)) {
                cardOffsets[items[index].english] = direction * UIScreen.main.bounds.width
                currentSwipeOffset = 0
            }
            HapticFeedbackManager.shared.playImpact()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                userDidSelect(index: index, keepBookmarked: keepBookmarked)
            }
        } else {
            withAnimation(.spring(duration: 0.3)) {
                currentSwipeOffset = 0
            }
        }
    }
    
    private func userDidSelect(index: Int, keepBookmarked: Bool) {
        let word = items[index]
        AnalyticsManager.shared.logBookmarkedFlashCardRemoved(word: word.english)
        currentIndex += 1
        
        if currentIndex < items.count {
            cardOffsets[items[currentIndex].english] = 0
        } else {
            AnalyticsManager.shared.logBookmarkedFlashCardSessionCompleted(cardsReviewed: items.count)
        }
    }
}
