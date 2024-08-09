//
//  QuizView.swift
//  FlashVocab
//
//  Created by Emir Keleş on 10.08.2024.
//

import SwiftUI
import SwiftData

struct QuizView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var words: [Word]
    @State private var quiz: Quiz?
    @State private var currentQuizIndex = 0
    @State private var showResult = false
    @State private var isAnswerOrderReversed = false
    @State private var showNoQuizAvailable = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
            Group {
                if let quiz = quiz {
                    quizContent(quiz: quiz)
                } else if showNoQuizAvailable {
                    noQuizAvailableView
                } else {
                    ProgressView("Quiz yükleniyor...")
                        .onAppear(perform: createQuiz)
                }
            }
            .navigationTitle("Quiz")
        }
    
    private var noQuizAvailableView: some View {
            VStack {
                Text("Yeterli bilinmeyen kelime yok.")
                    .font(.title)
                    .multilineTextAlignment(.center)
                Text("Daha fazla kelime öğrenin ve tekrar deneyin.")
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                    .padding()
                Button("Ana Sayfaya Dön") {
                    dismiss()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .padding()
        }
    
    private func createQuiz() {
            if let newQuiz = Quiz.createQuiz(from: words, context: modelContext) {
                self.quiz = newQuiz
            } else {
                showNoQuizAvailable = true
            }
        }
    
    @ViewBuilder
        private func quizContent(quiz: Quiz) -> some View {
            VStack(spacing: 20) {
                if showResult {
                    quizResultView(quiz: quiz)
                } else {
                    quizQuestionView(quiz: quiz)
                }
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(20)
            .padding()
        }
    
    private func selectAnswer(isRight: Bool, question: QuizQuestion) {
            question.checkAnswer(selectedRight: isRight)
            
            if currentQuizIndex < quiz!.questions.count - 1 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    currentQuizIndex += 1
                }
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    quiz!.completeQuiz()
                    showResult = true
                }
            }
        }
    
    
    
    private func quizResultView(quiz: Quiz) -> some View {
            VStack(spacing: 20) {
                Text("Quiz Tamamlandı!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Skorunuz: \(quiz.score ?? 0)")
                    .font(.title)
                
                Button("Yeni Quiz") {
                    resetQuiz()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
        }
    
    private func resetQuiz() {
            createQuiz()
            currentQuizIndex = 0
            showResult = false
        }
    
    
    private func answerButton(isRight: Bool, question: QuizQuestion) -> some View {
            let answer = isRight ? question.rightAnswer : question.leftAnswer
            
            return Button(action: {
                selectAnswer(isRight: isRight, question: question)
            }) {
                Text(answer)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .disabled(question.userAnsweredRight != nil)
        }
    
    private func quizQuestionView(quiz: Quiz) -> some View {
            VStack(spacing: 20) {
                Text("Soru \(currentQuizIndex + 1) / \(quiz.questions.count)")
                    .font(.headline)
                
                if currentQuizIndex < quiz.questions.count {
                    let question = quiz.questions[currentQuizIndex]
                    Text(question.word.english)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    HStack(spacing: 20) {
                        if isAnswerOrderReversed {
                            answerButton(isRight: true, question: question)
                            answerButton(isRight: false, question: question)
                        } else {
                            answerButton(isRight: false, question: question)
                            answerButton(isRight: true, question: question)
                        }
                    }
                }
            }
            .onChange(of: currentQuizIndex) { _, _ in
                isAnswerOrderReversed = Bool.random()
            }
        }
    
}
