//
//  TabButton.swift
//  FlashVocab
//
//  Created by Emir Keleş on 25.08.2024.
//

import SwiftUI

struct TabButton: View {
    let tab: MainView.Tab
    @Binding var selectedTab: MainView.Tab
    var animation: Namespace.ID
    
    var body: some View {
        Button(action: {
            HapticFeedbackManager.shared.playSelection()
            withAnimation(.smooth) {
                selectedTab = tab
            }
        }) {
            VStack(spacing: 4) {
                Image(systemName: imageName)
                    .font(.system(size: 20))
                Text(tab.rawValue)
                    .font(.caption)
            }
            .foregroundColor(selectedTab == tab ? .blue : .gray)
            .padding(.vertical, 8)
            .frame(width: 100)
            .background(
                ZStack {
                    if selectedTab == tab {
                        Color(.systemBackground)
                            .cornerRadius(12)
                            .matchedGeometryEffect(id: "TAB", in: animation)
                    }
                }
            )
            .cornerRadius(12)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: selectedTab)
        }
    }
    
    private var imageName: String {
        switch tab {
        case .quiz: return "questionmark.circle"
        case .flashCards: return "rectangle.on.rectangle"
        }
    }
}
