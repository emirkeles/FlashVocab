//
//  SettingsView.swift
//  FlashVocab
//
//  Created by Emir Keleş on 24.07.2024.
//

import SwiftUI
import SwiftData

struct SettingsView: View {
    @Query
    private var items: [Word]
    @Environment(\.modelContext) private var modelContext
    var body: some View {
        Text("ayarlar")
        
            .onAppear {
                for item in items {
                    print("siliyom")
                    modelContext.delete(item)
                }
            }
    }
}
