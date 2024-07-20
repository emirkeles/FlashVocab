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
    enum CodingKeys: CodingKey {
        case index, english, turkish, sentence, isKnown
    }
    var index: Int
    var english: String
    var turkish: String
    var sentence: String
    var isKnown: Bool
    var didKnow: Bool?
    var learnedDate: Date?
    
    init(index: Int, english: String, turkish: String, sentence: String, isKnown: Bool = false, didKnow: Bool? = nil, learnedDate: Date? = nil) {
        self.index = index
        self.english = english
        self.turkish = turkish
        self.sentence = sentence
        self.isKnown = isKnown
        self.didKnow = didKnow
        self.learnedDate = learnedDate
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.index = try container.decode(Int.self, forKey: .index)
        self.english = try container.decode(String.self, forKey: .english)
        self.turkish = try container.decode(String.self, forKey: .turkish)
        self.sentence = try container.decode(String.self, forKey: .sentence)
        self.isKnown = try container.decode(Bool.self, forKey: .isKnown)
    }
}
