//
//  SettingsView.swift
//  FlashVocab
//
//  Created by Emir Keleş on 24.07.2024.
//

import SwiftUI
import SwiftData

struct SettingsView: View {
    @Query private var items: [Word]
    @Query private var appstates: [AppState]
    @Query private var quizs: [Quiz]
    @Query private var questions: [QuizQuestion]
    @Environment(\.modelContext) private var modelContext
    var body: some View {
        Button("Bütün Verileri Sil", role: .destructive) {
            for item in items {
                modelContext.delete(item)
            }
            
            for appstate in appstates {
                modelContext.delete(appstate)
            }
            
            for question in questions {
                modelContext.delete(question)
            }
            
            for quiz in quizs {
                modelContext.delete(quiz)
            }
        }
        .buttonStyle(.borderedProminent)
    }
}
