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
    @Environment(\.dismiss) private var dismiss
    @Query private var words: [Word]
    
    @State private var quiz: Quiz?
    @State private var currentQuestionIndex = 0
    @State private var selectedAnswer: String?
    @State private var showResult = false
    @State private var showNoQuizAvailable = false
    @State private var shuffledAnswers: [String] = []
    
    
    var body: some View {
        Group {
            if let quiz = quiz {
                if showResult {
                    quizResultView(quiz: quiz)
                } else if let currentQuestion = quiz.currentQuestion {
                    quizQuestionView(question: currentQuestion)
                        .onAppear {
                            shuffledAnswers = currentQuestion.allAnswers
                        }
                } else {
                    Text("Quiz tamamlandı!")
                        .onAppear {
                            showResult = true
                        }
                }
            } else if showNoQuizAvailable {
                noQuizAvailableView
            } else {
                ProgressView("Quiz yükleniyor...")
                    .onAppear(perform: createQuiz)
            }
        }
        .navigationTitle("Quiz")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    
    private var noQuizAvailableView: some View {
        VStack {
            Text("Yeterli bilinmeyen kelime yok!")
                .font(.title)
                .multilineTextAlignment(.center)
            Text("En az 10 adet bilinmeyen kelime gerekli.")
                .font(.headline)
                .multilineTextAlignment(.center)
                .padding(.top)
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
    
    private func quizQuestionView(question: QuizQuestion) -> some View {
        VStack(spacing: 20) {
            Text("Soru \(currentQuestionIndex + 1) / \(quiz?.questions.count ?? 0)")
                .font(.headline)
            
            Text(question.word.english.capitalized)
                .font(.largeTitle)
                .fontWeight(.bold)
            
            VStack {
                ForEach(shuffledAnswers, id: \.self) { answer in
                    Button(action: {
                        selectedAnswer = answer
                        HapticFeedbackManager.shared.playSelection()
                    }) {
                        Text(answer.capitalized)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(selectedAnswer == answer ? Color.blue : Color.gray.opacity(0.2))
                            .foregroundColor(selectedAnswer == answer ? .white : .primary)
                            .cornerRadius(10)
                    }
                }
            }
            
            Button {
                if let selected = selectedAnswer {
                    quiz?.answerCurrentQuestion(with: selected)
                    selectedAnswer = nil
                    currentQuestionIndex += 1
                    if let nextQuestion = quiz?.currentQuestion {
                        shuffledAnswers = nextQuestion.allAnswers
                    }
                    if quiz?.isCompleted == true {
                        showResult = true
                        HapticFeedbackManager.shared.playImpact(style: .medium)
                    }
                }
            } label: {
                Text("İlerle")
                    .disabled(selectedAnswer == nil)
                    .padding()
                    .frame(minWidth: 120)
                    .background(selectedAnswer == nil ? Color.gray : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
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
        showResult = false
        currentQuestionIndex = 0
        selectedAnswer = nil
        shuffledAnswers = []
        createQuiz()
    }
}
