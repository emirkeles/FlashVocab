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
        HStack {
            VStack(alignment: .leading) {
                Text("Quiz Tarihi: \(quiz.date, formatter: itemFormatter)")
                Text("Soru Sayısı: \(quiz.questions.count)")
                if let score = quiz.score {
                    Text("Skor: \(score)")
                }
            }
            
            Spacer()
            
            Chart {
                SectorMark(
                    angle: .value("Doğru", correctAnswersCount),
                    innerRadius: .ratio(0.618),
                    angularInset: 1.5
                )
                .foregroundStyle(.green)
                
                SectorMark(
                    angle: .value("Yanlış", incorrectAnswersCount),
                    innerRadius: .ratio(0.618),
                    angularInset: 1.5
                )
                .foregroundStyle(.red)
            }
            .frame(width: 60, height: 60)
        }
        .padding(.vertical, 8)
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
