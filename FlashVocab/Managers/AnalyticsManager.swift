//
//  AnalyticsManager.swift
//  FlashVocab
//
//  Created by Emir Keleş on 26.08.2024.
//

import Foundation
import FirebaseAnalytics

final class AnalyticsManager {
    static let shared = AnalyticsManager()
    private init() { }
    
    func logEvent(_ name: String, parameters: [String: Any]? = nil) {
        Analytics.logEvent(name, parameters: parameters)
    }
    // MARK: - Uygulama Kullanımı
    func logAppOpen() {
        logEvent("app_open")
    }
    
    func logScreenView(screenName: String, screenClass: String) {
        Analytics.logEvent(AnalyticsEventScreenView,
                           parameters: [AnalyticsParameterScreenName: screenName,
                                       AnalyticsParameterScreenClass: screenClass])
    }
    
    func logMenuItemSelected(item: String) {
        logEvent("menu_item_selected", parameters: ["item": item])
    }
    
    // MARK: - Kelime Öğrenme
    func logWordLearned(word: String) {
        logEvent("word_learned", parameters: ["word": word])
    }
    
    func logWordReviewed(word: String, wasCorrect: Bool) {
        logEvent("word_reviewed", parameters: [
            "word": word,
            "was_correct": wasCorrect
        ])
    }
    
    // MARK: - Quiz İşlemleri
    func logQuizStarted(questionCount: Int) {
        logEvent("quiz_started", parameters: ["question_count": questionCount])
    }
    
    func logQuizCompleted(score: Int, totalQuestions: Int) {
        logEvent("quiz_completed", parameters: [
            "score": score,
            "total_questions": totalQuestions,
            "percentage": Double(score) / Double(totalQuestions)
        ])
    }
    
    func logQuizQuestionAnswered(questionWord: String, correct: Bool) {
           logEvent("quiz_question_answered", parameters: [
               "question_word": questionWord,
               "correct": correct
           ])
       }
    
    // MARK: - FlashCard İşlemleri
    func logFlashCardSessionStarted(cardCount: Int) {
        logEvent("flashcard_session_started", parameters: ["card_count": cardCount])
    }
    
    func logFlashCardReviewed(word: String, known: Bool) {
        logEvent("flashcard_reviewed", parameters: [
            "word": word,
            "known": known
        ])
    }
    
    func logFlashCardSwiped(word: String, direction: String) {
        logEvent("flashcard_swiped", parameters: [
            "word": word,
            "direction": direction
        ])
    }
    
    // MARK: - Bookmark İşlemleri
    func logWordBookmarked(word: String) {
        logEvent("word_bookmarked", parameters: ["word": word])
    }
    
    func logWordUnbookmarked(word: String) {
        logEvent("word_unbookmarked", parameters: ["word": word])
    }
    
    // MARK: - Kullanıcı Özellikleri
    func setUserProperty(value: String?, forName name: String) {
        Analytics.setUserProperty(value, forName: name)
    }
    
    func setUserID(_ userID: String) {
        Analytics.setUserID(userID)
    }
    
    // MARK: - Streak
    func logStreakUpdated(streakCount: Int) {
        logEvent("streak_updated", parameters: ["streak_count": streakCount])
    }
    
    // MARK: - Feedback
    func logFeedbackButtonTapped(result: String) {
        logEvent("feedback_tapped", parameters: ["result": result])
    }
    
}
