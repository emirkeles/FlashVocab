//
//  HapticManager.swift
//  FlashVocab
//
//  Created by Emir Keleş on 12.08.2024.
//

import UIKit

class HapticFeedbackManager {
    static let shared = HapticFeedbackManager()
    
    private init() {}
    
    func playImpact(style: UIImpactFeedbackGenerator.FeedbackStyle = .light) {
        let impact = UIImpactFeedbackGenerator(style: style)
        impact.impactOccurred()
    }
    
    func playSelection() {
        let selection = UISelectionFeedbackGenerator()
        selection.selectionChanged()
    }
    
    func playNotification(type: UINotificationFeedbackGenerator.FeedbackType) {
        let notification = UINotificationFeedbackGenerator()
        notification.notificationOccurred(type)
    }
}
