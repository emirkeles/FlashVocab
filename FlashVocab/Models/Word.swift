//
//  Item.swift
//  FlashVocab
//
//  Created by Emir Keleş on 17.07.2024.
//

import Foundation
import SwiftData



@Model
final class Word: Hashable, Decodable, Identifiable {
    enum CodingKeys: String, CodingKey {
        case index, english, turkish, sentence, phonetic, partOfSpeech, englishMeanings
    }
    var index: Int
    @Attribute(.unique) let english: String
    var turkish: String
    var sentence: String
    var phonetic: String
    var partOfSpeech: String
    var englishMeanings: [String]
    
    var isKnown: Bool?
    var learnedDate: Date?
    var lastReviewDate: Date?
    var nextReviewDate: Date?
    var reviewCount: Int = 0
    var bookmarked: Bool
    
    init(
        index: Int,
        english: String,
        turkish: String,
        sentence: String,
        phonetic: String,
        partOfSpeech: String,
        englishMeanings: [String],
        isKnown: Bool? = nil,
        learnedDate: Date? = nil,
        lastReviewDate: Date? = nil,
        nextReviewDate: Date? = nil,
        bookmarked: Bool = false
    ) {
        self.index = index
        self.english = english
        self.turkish = turkish
        self.sentence = sentence
        self.phonetic = phonetic
        self.partOfSpeech = partOfSpeech
        self.englishMeanings = englishMeanings
        self.isKnown = isKnown
        self.learnedDate = learnedDate
        self.lastReviewDate = lastReviewDate
        self.nextReviewDate = nextReviewDate
        self.bookmarked = bookmarked
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.index = try container.decode(Int.self, forKey: .index)
        self.english = try container.decode(String.self, forKey: .english)
        self.turkish = try container.decode(String.self, forKey: .turkish)
        self.sentence = try container.decode(String.self, forKey: .sentence)
        self.phonetic = try container.decode(String.self, forKey: .phonetic)
        self.partOfSpeech = try container.decode(String.self, forKey: .partOfSpeech)
        self.englishMeanings = try container.decode([String].self, forKey: .englishMeanings)
        
        self.isKnown = nil
        self.learnedDate = nil
        self.lastReviewDate = nil
        self.nextReviewDate = nil
        self.bookmarked = false
    }
}

struct WordData: Codable {
    let english: String
    let index: Int
    let turkish: String
    let sentence: String
    let phonetic: String
    let partOfSpeech: String
    let englishMeanings: [String]
}

struct WordVersion: Codable {
    let version: Int
    let words: [WordData]
}

extension Word {
    
    func updateAfterQuiz(wasCorrect: Bool) {
        if wasCorrect {
            reviewCount += 1
            lastReviewDate = Date()
            if learnedDate == nil {
                learnedDate = Date()
                AnalyticsManager.shared.logWordLearned(word: english)
            }
            calculateNextReviewDate()
        } else {
            reviewCount = max(0, reviewCount-1)
            nextReviewDate = Date()
        }
        AnalyticsManager.shared.logFlashCardReviewed(word: english, known: wasCorrect)
        isKnown = reviewCount >= 3
    }
    
    private func calculateNextReviewDate() {
        let interval: TimeInterval
        switch reviewCount {
        case 0:
            interval = 1 * 24 * 60 * 60 // 1 gün
        case 1:
            interval = 3 * 24 * 60 * 60 // 3 gün
        case 2:
            interval = 7 * 24 * 60 * 60 // 1 hafta
        default:
            interval = 90 * 24 * 60 * 60 // 3 ay
        }
        nextReviewDate = Date().addingTimeInterval(interval)
    }
    
    static var bookmarkedWords: FetchDescriptor<Word> {
        FetchDescriptor(predicate: #Predicate { $0.bookmarked == true }, sortBy: [SortDescriptor(\.index)])
    }
    
    static var all: FetchDescriptor<Word> {
        FetchDescriptor(sortBy: [SortDescriptor(\.index)])
    }
    
    static var allWordsSortedByIndex: FetchDescriptor<Word> {
        var descriptor = FetchDescriptor<Word>(sortBy: [SortDescriptor(\.index)])
        descriptor.fetchLimit = 1000
        return descriptor
    }
    
    static var unknownWords: FetchDescriptor<Word> {
        let descriptor = FetchDescriptor<Word>(predicate: #Predicate { $0.isKnown == false })
        return descriptor
    }
    
    static var knownWords: FetchDescriptor<Word> {
        let descriptor = FetchDescriptor<Word>(predicate: #Predicate { $0.isKnown == true })
        return descriptor
    }
    
    static var wordsNeedingReview: FetchDescriptor<Word> {
        let now = Date()
        let distantPast = Date.distantPast
        var descriptor = FetchDescriptor<Word>(predicate: #Predicate<Word> { word in
            word.isKnown == true && (word.nextReviewDate ?? distantPast) <= now
        })
        descriptor.sortBy = [SortDescriptor(\.nextReviewDate, order: .forward)]
        return descriptor
    }
}

