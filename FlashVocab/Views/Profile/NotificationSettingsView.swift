//
//  NotificationSettingsView.swift
//  FlashVocab
//
//  Created by Emir Keleş on 28.08.2024.
//

import SwiftUI

struct NotificationSettingsView: View {
    @State private var dailyReminderEnabled = false
    @State private var quizReminderEnabled = false
    @State private var streakReminderEnabled = false
    @State private var motivationReminderEnabled = false
    @State private var showingPermissionAlert = false
    @State private var notificationsAuthorized = false
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some View {
        List {
            notificationSettingsSection
        }
        .onAppear {
            checkNotificationPermission()
        }
        .onChange(of: scenePhase, { oldValue, newValue in
            if newValue == .active {
                checkNotificationPermission()
            }
        })
        .navigationTitle("Bildirim Ayarları")
        .alert(isPresented: $showingPermissionAlert) {
            Alert(
                title: Text("Bildirim İzni Gerekli"),
                message: Text("Bildirimleri alabilmek için lütfen ayarlardan FlashVocab uygulamasına bildirim izni verin."),
                primaryButton: .default(Text("Ayarlara Git")) {
                    if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(settingsURL)
                    }
                },
                secondaryButton: .cancel()
            )
        }
    }
    
    private func checkNotificationPermission() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                self.notificationsAuthorized = settings.authorizationStatus == .authorized
                if self.notificationsAuthorized {
                    self.loadNotificationPreferences()
                } else {
                    self.resetNotificationPreferences()
                    self.showingPermissionAlert = true
                }
            }
        }
    }
    
    private func loadNotificationPreferences() {
        dailyReminderEnabled = UserDefaults.standard.bool(forKey: "dailyReminderEnabled")
        quizReminderEnabled = UserDefaults.standard.bool(forKey: "quizReminderEnabled")
        streakReminderEnabled = UserDefaults.standard.bool(forKey: "streakReminderEnabled")
        motivationReminderEnabled = UserDefaults.standard.bool(forKey: "motivationReminderEnabled")
    }
    
    private func resetNotificationPreferences() {
        dailyReminderEnabled = false
        quizReminderEnabled = false
        streakReminderEnabled = false
        motivationReminderEnabled = false
    }
    
    
    private func updateNotificationPreferences() {
        if notificationsAuthorized {
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
    }
    
    private func handleToggleChange(isOn: Bool, for toggleBinding: Binding<Bool>) {
        if !notificationsAuthorized && isOn {
            showingPermissionAlert = true
            toggleBinding.wrappedValue = false
        } else {
            updateNotificationPreferences()
        }
    }
    
    private var notificationSettingsSection: some View {
        VStack {
            Toggle("Günlük Hatırlatıcı", isOn: $dailyReminderEnabled)
                .onChange(of: dailyReminderEnabled) { _, newValue in
                    handleToggleChange(isOn: newValue, for: $dailyReminderEnabled)
                }
            Toggle("Quiz Hatırlatıcı", isOn: $quizReminderEnabled)
                .onChange(of: quizReminderEnabled) { _, newValue in
                    handleToggleChange(isOn: newValue, for: $quizReminderEnabled)
                }
            Toggle("Streak Hatırlatıcı", isOn: $streakReminderEnabled)
                .onChange(of: streakReminderEnabled) { _, newValue in
                    handleToggleChange(isOn: newValue, for: $streakReminderEnabled)
                }
            Toggle("Motivasyon Bildirimi", isOn: $motivationReminderEnabled)
                .onChange(of: motivationReminderEnabled) { _, newValue in
                    handleToggleChange(isOn: newValue, for: $motivationReminderEnabled)
                }
        }
    }
}

