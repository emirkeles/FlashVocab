//
//  MainView.swift
//  FlashVocab
//
//  Created by Emir Keleş on 10.08.2024.
//

import SwiftUI
import SwiftData
import TipKit

struct MainView: View {
    @State private var selectedTab: Tab = .flashCards
    @Namespace private var animation
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            headerView
            topTabView
            tabView
            
        }
        .analyticsScreen(name: "MainView")
        .onAppear {
            StreakManager.shared.updateStreak()
            try? Tips.configure([
                .displayFrequency(.immediate),
                .datastoreLocation(.applicationDefault)
            ])
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
            StreakView()
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
                .simultaneousGesture(TapGesture().onEnded {
                    AnalyticsManager.shared.logMenuItemSelected(item: "New Quiz")
                })
                
                NavigationLink(destination: QuizListView()) {
                    MenuCard(
                        title: "Geçmiş Quiz'ler",
                        description: "Önceki performansını gör",
                        icon: "clock.fill",
                        color: .green
                    )
                }
                .simultaneousGesture(TapGesture().onEnded {
                    AnalyticsManager.shared.logMenuItemSelected(item: "Quiz History")
                })
            }
        } else {
            VStack(spacing: 15) {
                NavigationLink(destination: FlashCardsView()) {
                    MenuCard(
                        title: "Flaş Kartlar",
                        description: "Yeni kelimelerle çalış",
                        icon: "rectangle.stack.fill",
                        color: .yellow
                    )
                }
                .simultaneousGesture(TapGesture().onEnded {
                    AnalyticsManager.shared.logMenuItemSelected(item: "Flash Cards")
                })
                NavigationLink {
                    BookmarkedFlashCardsView()
                } label: {
                    MenuCard(
                        title: "Yer İşaretli Kartlar",
                        description: "Yer işaretleri ile çalış",
                        icon: "bookmark.fill",
                        color: .orange
                    )
                }
                .simultaneousGesture(TapGesture().onEnded {
                    AnalyticsManager.shared.logMenuItemSelected(item: "Bookmarked Cards")
                })
            }
        }
    }
    
    enum Tab: String, CaseIterable {
        case quiz = "Quiz"
        case flashCards = "FlashCards"
    }
}
