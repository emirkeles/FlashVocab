//
//  TimeRangePicker.swift
//  FlashVocab
//
//  Created by Emir Keleş on 25.08.2024.
//

import SwiftUI

struct TimeRangePicker: View {
    @Binding var selection: TimeRange
    
    var body: some View {
        Picker("Zaman Aralığı", selection: $selection) {
            ForEach(TimeRange.allCases, id: \.self) { range in
                Text(range.rawValue).tag(range)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
    }
}
