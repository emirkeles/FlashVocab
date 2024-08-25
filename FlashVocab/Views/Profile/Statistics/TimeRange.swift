//
//  TimeRange.swift
//  FlashVocab
//
//  Created by Emir Keleş on 25.08.2024.
//

import Foundation

enum TimeRange: String, CaseIterable {
    case week = "Hafta"
    case month = "Ay"
    case year = "Yıl"
    
    var startDate: Date {
        let calendar = Calendar.current
        let now = Date()
        switch self {
        case .week: return calendar.date(byAdding: .day, value: -7, to: now)!
        case .month: return calendar.date(byAdding: .month, value: -1, to: now)!
        case .year: return calendar.date(byAdding: .year, value: -1, to: now)!
        }
    }
}
