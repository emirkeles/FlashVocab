//
//  ChangeIndicator.swift
//  FlashVocab
//
//  Created by Emir Keleş on 25.08.2024.
//

import SwiftUI

struct ChangeIndicator: View {
    let current: Int
    let previous: Int
    
    private var change: Int {
        current - previous
    }
    
    private var percentage: Double {
        guard previous != 0 else { return 0 }
        return Double(change) / Double(previous) * 100
    }
    
    var body: some View {
        HStack(spacing: 2) {
            Image(systemName: change >= 0 ? "arrow.up" : "arrow.down")
            Text(String(format: "%.1f%%", abs(percentage)))
        }
        .font(.caption)
        .foregroundColor(change >= 0 ? .green : .red)
        .padding(.horizontal, 6)
        .padding(.vertical, 2)
        .background(
            (change >= 0 ? Color.green : Color.red)
                .opacity(0.1)
                .cornerRadius(4)
        )
    }
}
