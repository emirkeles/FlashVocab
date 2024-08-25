//
//  FlashCardsView.swift
//  FlashVocab
//
//  Created by Emir Keleş on 24.07.2024.
//

import SwiftUI
import SwiftData
import SwiftfulUI

struct FlashCardsView: View {
    @Query(Word.all)
    private var items: [Word]
    @Query
    private var appStates: [AppState]
    @Environment(\.modelContext) private var modelContext
    
    @State private var currentIndex = 0
    @State private var currentSwipeOffset: CGFloat = .zero
    @State private var cardOffsets: [String:CGFloat] = [:]
    @State private var showCurrentCardOnly = false
    
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
                    ContentUnavailableView("No more cards to show", systemImage: "figure.wave")
                }
                .frame(width: 350, height: 450)
            }
        }
        .navigationTitle("FlashVocab")
        .navigationBarTitleDisplayMode(.inline)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)

        .animation(.smooth, value: cardOffsets)
        .onAppear(perform: loadLastIndex)
        .onChange(of: currentIndex) { oldValue, newValue in
            saveLastIndex(newValue)
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
               let isKnown = direction > 0
               
               withAnimation(.spring(duration: 0.5)) {
                   cardOffsets[items[index].english] = direction * UIScreen.main.bounds.width
                   currentSwipeOffset = 0
               }
               
               DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                   userDidSelect(index: index, isKnown: isKnown)
               }
           } else {
               withAnimation(.spring(duration: 0.3)) {
                   currentSwipeOffset = 0
               }
           }
       }
    
//    private func handleSwipe(dragOffset: CGSize, for index: Int) {
//        if abs(dragOffset.width) > 100 {
//            let isKnown = dragOffset.width > 0
//            userDidSelect(index: index, isKnown: isKnown)
//            
//            withAnimation(.spring(duration: 0.3)) {
//                cardOffsets[items[index].english] = isKnown == true ? 300 : -300
//            }
//        } else {
//            withAnimation(.spring(duration: 0.3)) {
//                cardOffsets[items[index].english] = 0
//            }
//        }
//    }
    
    private func userDidSelect(index: Int, isKnown: Bool) {
        let word = items[index]
        word.isKnown = isKnown
        if isKnown {
            word.learnedDate = Date()
        }
        currentIndex += 1
        
        if currentIndex < items.count {
            cardOffsets[items[currentIndex].english] = 0
        }
    }
    
    private func loadLastIndex() {
            if let appState = appStates.first {
                currentIndex = appState.lastCardIndex
                print("currentindex: \(currentIndex)")
            } else {
                let newAppState = AppState(lastCardIndex: 0)
                modelContext.insert(newAppState)
            }
        }
        
        private func saveLastIndex(_ index: Int) {
            if let appState = appStates.first {
                print("appState lastCarIndex: \(appState.lastCardIndex)")
                appState.lastCardIndex = index
            }
        }
}
