//
//  StreakManager.swift
//  FlashVocab
//
//  Created by Emir Keleş on 25.08.2024.
//

import SwiftUI

class StreakManager {
    static let shared = StreakManager()
    
    private let defaults = UserDefaults.standard
    private let streakKey = "currentStreak"
    private let lastActivityDateKey = "lastActivityDate"
    
    var currentStreak: Int {
        get { defaults.integer(forKey: streakKey) }
        set { defaults.set(newValue, forKey: streakKey) }
    }
    
    var lastActivityDate: Date? {
        get { defaults.object(forKey: lastActivityDateKey) as? Date }
        set { defaults.set(newValue, forKey: lastActivityDateKey) }
    }
    
    func updateStreak() {
        let calendar = Calendar.current
        let currentDate = Date()
        
        if let lastDate = lastActivityDate,
           let lastActivityDay = calendar.dateComponents([.day], from: lastDate).day,
           let currentDay = calendar.dateComponents([.day], from: currentDate).day {
            
            let dayDifference = currentDay - lastActivityDay
            
            if dayDifference == 0 {
                // Same day, do nothing
            } else if dayDifference == 1 {
                // Next day, increment streak
                currentStreak += 1
            } else {
                // More than one day passed, reset streak
                currentStreak = 1
            }
        } else {
            // First activity or data corrupted, start new streak
            currentStreak = 1
        }
        lastActivityDate = currentDate
        
        NotificationManager.shared.scheduleStreakReminderIfNeeded()
    }
}

struct StreakView: View {
    @State private var streak: Int = StreakManager.shared.currentStreak
    
    var body: some View {
        HStack(spacing: 4) {
            Text("\(Text("x").font(.title2))\(streak)")
                .foregroundStyle(streak > 10 ? .red : streak > 5 ? .orange : .yellow)
                .font(.largeTitle)
                .fontDesign(.monospaced)
            Image(systemName: "flame.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40)
                .foregroundStyle(streak > 10 ? .red : streak > 5 ? .orange : .yellow)
        }
        .onAppear {
            streak = StreakManager.shared.currentStreak
            AnalyticsManager.shared.logStreakUpdated(streakCount: StreakManager.shared.currentStreak)
        }
    }
}
