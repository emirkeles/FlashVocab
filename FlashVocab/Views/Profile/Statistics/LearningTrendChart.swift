//
//  LearningTrendChart.swift
//  FlashVocab
//
//  Created by Emir Keleş on 25.08.2024.
//

import SwiftUI
import Charts

struct LearningTrendChart: View {
    let data: [(date: Date, count: Int)]
    
    var body: some View {
        Chart {
            ForEach(data, id: \.date) { item in
                LineMark(x: .value("Tarih", item.date), y: .value("Öğrenilen Kelime", item.count))
                PointMark(x: .value("Tarih", item.date), y: .value("Öğrenilen Kelime", item.count))
            }
        }
        .frame(height: 200)
        .chartXAxis { AxisMarks(values: .automatic(desiredCount: 5)) }
        .chartYAxis { AxisMarks(position: .leading) }
    }
}
