//
//  ContentView.swift
//  FlashVocab
//
//  Created by Emir Keleş on 17.07.2024.
//

import SwiftUI
import SwiftData
import SwiftfulUI



struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query
    private var items: [Word]
    
    var body: some View {
        
        TabView {
            NavigationStack {
                FlashCardsView()
            }
            .tabItem {
                Label("Menu", systemImage: "list.dash")
            }
            NavigationStack {
                ProfileView()
            }
            .tabItem { Label("Profil", systemImage: "person.circle") }
            NavigationStack {
                SettingsView()
            }
            .tabItem { Label("Settings", systemImage: "gear") }
        }
    }
}





