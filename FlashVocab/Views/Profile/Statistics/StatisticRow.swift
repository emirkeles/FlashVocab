//
//  StatisticRow.swift
//  FlashVocab
//
//  Created by Emir Keleş on 25.08.2024.
//

import SwiftUI

struct StatisticRow: View {
    let title: String
    let value: Int
    let icon: String
    let color: Color
    let previousValue: Int
    
    var body: some View {
        HStack {
            // Icon
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.system(size: 24))
                .frame(width: 32, height: 32)
            
            VStack(alignment: .leading, spacing: 4) {
                // Title
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                HStack(alignment: .firstTextBaseline, spacing: 8) {
                    // Value
                    Text("\(value)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    if (percentage != 0) {
                        ChangeIndicator(current: value, previous: previousValue)
                    }
                }
            }
            
            Spacer()
        }
        .padding(.vertical, 8)
    }
    
    private var change: Int {
        value - previousValue
    }
    
    private var percentage: Double {
        guard previousValue != 0 else { return 0 }
        return Double(change) / Double(previousValue) * 100
    }
}
