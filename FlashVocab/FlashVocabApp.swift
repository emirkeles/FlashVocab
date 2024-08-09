//
//  FlashVocabApp.swift
//  FlashVocab
//
//  Created by Emir Keleş on 17.07.2024.
//

import SwiftUI
import PopupView


@main
struct FlashVocabApp: App {
    @State private var showToast = false
    @State private var toastManager = ToastManager.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
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
}

#Preview{
    ContentView()
}
