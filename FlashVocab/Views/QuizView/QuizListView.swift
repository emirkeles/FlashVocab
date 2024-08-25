//
//  QuizListView.swift
//  FlashVocab
//
//  Created by Emir Keleş on 10.08.2024.
//

import SwiftUI
import SwiftData

struct QuizListView: View {
    @Query(FetchDescriptor(predicate: #Predicate<Quiz>{ quiz in
        quiz.completed == true
    }, sortBy: [SortDescriptor<Quiz>(\.date, order: .reverse)]))
    private var quizzes: [Quiz]
    @State private var selectedQuiz: Quiz?
    
    var body: some View {
            List(quizzes) { quiz in
                QuizRowView(quiz: quiz)
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                    .background(.white.opacity(0.00001))
                    .onTapGesture {
                        selectedQuiz = quiz
                    }
            }
            .listStyle(.plain)
            .navigationTitle("Kayıtlı Quiz'ler")
            
            .sheet(item: $selectedQuiz) { quiz in
                QuizDetailView(quiz: quiz)
            }
    }
}
