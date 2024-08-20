//
//  ContentView.swift
//  FlashVocab
//
//  Created by Emir Keleş on 17.07.2024.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query
    private var items: [Word]
    
    var body: some View {
        
        TabView {
            NavigationStack {
                MainView()
            }
            .tabItem { Label("Menu", systemImage: "list.dash") }
            
            NavigationStack {
                ProfileView()
            }
            .tabItem { Label("Profil", systemImage: "person.circle") }
            
            NavigationStack {
                QuizListView()
            }
            .tabItem { Label("Geçmiş Quiz'ler", systemImage: "list.bullet") }
            
            NavigationStack {
                SettingsView()
            }
            .tabItem { Label("Settings", systemImage: "gear") }
        }
    }
}
