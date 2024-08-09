//
//  QuizDetailView.swift
//  FlashVocab
//
//  Created by Emir Keleş on 10.08.2024.
//

import SwiftUI

struct QuizDetailView: View {
    let quiz: Quiz
    
    var body: some View {
        
        List(quiz.questions, id: \.id) { question in
            VStack(alignment: .leading) {
                Text("Soru: \(question.word.english)")
                    .font(.headline)
                Text("Doğru Cevap: \(question.correctAnswer)")
                    .foregroundColor(.green)
                if let isCorrect = question.isCorrect {
                    Text("Kullanıcı Cevabı: \(isCorrect ? "\(question.correctAnswer)" : "\(question.incorrectAnswer)")")
                        .foregroundColor(isCorrect ? .green : .red)
                }
            }
        }
        .navigationTitle("Quiz Detayı")
    }
}
