//
//  LearnedWord.swift
//  FlashVocab
//
//  Created by Emir Keleş on 17.07.2024.
//

import Foundation

struct LearnedWord: Identifiable {
    let id = UUID()
    let date: Date
    let count: Int
}
