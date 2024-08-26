//
//  BookmarkOverlaySwipingIndicators.swift
//  FlashVocab
//
//  Created by Emir Keleş on 26.08.2024.
//

import SwiftUI

struct BookmarkOverlaySwipingIndicators: View {
    @Binding var currentSwipeOffset: CGFloat
    
    var body: some View {
        ZStack {
            SwipingIndicator(symbol: "arrowshape.turn.up.backward", color: .blue)
                .scaleEffect(abs(currentSwipeOffset) > 100 ? 1.5 : 1.0)
                .offset(x: min(-currentSwipeOffset, 150))
                .offset(x: -100)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            SwipingIndicator(symbol: "arrowshape.turn.up.forward", color: .blue)
                .scaleEffect(abs(currentSwipeOffset) > 100 ? 1.5 : 1.0)
                .offset(x: max(-currentSwipeOffset, -150))
                .offset(x: 100)
                .frame(maxWidth: .infinity, alignment: .trailing)
            
        }
        .animation(.smooth, value: currentSwipeOffset)
    }
}
