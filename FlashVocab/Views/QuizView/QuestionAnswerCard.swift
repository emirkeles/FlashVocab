//
//  QuestionAnswerCard.swift
//  FlashVocab
//
//  Created by Emir Keleş on 25.08.2024.
//

import SwiftUI

struct QuestionAnswerCard: View {
    let question: QuizQuestion
    let questionNumber: Int
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Soru \(questionNumber)")
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(.blue)
                Spacer()
                statusIcon
            }
            
            Text(question.word.english)
                .font(.system(size: 20, weight: .semibold, design: .rounded))
            
            HStack(spacing: 8) {
                answerRow(title: "Doğru Cevap", answer: question.correctAnswer, isCorrect: true)
                Spacer()
                if !question.isCorrect, let selectedAnswer = question.selectedAnswer {
                    answerRow(title: "Sizin Cevabınız", answer: selectedAnswer, isCorrect: question.isCorrect)
                }
            }
            .frame(maxWidth: .infinity)
            VStack(alignment: .leading, spacing: 5) {
                if !question.isCorrect {
                    Text("Diğer Seçenekler:")
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .foregroundColor(.secondary)
                        .padding(.top, 4)
                    HStack {
                        ForEach(question.incorrectAnswers, id: \.self) { answer in
                            Text("• \(answer)")
                                .font(.system(size: 16, design: .rounded))
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
        }
        .padding()
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
    
    private var statusIcon: some View {
        Image(systemName: question.isCorrect ? "checkmark.circle.fill" : "x.circle.fill")
            .foregroundColor(question.isCorrect ? .green : .red)
            .font(.system(size: 22))
    }
    
    private func answerRow(title: String, answer: String, isCorrect: Bool) -> some View {
        HStack(alignment: .top) {
            Image(systemName: isCorrect ? "checkmark.circle.fill" : "x.circle.fill")
                .foregroundColor(isCorrect ? .green : .red)
                .font(.system(size: 16))
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundColor(.secondary)
                Text(answer)
                    .font(.system(size: 16, weight: .medium, design: .rounded))
            }
        }
    }
}
