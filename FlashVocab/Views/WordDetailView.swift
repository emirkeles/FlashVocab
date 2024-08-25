//
//  WordDetailView.swift
//  FlashVocab
//
//  Created by Emir Keleş on 25.08.2024.
//

import SwiftUI

struct WordDetailView: View {
    let word: Word
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Temel Bilgiler")) {
                    detailRow(title: "İngilizce", value: word.english)
                    detailRow(title: "Türkçe", value: word.turkish)
                    detailRow(title: "Cümle", value: word.sentence)
                }
                
                Section(header: Text("Öğrenme Durumu")) {
                    detailRow(title: "Durum", value: word.isKnown == true ? "Biliniyor" : "Bilinmiyor")
                    detailRow(title: "Tekrar Sayısı", value: "\(word.reviewCount)")
                    if let learnedDate = word.learnedDate {
                        detailRow(title: "Öğrenme Tarihi", value: formatDate(learnedDate))
                    }
                    if let lastReviewDate = word.lastReviewDate {
                        detailRow(title: "Son Tekrar Tarihi", value: formatDate(lastReviewDate))
                    }
                    if let nextReviewDate = word.nextReviewDate {
                        detailRow(title: "Sonraki Tekrar Tarihi", value: formatDate(nextReviewDate))
                    }
                }
                
                Section(header: Text("Diğer")) {
                    detailRow(title: "Yer İmi", value: word.bookmarked ? "Evet" : "Hayır")
                }
            }
            .navigationTitle("Kelime Detayları")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func detailRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
            Spacer()
            Text(value)
                .foregroundColor(.secondary)
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

