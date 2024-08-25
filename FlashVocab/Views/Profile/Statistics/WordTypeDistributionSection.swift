//
//  WordTypeDistributionSection.swift
//  FlashVocab
//
//  Created by Emir Keleş on 25.08.2024.
//

import SwiftUI


struct WordTypeDistributionSection: View {
    let words: [Word]
    let selectedTimeRange: TimeRange
    let wordTypes: [String]
    let colors: [Color]
    
    var body: some View {
        Section(header: Text("Kelime Türleri Dağılımı")) {
            let distribution = wordTypeDistribution()
            if distribution.isEmpty {
                Text("Bu zaman aralığında öğrenilen kelime yok.")
                    .foregroundColor(.secondary)
                    .padding()
            } else {
                WordTypeDistributionChart(distribution: distribution, wordTypes: wordTypes, colors: colors)
            }
        }
    }
    
    private func wordTypeDistribution() -> [(type: String, count: Int)] {
        let startDate = selectedTimeRange.startDate
        let learnedWords = words.filter { ($0.learnedDate ?? .distantPast) >= startDate && $0.isKnown == true }
        
        var distribution = wordTypes.reduce(into: [:]) { counts, type in
            counts[type] = learnedWords.filter { $0.partOfSpeech == type }.count
        }
        
        let otherCount = learnedWords.filter { !wordTypes.contains($0.partOfSpeech) }.count
        distribution["other"] = (distribution["other"] ?? 0) + otherCount
        
        return wordTypes.compactMap { type in
            let count = distribution[type] ?? 0
            return count > 0 ? (type: type, count: count) : nil
        }
    }
}
