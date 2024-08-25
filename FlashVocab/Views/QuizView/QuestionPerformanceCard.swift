//
//  QuestionPerformanceCard.swift
//  FlashVocab
//
//  Created by Emir Keleş on 25.08.2024.
//

import SwiftUI

struct QuestionPerformanceCard: View {
    let question: QuizQuestion
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(question.word.english)
                .font(.system(size: 18, weight: .semibold, design: .rounded))
                .lineLimit(1)
            
            Text(question.word.turkish)
                .font(.system(size: 14, weight: .medium, design: .rounded))
                .foregroundColor(.secondary)
                .lineLimit(1)
            
            HStack {
                Image(systemName: question.isCorrect ? "checkmark.circle.fill" : "x.circle.fill")
                    .foregroundColor(question.isCorrect ? .green : .red)
                
                Text(question.isCorrect ? "Doğru" : "Yanlış")
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundColor(question.isCorrect ? .green : .red)
            }
        }
        .padding()
        .frame(height: 110)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(colorScheme == .dark ? Color(.systemGray6) : Color.white)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(question.isCorrect ? Color.green.opacity(0.5) : Color.red.opacity(0.5), lineWidth: 2)
        )
    }
}
