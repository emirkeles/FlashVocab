//
//  StatisticsView.swift
//  FlashVocab
//
//  Created by Emir Keleş on 25.08.2024.
//

import SwiftUI
import SwiftData

struct StatisticsView: View {
    @Query private var words: [Word]
    @State private var selectedTimeRange: TimeRange = .week
    
    private let wordTypes = ["n.", "v.", "adj.", "adv.", "other"]
    private let colors: [Color] = [.blue, .green, .orange, .purple, .gray]
    
    var body: some View {
        List {
            LearningStatisticsSection(words: words, previousWords: previousWeekWords)
            LearningTrendSection(words: words, selectedTimeRange: $selectedTimeRange)
            WordTypeDistributionSection(words: words, selectedTimeRange: selectedTimeRange, wordTypes: wordTypes, colors: colors)
        }
        .navigationTitle("İstatistiklerim")
    }
    
    private var previousWeekWords: [Word] {
        let calendar = Calendar.current
        let oneWeekAgo = calendar.date(byAdding: .day, value: -7, to: Date())!
        let twoWeeksAgo = calendar.date(byAdding: .day, value: -14, to: Date())!
        
        return words.filter { word in
            guard let learnedDate = word.learnedDate else { return false }
            return learnedDate >= twoWeeksAgo && learnedDate <= oneWeekAgo
        }
    }
}
