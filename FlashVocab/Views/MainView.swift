//
//  MainView.swift
//  FlashVocab
//
//  Created by Emir Keleş on 10.08.2024.
//

import SwiftUI
import SwiftData

struct MainView: View {
    @State private var selectedTab: Tab = .quiz
    @Namespace private var animation
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            headerView
            topTabView
            tabView
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .padding()
    }
}

extension MainView {
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Merhaba,")
                    .font(.title2)
                    .fontWeight(.bold)
                Text("Bugün ne öğrenmek istersin?")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            Spacer()
            HStack(spacing: 4) {
                Text("\(Text("x").font(.title2))3")
                    .foregroundStyle(.orange)
                    .font(.largeTitle)
                    .fontDesign(.monospaced)
                Image(systemName: "flame.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40)
                    .foregroundStyle(.orange)
            }
        }
    }
    
    private var topTabView: some View {
        HStack {
            ForEach(Tab.allCases, id: \.self) { tab in
                TabButton(tab: tab, selectedTab: $selectedTab, animation: animation)
            }
        }
        .padding(8)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(20)
        .frame(maxWidth: .infinity, alignment: .center)
        
    }
    
    @ViewBuilder
    private var tabView: some View {
        if selectedTab == .quiz {
            VStack(spacing: 15) {
                NavigationLink(destination: QuizView()) {
                    MenuCard(
                        title: "Yeni Quiz",
                        description: "Hadi bir quiz çözelim!",
                        icon: "play.circle.fill",
                        color: .blue
                    )
                }
                
                
                
                NavigationLink(destination: QuizListView()) {
                    MenuCard(
                        title: "Geçmiş Quiz'ler",
                        description: "Önceki performansını gör",
                        icon: "clock.fill",
                        color: .green
                    )
                }
            }
        } else {
            NavigationLink(destination: FlashCardsView()) {
                MenuCard(
                    title: "FlashCards",
                    description: "Yeni kelimelerle çalış",
                    icon: "rectangle.stack.fill",
                    color: .yellow
                )
            }
            NavigationLink {
                BookmarkedFlashCardsView()
            } label: {
                MenuCard(
                    title: "Yer İşaretli Kelimeler",
                    description: "Yer işaretleri ile çalış",
                    icon: "bookmark.fill",
                    color: .orange
                )
            }
        }
    }
    
    
    enum Tab: String, CaseIterable {
        case quiz = "Quiz"
        case flashCards = "FlashCards"
    }
}
