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
            withAnimation(.snappy) {
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
            .padding(.horizontal, 16)
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
        }
    }
    
    private var imageName: String {
        switch tab {
        case .quiz: return "questionmark.circle"
        case .flashCards: return "rectangle.on.rectangle"
        }
    }
}
