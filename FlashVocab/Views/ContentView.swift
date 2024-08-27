//
//  ContentView.swift
//  FlashVocab
//
//  Created by Emir Keleş on 17.07.2024.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        TabView {
            NavigationStack {
                MainView()
                    .onAppear {
                    AnalyticsManager.shared.setUserProperty(value: Locale.current.language.languageCode?.identifier ?? "Türkçe", forName: "language")
                    AnalyticsManager.shared.setUserProperty(value: UIDevice.current.systemVersion, forName: "ios_version")
                }
            }
            .tabItem { Label("Menu", systemImage: "list.dash") }
            
            NavigationStack {
                ProfileView()
            }
            .tabItem { Label("Profil", systemImage: "person.circle") }
            
//            NavigationStack {
//                SettingsView()
//            }
//            .tabItem { Label("Settings", systemImage: "gear") }
        }
    }
}
