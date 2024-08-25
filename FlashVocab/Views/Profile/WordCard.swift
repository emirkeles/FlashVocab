//
//  WordCard.swift
//  FlashVocab
//
//  Created by Emir Keleş on 25.08.2024.
//

import SwiftUI

struct WordCard: View {
    let word: Word
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(word.english.capitalized)
                    .font(.title2)
                    .fontWeight(.bold)
                Spacer()
                Text("(\(word.partOfSpeech))")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Text(word.englishMeanings.first ?? "")
                .font(.subheadline)
            
            Text(word.sentence)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .padding(.top, 4)
            
            HStack {
                Text(word.learnedDate ?? Date(), style: .date)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Spacer()
                HStack {
                    Button(action: {
                        withAnimation {
                            HapticFeedbackManager.shared.playImpact()
                            speakWord()
                        }
                    }) {
                        Image(systemName: "speaker.wave.3")
                    }
                    Button(action: {
                        withAnimation {
                            HapticFeedbackManager.shared.playImpact()
                            word.bookmarked.toggle()
                        }
                    }) {
                        Image(systemName: word.bookmarked ? "bookmark.fill" : "bookmark")
                    }
                }
            }
            .padding(.top, 8)
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
    
    private func speakWord() {
        SpeechSynthesizer.shared.speak(word.english)
    }
}
