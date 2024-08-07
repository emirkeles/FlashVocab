//
//  FlashVocabApp.swift
//  FlashVocab
//
//  Created by Emir Keleş on 17.07.2024.
//

import SwiftUI
import PopupView

@Observable
class ToastManager {
    private init() {}
    
    var showToast = false
    var toastIcon: String = "star.fill"
    var toastTitle: String = "Yer işaretine eklendi"
    var color: Color = .orange
    
    func showToast(icon: String, title: String) {
            self.toastIcon = icon
            self.toastTitle = title
            self.showToast = true
        }
    
    static let shared = ToastManager()
}

@main
struct FlashVocabApp: App {
    @State private var showToast = false
    @State private var toastManager = ToastManager.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modifier(ToastViewModifier(isPresented: $toastManager.showToast, icon: $toastManager.toastIcon, title: $toastManager.toastTitle, color: toastManager.color))
                .flashCardDataContainer()
        }
    }
}

struct ToastViewModifier: ViewModifier {
    @Binding var isPresented: Bool
    @Binding var icon: String
    @Binding var title: String
    var color: Color
    
    func body(content: Content) -> some View {
        content
            .popup(isPresented: $isPresented, view: {
                ZStack {
                    HStack {
                        Image(systemName: icon)
                            .resizable()
                            .frame(width: 36, height: 36)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text(title)
                        .font(.system(size: 18))
                }
                .foregroundColor(.white)
                .padding(EdgeInsets(top: 56, leading: 16, bottom: 16, trailing: 16))
                .frame(maxWidth: .infinity)
                .background(color.gradient)
            }, customize: {
                $0
                    .type(.toast)
                    .position(.top)
                    .animation(.spring)
                    .autohideIn(0.8)
            })
    }
}

#Preview{
    ContentView()
}
