//
//  ToastManager.swift
//  FlashVocab
//
//  Created by Emir Keleş on 8.08.2024.
//

import SwiftUI

@Observable
class ToastManager {
    private init() {}
    
    var showToast = false
    var toastIcon: String = "bookmark.fill"
    var toastTitle: String = "Yer işaretine eklendi"
    var color: Color = .orange
    
    func showToast(icon: String, title: String) {
            self.toastIcon = icon
            self.toastTitle = title
            self.showToast = true
        }
    
    static let shared = ToastManager()
}
