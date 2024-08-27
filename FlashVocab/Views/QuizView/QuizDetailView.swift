//
//  QuizDetailView.swift
//  FlashVocab
//
//  Created by Emir Keleş on 10.08.2024.
//

import SwiftUI
import FirebaseAnalytics

struct QuizDetailView: View {
    let quiz: Quiz
    
    @State private var showingQuestionDetails = false
    @State private var selectedQuestion: QuizQuestion?
    
    var body: some View {
        ScrollView {
            VStack(spacing: 25) {
                quizSummaryCard
                integratedPerformanceQuestionView
            }
            .padding()
        }
        .navigationTitle("Quiz Sonucu")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(.systemBackground))
        .onAppear {
            AnalyticsManager.shared.logQuizDetailViewed(
                quizScore: quiz.score ?? 0,
                totalQuestions: quiz.questions.count,
                correctAnswers: correctAnswersCount
            )
            AnalyticsManager.shared.logScreenView(screenName: "Quiz Detail", screenClass: "QuizDetailView")
        }
    }
    
    private var integratedPerformanceQuestionView: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Soru Detayları")
                .font(.system(size: 22, weight: .bold, design: .rounded))
                .padding(.bottom, 5)
            
            ForEach(quiz.questions.indices, id: \.self) { index in
                QuestionAnswerCard(question: quiz.questions[index], questionNumber: index + 1)
                    .onTapGesture {
                        AnalyticsManager.shared.logQuestionDetailViewed(
                            questionIndex: index,
                            isCorrect: quiz.questions[index].isCorrect,
                            word: quiz.questions[index].word.english
                        )
                    }
            }
        }
        .onAppear {
            AnalyticsManager.shared.logPerformanceAnalysisViewed()
        }
    }
    
    private var quizSummaryCard: some View {
        HStack(spacing: 20) {
            ZStack {
                Circle()
                    .stroke(Color.blue.opacity(0.2), lineWidth: 8)
                    .frame(width: 100, height: 100)
                
                Circle()
                    .trim(from: 0, to: CGFloat(correctAnswersCount) / CGFloat(quiz.questions.count))
                    .stroke(Color.blue, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                    .frame(width: 100, height: 100)
                    .rotationEffect(.degrees(-90))
                
                VStack {
                    Text("\(Int((Double(correctAnswersCount) / Double(quiz.questions.count)) * 100))%")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                    Text("Doğru")
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                        .foregroundColor(.secondary)
                }
            }
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Skor: \(quiz.score ?? 0)")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                
                HStack(spacing: 15) {
                    SummaryItem(title: "Toplam", value: "\(quiz.questions.count)", color: .blue)
                    SummaryItem(title: "Doğru", value: "\(correctAnswersCount)", color: .green)
                    SummaryItem(title: "Yanlış", value: "\(incorrectAnswersCount)", color: .red)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.secondarySystemBackground))
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
        )
    }
    
    private var correctAnswersCount: Int {
        quiz.questions.filter { $0.isCorrect }.count
    }
    
    private var incorrectAnswersCount: Int {
        quiz.questions.filter { !$0.isCorrect }.count
    }
    
    private var questionsGrid: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))], spacing: 15) {
            ForEach(quiz.questions) { question in
                Button(action: {
                    selectedQuestion = question
                }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 15)
                            .fill(question.isCorrect ? Color.green.opacity(0.2) : Color.red.opacity(0.2))
                            .frame(height: 80)
                        
                        Text(question.word.english)
                            .font(.caption)
                            .fontWeight(.medium)
                            .multilineTextAlignment(.center)
                    }
                }
            }
        }
    }
    
    private var performanceChart: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Performans Analizi")
                .font(.headline)
                .padding(.bottom, 5)
            
            ForEach(0..<quiz.questions.count, id: \.self) { index in
                HStack {
                    Text("\(index + 1).")
                        .font(.caption)
                        .frame(width: 25, alignment: .leading)
                    
                    Rectangle()
                        .fill(quiz.questions[index].isCorrect ? Color.green : Color.red)
                        .frame(height: 20)
                        .overlay(
                            Text(quiz.questions[index].word.english)
                                .font(.caption)
                                .foregroundColor(.white)
                                .padding(.horizontal, 5)
                        )
                        .cornerRadius(5)
                    
                    Image(systemName: quiz.questions[index].isCorrect ? "checkmark.circle.fill" : "x.circle.fill")
                        .foregroundColor(quiz.questions[index].isCorrect ? .green : .red)
                }
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(20)
    }
}


