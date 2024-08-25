//
//  LearningStatisticsSection.swift
//  FlashVocab
//
//  Created by Emir Keleş on 25.08.2024.
//

import SwiftUI

struct LearningStatisticsSection: View {
    let words: [Word]
    let previousWords: [Word]
    
    var body: some View {
        Section(header: Text("Öğrenme İstatistikleri")) {
            StatisticRow(
                title: "Toplam Kelime Sayısı",
                value: words.count,
                icon: "book.fill",
                color: .blue,
                previousValue: previousWords.count
            )
            StatisticRow(
                title: "Bilinen Kelime Sayısı",
                value: words.filter{$0.isKnown == true}.count,
                icon: "checkmark.circle.fill",
                color: .green,
                previousValue: previousWords.filter{$0.isKnown == true}.count
            )
            StatisticRow(
                title: "Bilinmeyen Kelime Sayısı",
                value: words.filter { $0.isKnown == false }.count,
                icon: "xmark.circle.fill",
                color: .red,
                previousValue: previousWords.filter { $0.isKnown == false }.count
            )
            StatisticRow(
                title: "Yer İşaretli Kelime Sayısı",
                value: words.filter(\.bookmarked).count,
                icon: "bookmark.fill",
                color: .orange,
                previousValue: previousWords.filter(\.bookmarked).count
            )
        }
    }
}
