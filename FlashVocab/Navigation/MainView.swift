//
//  MainView.swift
//  FlashVocab
//
//  Created by Emir Keleş on 10.08.2024.
//

import SwiftUI
import SwiftData

struct MainView: View {
    @Query
    private var words: [Word]
    var body: some View {
        HStack {
            NavigationLink {
                QuizView()
                    .transition(.scale)
            } label: {
                RoundedRectangle(cornerRadius: 25.0)
                    .fill(.ultraThinMaterial)
                    .frame(width: 180, height: 200)
                    .overlay {
                        Text("Quiz")
                    }
            }
            
            NavigationLink {
                FlashCardsView()
            } label: {
                RoundedRectangle(cornerRadius: 25.0)
                    .fill(.ultraThinMaterial)
                    .frame(width: 180, height: 200)
                    .overlay {
                        Text("FlashCards")
                    }
            }
            
        }
    }
}
#Preview {
    MainView()
}
