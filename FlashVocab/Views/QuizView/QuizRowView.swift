//
//  QuizRowView.swift
//  FlashVocab
//
//  Created by Emir Keleş on 10.08.2024.
//

import SwiftUI
import Charts

struct QuizRowView: View {
    let quiz: Quiz
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(quiz.date, style: .date)
                        .font(.headline)
                        .foregroundColor(.primary)
                    Text(quiz.date, style: .time)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                Spacer()
                ZStack {
                    Circle()
                        .stroke(Color.secondary.opacity(0.2), lineWidth: 4)
                        .frame(width: 60, height: 60)
                    
                    Circle()
                        .trim(from: 0, to: CGFloat(correctAnswersCount) / CGFloat(quiz.questions.count))
                        .stroke(Color.green, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                        .frame(width: 60, height: 60)
                        .rotationEffect(.degrees(-90))
                    
                    Text("\(Int((CGFloat(correctAnswersCount) / CGFloat(quiz.questions.count)) * 100))%")
                        .font(.system(size: 14, weight: .bold))
                }
            }
            HStack {
                StatView(title: "Soru", value: "\(quiz.questions.count)", color: .blue)
                StatView(title: "Doğru", value: "\(correctAnswersCount)", color: .green)
                StatView(title: "Yanlış", value: "\(incorrectAnswersCount)", color: .red)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
    
    private var correctAnswersCount: Int {
        quiz.questions.filter { $0.isCorrect == true }.count
    }
    
    private var incorrectAnswersCount: Int {
        quiz.questions.filter { $0.isCorrect == false }.count
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()


