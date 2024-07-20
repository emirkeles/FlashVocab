//
//  Card.swift
//  FlashVocab
//
//  Created by Emir Keleş on 20.07.2024.
//

import SwiftUI

struct Card: View {
    @State private var isFlipped = false
    var word: Word
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25.0, style: .continuous)
                .frame(width: 200, height: 200)
                .foregroundStyle(.white)
                .overlay(
                    Text(isFlipped ? word.turkish : word.english)
                        .foregroundStyle(isFlipped ? .blue : .red)
                        .font(.title)
                        .rotation3DEffect(.degrees(isFlipped ? 180 : 0), axis: (x: 1, y: 0, z: 0))
                )
        }
        .frame(width: 200, height: 200)
        .rotation3DEffect(.degrees(isFlipped ? -180 : 0), axis: (x: 1, y: 0, z: 0))
        .onTapGesture {
                isFlipped.toggle()
        }
        .animation(.linear(duration: 0.6), value: isFlipped)
    }
}

