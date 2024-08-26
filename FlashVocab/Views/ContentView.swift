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
