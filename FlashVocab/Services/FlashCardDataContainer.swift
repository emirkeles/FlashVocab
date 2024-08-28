//
//  FlashCardDataContainer.swift
//  FlashVocab
//
//  Created by Emir Keleş on 20.07.2024.
//

import Foundation
import SwiftUI
import SwiftData


struct FlashCardDataContainerViewModifier: ViewModifier {
    @AppStorage("currentWordVersion") var currentWordVersion = 0
    
    func body(content: Content) -> some View {
        content
            .modelContainer(for: [Word.self, Quiz.self, QuizQuestion.self, AppState.self]) { result in
                do {
                    let container = try result.get()
                    let context = container.mainContext
                    
                    guard let url = Bundle.main.url(forResource: "words", withExtension: "json") else {
                        fatalError("Failed to find words.json")
                    }
                    let data = try Data(contentsOf: url)
                    let wordVersion = try JSONDecoder().decode(WordVersion.self, from: data)
                    
                    if wordVersion.version > currentWordVersion {
                        for wordData in wordVersion.words {
                            if let existingWord = try context.fetch(FetchDescriptor<Word>(predicate: #Predicate { $0.english == wordData.english })).first {
                                // Mevcut kelimeyi güncelle (değişmeyen alanları koru)
                                existingWord.index = wordData.index
                                existingWord.turkish = wordData.turkish
                                existingWord.sentence = wordData.sentence
                                existingWord.phonetic = wordData.phonetic
                                existingWord.partOfSpeech = wordData.partOfSpeech
                                existingWord.englishMeanings = wordData.englishMeanings
                            } else {
                                // Yeni kelime ekle
                                let newWord = Word(index: wordData.index, english: wordData.english,
                                                   turkish: wordData.turkish,
                                                   sentence: wordData.sentence,
                                                   phonetic: wordData.phonetic,
                                                   partOfSpeech: wordData.partOfSpeech,
                                                   englishMeanings: wordData.englishMeanings
                                )
                                context.insert(newWord)
                            }
                        }
                        
                        currentWordVersion = wordVersion.version
                    }
                } catch {
                    print("Failed to update words: \(error)")
                }
            }
    }
}


extension View {
    func flashCardDataContainer() -> some View {
        modifier(FlashCardDataContainerViewModifier())
    }
}
