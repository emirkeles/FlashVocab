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
