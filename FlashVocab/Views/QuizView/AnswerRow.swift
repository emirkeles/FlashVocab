//
//  AnswerRow.swift
//  FlashVocab
//
//  Created by Emir Keleş on 25.08.2024.
//

import SwiftUI

struct AnswerRow: View {
    let title: String
    let answer: String
    let isCorrect: Bool
    
    var body: some View {
        HStack {
            Image(systemName: isCorrect ? "checkmark.circle.fill" : "x.circle.fill")
                .foregroundColor(isCorrect ? .green : .red)
            VStack(alignment: .leading) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(answer)
                    .font(.body)
                    .fontWeight(.medium)
            }
        }
    }
}
