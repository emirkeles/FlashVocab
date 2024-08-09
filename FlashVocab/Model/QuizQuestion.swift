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
    var incorrectAnswer: String
    var isCorrectOnRight: Bool
    var userAnsweredRight: Bool?
    var isCorrect: Bool?
    @Relationship(inverse: \Quiz.questions) var quiz: Quiz?
    
    init(word: Word, incorrectAnswer: String, quiz: Quiz? = nil) {
        self.id = UUID()
        self.word = word
        self.correctAnswer = word.turkish
        self.incorrectAnswer = incorrectAnswer
        self.isCorrectOnRight = Bool.random()
        self.quiz = quiz
    }
    
    var leftAnswer: String {
        isCorrectOnRight ? incorrectAnswer : correctAnswer
    }
    
    var rightAnswer: String {
        isCorrectOnRight ? correctAnswer : incorrectAnswer
    }
}

extension QuizQuestion {
    func checkAnswer(selectedRight: Bool) {
        self.userAnsweredRight = selectedRight
        self.isCorrect = (selectedRight == isCorrectOnRight)
    }
}
