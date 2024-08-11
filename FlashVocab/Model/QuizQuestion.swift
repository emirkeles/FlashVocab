//
//  QuizQuestion.swift
//  FlashVocab
//
//  Created by Emir Keleş on 8.08.2024.
//

import SwiftUI
import SwiftData

@Model
final class QuizQuestion: Identifiable {
    let id: UUID
    var word: Word
    var correctAnswer: String
    var incorrectAnswers: [String]
    var selectedAnswer: String?
    @Relationship(inverse: \Quiz.questions) var quiz: Quiz?
    
    init(word: Word, incorrectAnswers: [String], quiz: Quiz? = nil) {
        self.id = UUID()
        self.word = word
        self.correctAnswer = word.turkish
        self.incorrectAnswers = incorrectAnswers
        self.quiz = quiz
    }
    
    
    var allAnswers: [String] {
        return ([correctAnswer] + incorrectAnswers).shuffled()
    }
    
    var isAnswered: Bool {
        return selectedAnswer != nil
    }
    
    var isCorrect: Bool {
        guard let selectedAnswer = selectedAnswer else {
            return false
        }
        return selectedAnswer == correctAnswer
    }
    
    func checkAnswer(selected: String) {
        self.selectedAnswer = selected
    }
}
