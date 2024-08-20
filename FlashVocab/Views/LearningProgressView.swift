//
//  LearningProgressView.swift
//  FlashVocab
//
//  Created by Emir Keleş on 10.08.2024.
//

import SwiftUI
import SwiftData
import Charts

struct LearningProgressView: View {
    @Query private var words: [Word]
    @State private var timeRange: TimeRange = .month
    
    enum TimeRange: String, CaseIterable {
        case week = "Hafta"
        case month = "Ay"
        case year = "Yıl"
    }
    
    var body: some View {
            VStack {
                Chart {
                    ForEach(groupedData, id: \.date) { item in
                        LineMark(
                            x: .value("Tarih", item.date, unit: chartDateUnit),
                            y: .value("Öğrenilen Kelimeler", item.count)
                        )
                        .interpolationMethod(.catmullRom)
                        
                        AreaMark(
                            x: .value("Tarih", item.date, unit: chartDateUnit),
                            y: .value("Öğrenilen Kelimeler", item.count)
                        )
                        .foregroundStyle(Color.blue.opacity(0.1))
                    }
                }
                .chartXAxis {
                    AxisMarks(values: .stride(by: chartDateUnit)) { value in
                        AxisGridLine()
                        AxisTick()
                        AxisValueLabel(format: chartDateFormat)
                    }
                }
                .chartYAxis {
                    AxisMarks { value in
                        AxisGridLine()
                        AxisTick()
                        AxisValueLabel()
                    }
                }
                .frame(height: 300)
                .padding()
                
            }
            .navigationTitle("Öğrenme İlerlemesi")
    }
    
    private var groupedData: [(date: Date, count: Int)] {
        let filteredWords = words.filter { word in
            guard let learnedDate = word.learnedDate else { return false }
            return learnedDate > Calendar.current.date(byAdding: calendarComponent, value: -calendarValue, to: Date())!
        }
        
        let grouped = Dictionary(grouping: filteredWords) { word in
            Calendar.current.startOfDay(for: word.learnedDate!)
        }
        
        return grouped.map { (date: $0.key, count: $0.value.count) }
            .sorted { $0.date < $1.date }
    }
    
    private var totalLearnedWords: Int {
        words.filter { $0.learnedDate != nil }.count
    }
    
    private var calendarComponent: Calendar.Component {
        switch timeRange {
        case .week: return .day
        case .month: return .day
        case .year: return .month
        }
    }
    
    private var calendarValue: Int {
        switch timeRange {
        case .week: return 7
        case .month: return 30
        case .year: return 12
        }
    }
    
    private var chartDateUnit: Calendar.Component {
        switch timeRange {
        case .week: return .day
        case .month: return .day
        case .year: return .month
        }
    }
    
    private var chartDateFormat: Date.FormatStyle {
        switch timeRange {
        case .week: return .dateTime.day().month()
        case .month: return .dateTime.day().month()
        case .year: return .dateTime.month()
        }
    }
}
#Preview {
    LearningProgressView()
}
