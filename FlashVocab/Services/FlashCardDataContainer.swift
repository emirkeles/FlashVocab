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
    
    func body(content: Content) -> some View {
        content
            .modelContainer(for: [Word.self, Quiz.self, QuizQuestion.self, AppState.self]) { result in
                do {
                    let container = try result.get()
                    let descriptor = FetchDescriptor<Word>()
                    let existingWords = try container.mainContext.fetchCount(descriptor)
                    
                    guard existingWords == 0 else { return }
                    
                    guard let url = Bundle.main.url(forResource: "words", withExtension: "json") else {
                        fatalError("Failed to find users.json")
                    }
                    let data = try Data(contentsOf: url)
                    do {
                        let words = try JSONDecoder().decode([Word].self, from: data)
                        for word in words {
                            print("\(word)'ü eklerim aga")
                            container.mainContext.insert(word)
                        }
                    } catch {
                        print("decode hatası")
                    }
                } catch {
                    print("Failed to pre-seed database.")
                }
            }
    }
}

extension View {
    func flashCardDataContainer(inMemory: Bool = true) -> some View {
        modifier(FlashCardDataContainerViewModifier())
    }
}
