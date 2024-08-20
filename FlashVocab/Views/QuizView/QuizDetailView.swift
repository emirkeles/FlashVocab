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
        List {
            Section(header: Text("Quiz Özeti")) {
                Text("Toplam Soru: \(quiz.questions.count)")
                Text("Doğru Cevap: \(quiz.questions.filter { $0.isCorrect }.count)")
                Text("Yanlış Cevap: \(quiz.questions.filter { !$0.isCorrect }.count)")
                Text("Skor: \(quiz.score ?? 0)")
            }
            
            Section(header: Text("Sorular")) {
                ForEach(quiz.questions, id: \.id) { question in
                    QuestionDetailView(question: question)
                }
            }
        }
        .navigationTitle("Quiz Detayı")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct QuestionDetailView: View {
    let question: QuizQuestion
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Soru: \(question.word.english)")
                .font(.headline)
            
            Text("Doğru Cevap: \(question.correctAnswer)")
                .foregroundColor(.green)
            
            if let selectedAnswer = question.selectedAnswer {
                Text("Kullanıcı Cevabı: \(selectedAnswer)")
                    .foregroundColor(question.isCorrect ? .green : .red)
            }
            
            Text("Diğer Seçenekler:")
                .font(.subheadline)
                .padding(.top, 4)
            
            ForEach(question.incorrectAnswers, id: \.self) { answer in
                Text("- \(answer)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
        .padding(.vertical, 8)
    }
}
