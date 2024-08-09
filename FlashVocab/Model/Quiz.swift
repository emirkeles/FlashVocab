//
//  Quiz.swift
//  FlashVocab
//
//  Created by Emir Keleş on 8.08.2024.
//

import SwiftUI
import SwiftData

@Model
final class Quiz: Identifiable {
    @Attribute(.unique) let id: UUID
    var date: Date
    @Relationship(deleteRule: .cascade)
    var questions: [QuizQuestion] = []
    var score: Int?
    var completed: Bool
    
    init(date: Date = Date(), score: Int? = nil, completed: Bool = false) {
        self.id = UUID()
        self.date = date
        self.score = score
        self.completed = completed
    }
}

extension Quiz {
    static func createQuiz(from words: [Word], questionCount: Int = 10, context: ModelContext) -> Quiz? {
        let now = Date()
        let eligibleWords = words.filter { word in
            if let isKnown = word.isKnown {
                return !isKnown || (word.nextReviewDate ?? .distantPast) <= now
            }
            return false // isKnown nil ise, bu kelimeyi dahil etme
        }
        
        guard eligibleWords.count >= questionCount else {
            return nil
        }
        
        let quiz = Quiz()
        context.insert(quiz)
        
        let shuffledWords = eligibleWords.shuffled()
        let quizWords = Array(shuffledWords.prefix(questionCount))
        
        let allAnswers = words.compactMap { $0.isKnown != nil ? $0.turkish : nil }
        
        for word in quizWords {
            let correctAnswer = word.turkish
            var incorrectAnswers = allAnswers.filter { $0 != correctAnswer }
            incorrectAnswers.shuffle()
            
            let incorrectAnswer = incorrectAnswers.first ?? "Bilinmeyen"
            
            let question = QuizQuestion(word: word, incorrectAnswer: incorrectAnswer, quiz: quiz)
            context.insert(question)
            quiz.questions.append(question)
        }
        
        return quiz
    }
//        }
//    static func createQuiz(from words: [Word], questionCount: Int = 10, context: ModelContext) -> Quiz? {
//        
//        let unknownWords = words.filter { $0.isKnown == false }
//                
//                guard unknownWords.count >= questionCount else {
//                    return nil
//                }
//        
//        let quiz = Quiz()
//                context.insert(quiz)
//                
//                let shuffledWords = unknownWords.shuffled()
//                var quizWords = [Word]()
//                var usedWords = Set<String>()
//                
//                for word in shuffledWords {
//                    if !usedWords.contains(word.english) {
//                        quizWords.append(word)
//                        usedWords.insert(word.english)
//                    }
//                    
//                    if quizWords.count == questionCount {
//                        break
//                    }
//                }
//                
//                let allIncorrectAnswers = words.map { $0.turkish }
//                
//                for word in quizWords {
//                    let correctAnswer = word.turkish
//                    var incorrectAnswers = allIncorrectAnswers.filter { $0 != correctAnswer }
//                    incorrectAnswers.shuffle()
//                    
//                    let incorrectAnswer = incorrectAnswers.first ?? "Bilinmeyen"
//                    
//                    let question = QuizQuestion(word: word, incorrectAnswer: incorrectAnswer, quiz: quiz)
//                    context.insert(question)
//                    quiz.questions.append(question)
//                }
//                
//                return quiz
//            }
    func calculateScore() -> Int {
            let correctAnswers = questions.filter { $0.isCorrect == true }.count
            return questions.isEmpty ? 0 : (correctAnswers * 100) / questions.count
        }
        
        func completeQuiz() {
            self.completed = true
            self.score = calculateScore()
            questions.forEach { $0.word.updateAfterQuiz(wasCorrect: $0.isCorrect ?? false) }
        }
}
