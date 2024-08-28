//
//  FlashVocabApp.swift
//  FlashVocab
//
//  Created by Emir Keleş on 17.07.2024.
//

import SwiftUI
import PopupView
import FirebaseCore
import FirebaseAnalytics

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        NotificationManager.shared.requestAuthorization()
        NotificationManager.shared.scheduleDailyReminder()
        
        return true
    }
}

@main
struct FlashVocabApp: App {
    @State private var showToast = false
    @State private var toastManager = ToastManager.shared
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .analyticsScreen(name: "FlashVocabApp")
                .onAppear {
                    setupUserProperties()
                }
                .onAppear {
                    AnalyticsManager.shared.logAppOpen()
                }
                .modifier(
                    ToastViewModifier(
                        isPresented: $toastManager.showToast,
                        icon: $toastManager.toastIcon,
                        title: $toastManager.toastTitle,
                        color: toastManager.color
                    )
                )
                .flashCardDataContainer()
        }
    }
    
    private func setupUserProperties() {
        AnalyticsManager.shared.setUserProperty(value: Locale.current.language.languageCode?.identifier, forName: "language")
        AnalyticsManager.shared.setUserProperty(value: UIDevice.current.name, forName: "device_name")
        AnalyticsManager.shared.setUserProperty(value: UIDevice.current.systemVersion, forName: "ios_version")
        if let userId = UserDefaults.standard.string(forKey: "userId") {
            AnalyticsManager.shared.setUserID(userId)
        } else {
            let newUserId = UUID().uuidString
            UserDefaults.standard.set(newUserId, forKey: "userId")
            AnalyticsManager.shared.setUserID(newUserId)
        }
    }
}
