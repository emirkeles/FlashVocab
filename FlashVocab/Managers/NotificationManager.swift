//
//  NotificationManager.swift
//  FlashVocab
//
//  Created by Emir Keleş on 28.08.2024.
//
import UserNotifications
import SwiftUI

class NotificationManager: NSObject, UNUserNotificationCenterDelegate {
    static let shared = NotificationManager()
    
    override private init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }
    
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Notification permission granted")
            } else {
                print("Notification permission denied")
            }
        }
    }
    
    func scheduleReviewReminder(for word: Word) {
        let content = UNMutableNotificationContent()
        content.title = "Kelime Tekrarı Zamanı!"
        content.body = "\(word.english) kelimesini tekrar etme zamanı geldi."
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: calculateNextReviewInterval(for: word), repeats: false)
        
        let request = UNNotificationRequest(identifier: "review-\(word.id)", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    func scheduleDailyReminder() {
        let content = UNMutableNotificationContent()
        content.title = "FlashVocab"
        content.body = "Bugün yeni kelimeler öğrenmeye ne dersiniz?"
        content.sound = .default
        
        var dateComponents = DateComponents()
        dateComponents.hour = 20
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(identifier: "daily-reminder", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    func scheduleStreakReminderIfNeeded() {
        let streakManager = StreakManager.shared
        let calendar = Calendar.current
        
        guard let lastActivityDate = streakManager.lastActivityDate else {
            scheduleStreakReminder(currentStreak: 0)
            return
        }
        
        let currentDate = Date()
        let lastActivityDay = calendar.startOfDay(for: lastActivityDate)
        let currentDay = calendar.startOfDay(for: currentDate)
        
        if lastActivityDay < currentDay {
            // Son aktivite bugünden önceyse ve streak risk altındaysa bildirim gönder
            scheduleStreakReminder(currentStreak: streakManager.currentStreak)
        } else {
            // Bugün zaten aktivite var, bildirim göndermeye gerek yok
            cancelStreakReminder()
        }
    }
    
    private func scheduleStreakReminder(currentStreak: Int) {
        let content = UNMutableNotificationContent()
        content.title = "Öğrenme Streaki'nizi Koruyun!"
        content.body = "Şu anki streaki'niz \(currentStreak) gün. Hadi bu günü de kaçırmayalım!"
        content.sound = .default
        
        var dateComponents = DateComponents()
        dateComponents.hour = 21 // Akşam 9'da bildirim gönder
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        let request = UNNotificationRequest(identifier: "streak-reminder", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Streak reminder scheduling failed: \(error.localizedDescription)")
            }
        }
    }
    
    func cancelStreakReminder() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["streak-reminder"])
    }
    
    private func calculateNextReviewInterval(for word: Word) -> TimeInterval {
        switch word.reviewCount {
        case 0:
            return 24 * 60 * 60
        case 1:
            return 3 * 24 * 60 * 60
        case 2:
            return 7 * 24 * 60 * 60
        default:
            return 30 * 24 * 60 * 60
        }
    }
    
    // MARK: - Quiz Hatırlatıcısı
    func scheduleQuizReminder(quizType: String, time: Date) {
        let content = UNMutableNotificationContent()
        content.title = "Quiz Zamanı!"
        content.body = "\(quizType) quizi için hazır mısınız? Hadi bilgilerinizi test edelim!"
        content.sound = .default
        
        let components = Calendar.current.dateComponents([.hour, .minute], from: time)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        
        let request = UNNotificationRequest(identifier: "quiz-reminder-\(quizType)", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
    
    func updateNotificationPreferences(dailyReminder: Bool, quizReminder: Bool, streakReminder: Bool, motivationalReminder: Bool) {
        let center = UNUserNotificationCenter.current()
        if dailyReminder {
            scheduleDailyReminder()
        } else {
            center.removePendingNotificationRequests(withIdentifiers: ["daily-reminder"])
        }
        
        if quizReminder {
            scheduleQuizReminder(quizType: "Haftalık", time: Date().addingTimeInterval(7*24*60*60)) // Örnek: 1 hafta sonra
        } else {
            center.removePendingNotificationRequests(withIdentifiers: ["quiz-reminder-Haftalık"])
        }
        
        if streakReminder {
            scheduleStreakReminderIfNeeded()
        } else {
            center.removePendingNotificationRequests(withIdentifiers: ["streak-reminder"])
        }
        
        if motivationalReminder {
            scheduleDailyMotivationalMessage()
        } else {
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["dailyMotivation"])
        }
    }
    
    // MARK: - Motivasyon Mesajı
    func scheduleDailyMotivationalMessage() {
        let content = UNMutableNotificationContent()
        content.title = "FlashVocab"
        content.body = getRandomMotivationalMessage()
        content.sound = .default
        
        var dateComponents = DateComponents()
        dateComponents.hour = 16
        dateComponents.minute = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "dailyMotivation", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Daily motivational message scheduling failed: \(error.localizedDescription)")
            } else {
                print("Daily motivational message scheduled successfully")
            }
        }
    }
    
    func getRandomMotivationalMessage() -> String {
        let messages = [
            "Bugün yeni bir şey öğrenmek için harika bir gün!",
            "Her kelime seni hedefine bir adım daha yaklaştırır.",
            "Süreklilik başarının anahtarıdır. Devam et!",
            "Kendini geliştirmek için ayırdığın zaman, en iyi yatırımdır.",
            "Küçük adımlar büyük yolculukların başlangıcıdır.",
            "Bugün öğrendiğin bir kelime, yarın kullanacağın bir araç olabilir.",
            "Zorluklar seni daha güçlü yapar. Her yeni kelime bir zaferdir!",
            "Dil öğrenmek bir maraton, not a sprint. Her gün ilerlemeye devam et!",
            "Bilgi güçtür. Her yeni kelimeyle daha da güçleniyorsun.",
            "Başarı yolculuğunda her gün yeni bir adım at. Sen yapabilirsin!"
        ]
        return messages.randomElement() ?? "Öğrenmeye devam et!"
    }
}

extension Word {
    func scheduleReviewNotification() {
        NotificationManager.shared.scheduleReviewReminder(for: self)
    }
}
