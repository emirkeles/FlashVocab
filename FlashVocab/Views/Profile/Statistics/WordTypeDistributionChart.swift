//
//  WordTypeDistributionChart.swift
//  FlashVocab
//
//  Created by Emir Keleş on 25.08.2024.
//

import Foundation
import SwiftUI
import Charts

struct WordTypeDistributionChart: View {
    let distribution: [(type: String, count: Int)]
    let wordTypes: [String]
    let colors: [Color]
    
    var body: some View {
        Chart {
            ForEach(distribution, id: \.type) { item in
                SectorMark(
                    angle: .value("Sayı", item.count),
                    innerRadius: .ratio(0.618),
                    angularInset: 1.5
                )
                .foregroundStyle(by: .value("Tür", item.type))
                .annotation(position: .overlay) {
                    Text("\(item.count)")
                        .font(.caption)
                        .foregroundStyle(.white)
                }
            }
        }
        .frame(height: 200)
        .chartForegroundStyleScale(domain: wordTypes, range: colors)
        .chartLegend(position: .bottom, spacing: 20)
    }
}
