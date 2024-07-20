//
//  SwipingIndicator.swift
//  FlashVocab
//
//  Created by Emir Keleş on 20.07.2024.
//

import SwiftUI

struct SwipingIndicator: View {
    var symbol: String
    var color: Color
    
    var body: some View {
        Circle()
            .fill(color.opacity(0.4))
            .overlay(
                Image(systemName: symbol)
                    .font(.title)
                    .fontWeight(.semibold)
            )
            .frame(width: 60, height: 60)
    }
}

struct OverlaySwipingIndicators: View {
    @Binding var currentSwipeOffset: CGFloat
    
    var body: some View {
        ZStack {
            SwipingIndicator(symbol: "xmark", color: .red)
                .scaleEffect(abs(currentSwipeOffset) > 100 ? 1.5 : 1.0)
                .offset(x: min(-currentSwipeOffset, 150))
                .offset(x: -100)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            SwipingIndicator(symbol: "checkmark", color: .green)
                .scaleEffect(abs(currentSwipeOffset) > 100 ? 1.5 : 1.0)
                .offset(x: max(-currentSwipeOffset, -150))
                .offset(x: 100)
                .frame(maxWidth: .infinity, alignment: .trailing)
            
        }
        .animation(.smooth, value: currentSwipeOffset)
    }
}
