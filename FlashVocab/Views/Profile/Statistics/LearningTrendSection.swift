//
//  LearningTrendSection.swift
//  FlashVocab
//
//  Created by Emir Keleş on 25.08.2024.
//

import SwiftUI

struct LearningTrendSection: View {
    let words: [Word]
    @Binding var selectedTimeRange: TimeRange
    
    var body: some View {
        Section(header: Text("Öğrenme Trendi")) {
//            TimeRangePicker(selection: $selectedTimeRange)
            LearningTrendChart(data: learningTrendData())
        }
    }
    
    private func learningTrendData() -> [(date: Date, count: Int)] {
        let startDate = selectedTimeRange.startDate
        return words.filter { $0.learnedDate ?? .distantPast >= startDate }
            .reduce(into: [:]) { counts, word in
                let date = Calendar.current.startOfDay(for: word.learnedDate ?? Date())
                counts[date, default: 0] += 1
            }
            .sorted { $0.key < $1.key }
            .map { (date: $0.key, count: $0.value) }
    }
}
