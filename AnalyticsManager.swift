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
    
    func logAppOpen() {
        logEvent("app_open")
    }
    
    func logWordLearned(word: String) {
        logEvent("word_learned", parameters: ["word": word])
    }
    
    func logQuizStarted(questionCount: Int) {
        logEvent("quiz_started", parameters: ["question_count": questionCount])
    }
    
    func logQuizQuestionAnswered(questionIndex: Int, correct: Bool) {
        logEvent("quiz_question_answered", parameters: [
            "question_index": questionIndex,
            "correct": correct
        ])
    }
    
    func logQuizCompleted(score: Int, totalQuestions: Int) {
        logEvent("quiz_completed", parameters: [
            "score": score,
            "total_questions": totalQuestions,
            "percentage": Double(score) / Double(totalQuestions)
        ])
    }
    
    func logQuizNoAvailable() {
        logEvent("quiz_no_available")
    }
    
    func logQuizRestarted() {
        logEvent("quiz_restarted")
    }
    
    func logFlashCardReviewed(word: String, known: Bool) {
        logEvent("flashcard_reviewed", parameters: [
            "word": word,
            "known": known
        ])
    }
    
    func logFlashCardSessionStarted(cardCount: Int) {
        logEvent("flashcard_session_started", parameters: ["card_count": cardCount])
    }
    
    func logFlashCardSwiped(word: String, direction: String) {
        logEvent("flashcard_swiped", parameters: [
            "word": word,
            "direction": direction
        ])
    }
    
    func logFlashCardSessionCompleted(cardsReviewed: Int) {
        logEvent("flashcard_session_completed", parameters: ["cards_reviewed": cardsReviewed])
    }
    
    func logFlashCardResumed(atIndex: Int) {
        logEvent("flashcard_session_resumed", parameters: ["resumed_at_index": atIndex])
    }
    
    func logWordBookmarked(word: String) {
        logEvent("word_bookmarked", parameters: ["word": word])
    }
    
    func logWordUnbookmarked(word: String) {
        logEvent("word_unbookmarked", parameters: ["word": word])
    }
    
    func logSearch(query: String) {
        logEvent("search_performed", parameters: ["query": query])
    }
    
    func logScreenView(screenName: String, screenClass: String) {
        Analytics.logEvent(AnalyticsEventScreenView,
                           parameters: [AnalyticsParameterScreenName: screenName,
                                       AnalyticsParameterScreenClass: screenClass])
    }
    
    func setUserProperty(value: String?, forName name: String) {
        Analytics.setUserProperty(value, forName: name)
    }
    
    func setUserID(_ userID: String) {
        Analytics.setUserID(userID)
    }
    
    func logCardFlipped(word: String) {
        logEvent("card_flipped", parameters: ["word": word])
    }
    
    func logCardBookmarked(word: String) {
        logEvent("card_bookmarked", parameters: ["word": word])
    }
    
    func logCardUnbookmarked(word: String) {
        logEvent("card_unbookmarked", parameters: ["word": word])
    }
    
    func logWordSpoken(word: String) {
        logEvent("word_spoken", parameters: ["word": word])
    }
    
    func logTabSelected(tab: String) {
        logEvent("tab_selected", parameters: ["tab": tab])
    }
    
    func logMenuItemSelected(item: String) {
        logEvent("menu_item_selected", parameters: ["item": item])
    }
    
    func logStreakUpdated(streakCount: Int) {
        logEvent("streak_updated", parameters: ["streak_count": streakCount])
    }
    
    func logAppOpened() {
        logEvent("app_opened")
    }
    
    func logWordReviewed(word: String, wasCorrect: Bool, reviewCount: Int) {
        logEvent("word_reviewed", parameters: [
            "word": word,
            "was_correct": wasCorrect,
            "review_count": reviewCount
        ])
    }
    
    func logWordMastered(word: String) {
        logEvent("word_mastered", parameters: ["word": word])
    }
    
    func logNextReviewScheduled(word: String, daysUntilReview: Int) {
        logEvent("next_review_scheduled", parameters: [
            "word": word,
            "days_until_review": daysUntilReview
        ])
    }
    
    func logTimeRangeChanged(to range: String) {
        logEvent("statistics_time_range_changed", parameters: ["range": range])
    }
    
    func logBookmarkedFlashCardSessionStarted(cardCount: Int) {
        logEvent("bookmarked_flashcard_session_started", parameters: ["card_count": cardCount])
    }
    
    func logBookmarkedFlashCardSwiped(word: String, direction: String) {
        logEvent("bookmarked_flashcard_swiped", parameters: [
            "word": word,
            "direction": direction
        ])
    }
    
    func logBookmarkedFlashCardRemoved(word: String) {
        logEvent("bookmarked_flashcard_removed", parameters: ["word": word])
    }
    
    func logBookmarkedFlashCardSessionCompleted(cardsReviewed: Int) {
        logEvent("bookmarked_flashcard_session_completed", parameters: ["cards_reviewed": cardsReviewed])
    }
    
    func logQuizDetailViewed(quizScore: Int, totalQuestions: Int, correctAnswers: Int) {
        logEvent("quiz_detail_viewed", parameters: [
            "quiz_score": quizScore,
            "total_questions": totalQuestions,
            "correct_answers": correctAnswers,
            "accuracy_percentage": Double(correctAnswers) / Double(totalQuestions) * 100
        ])
    }
    
    func logQuestionDetailViewed(questionIndex: Int, isCorrect: Bool, word: String) {
        logEvent("question_detail_viewed", parameters: [
            "question_index": questionIndex,
            "is_correct": isCorrect,
            "word": word
        ])
    }
    
    func logPerformanceAnalysisViewed() {
        logEvent("performance_analysis_viewed")
    }
    
    func logIsKnownViewOpened(isKnown: Bool, wordCount: Int) {
        logEvent("is_known_view_opened", parameters: [
            "is_known": isKnown,
            "word_count": wordCount
        ])
    }
    
    func logWordSearchPerformed(isKnown: Bool, query: String, resultCount: Int) {
        logEvent("word_search_performed", parameters: [
            "is_known": isKnown,
            "query": query,
            "result_count": resultCount
        ])
    }
    
    func logWordDetailViewed(word: String, isKnown: Bool) {
        logEvent("word_detail_viewed", parameters: [
            "word": word,
            "is_known": isKnown
        ])
    }
    
    func logBookmarkedWordsViewOpened(wordCount: Int) {
        logEvent("bookmarked_words_view_opened", parameters: [
            "word_count": wordCount
        ])
    }
    
    func logBookmarkedWordSearchPerformed(query: String, resultCount: Int) {
        logEvent("bookmarked_word_search_performed", parameters: [
            "query": query,
            "result_count": resultCount
        ])
    }
    
    func logBookmarkedWordDetailViewed(word: String) {
        logEvent("bookmarked_word_detail_viewed", parameters: [
            "word": word
        ])
    }
    
}
