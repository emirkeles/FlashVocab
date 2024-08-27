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
    @State private var isResetting = false
    
    var body: some View {
        ZStack {
            if !items.isEmpty {
                cardStack
                swipeIndicators
            } else {
                emptyStateView
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
        .onChange(of: currentIndex) { oldValue, newValue in
            if newValue >= items.count {
                resetCards()
            }
        }
    }
    
    private var cardStack: some View {
        ZStack {
            ForEach(Array(items.enumerated()), id: \.offset) { (index, word) in
                if shouldShowCard(at: index) {
                    cardView(word: word, index: index)
                        .offset(x: cardOffset(for: word.english))
                        .zIndex(Double(items.count - index))
                        .animation(.spring(duration: 0.5), value: cardOffset(for: word.english))
                        .transition(isResetting ? .push(from: .bottom) : .identity)
                }
            }
        }
    }
    
    private var swipeIndicators: some View {
        BookmarkOverlaySwipingIndicators(currentSwipeOffset: $currentSwipeOffset)
            .zIndex(.infinity)
    }
    
    private var emptyStateView: some View {
        GroupBox {
            ContentUnavailableView(
                "Hiç yer işaretli kart bulunamadı.",
                systemImage: "bookmark.slash",
                description: Text("Yer işaretlerine kelime ekle.")
            )
        }
        .padding()
    }
    
    private func cardView(word: Word, index: Int) -> some View {
        Card(word: word)
            .withDragGesture(
                .horizontal,
                minimumDistance: 30,
                resets: true,
                rotationMultiplier: 1.05,
                onChanged: { handleDragChange(dragOffset: $0, for: index) },
                onEnded: { handleSwipe(dragOffset: $0, for: index) }
            )
    }
    
    private func handleDragChange(dragOffset: CGSize, for index: Int) {
        if index == currentIndex {
            currentSwipeOffset = dragOffset.width
        }
    }
    
    private func handleSwipe(dragOffset: CGSize, for index: Int) {
        let swipeThreshold: CGFloat = 100
        if abs(dragOffset.width) > swipeThreshold {
            let direction: CGFloat = dragOffset.width > 0 ? 1 : -1
            HapticFeedbackManager.shared.playSelection()
            animateCardSwipe(direction: direction, for: index)
        } else {
            resetSwipeOffset()
        }
    }
    
    private func animateCardSwipe(direction: CGFloat, for index: Int) {
        withAnimation(.spring(duration: 0.5)) {
            cardOffsets[items[index].english] = direction * UIScreen.main.bounds.width
            currentSwipeOffset = 0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            userDidSelect(index: index)
        }
    }
    
    private func resetSwipeOffset() {
        withAnimation(.spring(duration: 0.3)) {
            currentSwipeOffset = 0
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
    
    private func resetCards() {
        isResetting = true
        
        withAnimation(.easeInOut(duration: 0.5)) {
            currentIndex = 0
            cardOffsets.removeAll()
            currentSwipeOffset = 0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            isResetting = false
        }
    }
    
    private func cardOffset(for key: String) -> CGFloat {
        cardOffsets[key] ?? 0
    }
    
    private func shouldShowCard(at index: Int) -> Bool {
        (currentIndex...currentIndex+2).contains(index)
    }
}
