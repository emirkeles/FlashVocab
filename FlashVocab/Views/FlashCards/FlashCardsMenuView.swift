//
//  FlashCardsMenuView.swift
//  FlashVocab
//
//  Created by Emir Keleş on 25.08.2024.
//

import SwiftUI

struct FlashCardsMenuView: View {
    var body: some View {
        VStack(spacing: 20) {
            NavigationLink(destination: FlashCardsView()) {
                MenuCard(title: "Flashcards", description: "Kelime kartlarıyla çalış", icon: "rectangle.stack.fill", color: .orange)
            }
            NavigationLink(destination: Text("Favori Kelimeler")) {
                MenuCard(title: "Favori Kelimeler", description: "Kaydettiğin kelimeleri gözden geçir", icon: "star.fill", color: .yellow)
            }
        }
    }
}

#Preview {
    FlashCardsMenuView()
}
