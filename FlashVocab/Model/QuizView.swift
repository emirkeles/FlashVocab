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
    @State private var currentQuizIndex = 0
    @State private var showResult = false
    @State private var isAnswerOrderReversed = false
    @State private var showNoQuizAvailable = false
    @State private var swipeThreshold: CGFloat = 60
    @State private var offset: CGFloat = 0
    @State private var currentCardId = UUID()
    
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
    
    private func quizContent(quiz: Quiz) -> some View {
            GeometryReader { geometry in
                ZStack {
                    backgroundGradient
                    
                    if showResult {
                        quizResultView(quiz: quiz)
                            .transition(.slide)
                    } else if currentQuizIndex < quiz.questions.count {
                        let question = quiz.questions[currentQuizIndex]
                        
                        AnswerIndicators(
                            leftAnswer: question.leftAnswer,
                            rightAnswer: question.rightAnswer,
                            currentSwipeOffset: $offset
                        )
                        .zIndex(.infinity)
                        
                        questionCardView(question: question, geometry: geometry)
                            .id(currentCardId)
                            .offset(x: offset)
                            .gesture(
                                DragGesture()
                                    .onChanged { gesture in
                                        offset = gesture.translation.width
                                    }
                                    .onEnded { _ in
                                        handleSwipeEnd(question: question, geometry: geometry)
                                    }
                            )
                            .transition(.asymmetric(insertion: .move(edge: .bottom), removal: .move(edge: offset > 0 ? .trailing : .leading)))
                    }
                }
            }
        }
    
    private var backgroundGradient: some View {
        LinearGradient(gradient: Gradient(colors: [.blue, .purple]), startPoint: .topLeading, endPoint: .bottomTrailing)
            .opacity(0.3)
    }
    
    private func questionCardView(question: QuizQuestion, geometry: GeometryProxy) -> some View {
        VStack {
            Text("Soru \(currentQuizIndex + 1) / \(quiz!.questions.count)")
                .font(.headline)
            
            Text(question.word.english.capitalized)
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
        }
        .frame(width: geometry.size.width * 0.8, height: 200)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 10)
    }
    
    private func handleSwipeEnd(question: QuizQuestion, geometry: GeometryProxy) {
        if abs(offset) > swipeThreshold {
            let direction = offset > 0
            selectAnswer(isRight: direction, question: question)
            withAnimation(.snappy) {
                offset = direction ? geometry.size.width * 1.5 : -geometry.size.width * 1.5
            }
        } else {
            withAnimation(.snappy) {
                offset = 0
            }
        }
    }
    
    private func selectAnswer(isRight: Bool, question: QuizQuestion) {
        question.checkAnswer(selectedRight: isRight)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            if currentQuizIndex < quiz!.questions.count - 1 {
                currentQuizIndex += 1
                withAnimation(.spring()) {
                    offset = 0
                }
            } else {
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
            withAnimation(.easeInOut) {
                showResult = false
                currentQuizIndex = 0
                offset = 0
                currentCardId = UUID()
            }
            createQuiz()
        }
    
}

struct AnswerIndicators: View {
    let leftAnswer: String
    let rightAnswer: String
    @Binding var currentSwipeOffset: CGFloat
    
    var body: some View {
        ZStack {
            AnswerIndicator(text: leftAnswer, color: .red)
                .scaleEffect(currentSwipeOffset < -60 ? 1.5 : 1.0)
                .offset(x: currentSwipeOffset < 0 ? min(-currentSwipeOffset, 100) : 0, y: -130)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            
            AnswerIndicator(text: rightAnswer, color: .green)
                .scaleEffect(currentSwipeOffset > 60 ? 1.5 : 1.0)
                .offset(x: currentSwipeOffset > 0 ? max(-currentSwipeOffset, -100) : 0, y: -130)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.horizontal)
        }
        .animation(.smooth, value: currentSwipeOffset)
    }
}

struct AnswerIndicator: View {
    let text: String
    let color: Color
    
    var body: some View {
        Text(text.capitalized)
                .frame(width: 100)
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(.primary)
                .padding(.vertical, 12)
                .padding(.horizontal, 16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.white.opacity(0.6))
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(.white.opacity(0.6), lineWidth: 1)
                        )
                )
                .shadow(color: .white.opacity(0.2), radius: 5, x: 0, y: 2)
        }
}
