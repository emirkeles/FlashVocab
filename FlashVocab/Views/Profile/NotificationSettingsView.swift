//
//  NotificationSettingsView.swift
//  FlashVocab
//
//  Created by Emir Keleş on 28.08.2024.
//

import SwiftUI

struct NotificationSettingsView: View {
    @State private var dailyReminderEnabled = true
    @State private var quizReminderEnabled = true
    @State private var streakReminderEnabled = true
    @State private var motivationReminderEnabled = true
    
    var body: some View {
        List {
            notificationSettingsSection
        }
        .onAppear {
            loadNotificationPreferences()
        }
        .navigationTitle("Bildirim Ayarları")
    }
    
    private func loadNotificationPreferences() {
        dailyReminderEnabled = UserDefaults.standard.bool(forKey: "dailyReminderEnabled")
        quizReminderEnabled = UserDefaults.standard.bool(forKey: "quizReminderEnabled")
        streakReminderEnabled = UserDefaults.standard.bool(forKey: "streakReminderEnabled")
        motivationReminderEnabled = UserDefaults.standard.bool(forKey: "motivationReminderEnabled")
    }
    
    private func updateNotificationPreferences() {
        UserDefaults.standard.set(dailyReminderEnabled, forKey: "dailyReminderEnabled")
        UserDefaults.standard.set(quizReminderEnabled, forKey: "quizReminderEnabled")
        UserDefaults.standard.set(streakReminderEnabled, forKey: "streakReminderEnabled")
        UserDefaults.standard.set(motivationReminderEnabled, forKey: "motivationReminderEnabled")
        
        NotificationManager.shared.updateNotificationPreferences(
            dailyReminder: dailyReminderEnabled,
            quizReminder: quizReminderEnabled,
            streakReminder: streakReminderEnabled,
            motivationalReminder: motivationReminderEnabled
        )
    }
    
    private var notificationSettingsSection: some View {
        VStack {
            Toggle("Günlük Hatırlatıcı", isOn: $dailyReminderEnabled)
                .onChange(of: dailyReminderEnabled) { _, newValue in
                    updateNotificationPreferences()
                }
            Toggle("Quiz Hatırlatıcı", isOn: $quizReminderEnabled)
                .onChange(of: quizReminderEnabled) { _, newValue in
                    updateNotificationPreferences()
                }
            Toggle("Streak Hatırlatıcı", isOn: $streakReminderEnabled)
                .onChange(of: streakReminderEnabled) { _, newValue in
                    updateNotificationPreferences()
                }
            Toggle("Motivasyon Bildirimi", isOn: $motivationReminderEnabled)
                .onChange(of: motivationReminderEnabled) { _, newValue in
                    updateNotificationPreferences()
                }
        }
    }
}

