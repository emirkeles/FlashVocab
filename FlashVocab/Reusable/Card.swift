//
//  Card.swift
//  FlashVocab
//
//  Created by Emir Keleş on 20.07.2024.
//

import SwiftUI

struct Card: View {
    @State private var expansionStage = 0
    @Namespace private var Namespace
    var word: Word
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25.0, style: .continuous)
                .fill(.ultraThickMaterial)
                .frame(width: 200, height: cardHeight)
                .overlay(
                    ZStack {
                        VStack(spacing: 10) {
                            Text(word.english)
                                .matchedGeometryEffect(id: "word.english", in: Namespace)
                                .foregroundStyle(.red)
                                .font(.title)
                            
                            if expansionStage >= 1 {
                                Text(word.sentence)
                                    .matchedGeometryEffect(id: "word.sentence", in: Namespace)
                                    .foregroundStyle(.blue)
                                    .font(.callout)
                                    .padding(.horizontal)
                                    .transition(.asymmetric(insertion: .push(from: .bottom), removal: .push(from: .top)))
                            }
                            
                            if expansionStage == 2 {
                                Text(word.turkish)
                                    .matchedGeometryEffect(id: "word.turkish", in: Namespace)
                                    .foregroundStyle(.green)
                                    .font(.body)
                                    .padding(.top, 5)
                                    .transition(.asymmetric(insertion: .push(from: .bottom), removal: .push(from: .top)))
                            }
                        }
                        VStack {
                            expandButton
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                    }
                )
        }
    }
    
    private var cardHeight: CGFloat {
        switch expansionStage {
        case 0: return 180
        case 1: return 220
        case 2: return 260
        default: return 180
        }
    }
    
    private var expandButton: some View {
        Button(action: {
            withAnimation(.easeInOut) {
                expansionStage = (expansionStage + 1) % 3
            }
        }) {
            Image(systemName: "arrow.down.to.line")
                .font(.title3)
                .matchedGeometryEffect(id: "expandButton", in: Namespace)
                .foregroundStyle(.red)
                .rotationEffect(expansionStage == 2 ? .degrees(180) : .degrees(0))
                .animation(.easeInOut(duration: 0.3), value: expansionStage)
                .padding()
        }
    }
    
    private var expansionButtonIcon: String {
        switch expansionStage {
        case 0, 1: return "arrow.down.to.line"
        case 2: return "arrow.down.to.line"
        default: return "arrow.down.to.line"
        }
    }
}

