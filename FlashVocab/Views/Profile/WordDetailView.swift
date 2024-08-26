//
//  WordDetailView.swift
//  FlashVocab
//
//  Created by Emir Keleş on 25.08.2024.
//

import SwiftUI

struct WordDetailView: View {
    let word: Word
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                headerCard
                meaningCard
                sentenceCard
                learningStatusCard
                otherInfoCard
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
    }
    
    private var headerCard: some View {
        VStack(spacing: 8) {
            Text(word.english)
                .font(.title).bold()
            Text(word.turkish)
                .font(.title3)
            Text(word.phonetic)
                .font(.subheadline)
                .foregroundColor(.secondary)
            Text("(\(word.partOfSpeech))")
                .font(.caption)
            
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(12)
    }
    
    private var meaningCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Anlam")
                .font(.headline)
            ForEach(word.englishMeanings, id: \.self) { meaning in
                Text("\(meaning)")
                    .font(.body)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(12)
    }
    
    private var sentenceCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Örnek Cümle")
                .font(.headline)
            Text(word.sentence)
                .font(.body)
                .italic()
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(12)
    }
    
    private var learningStatusCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Öğrenme Durumu")
                .font(.headline)
            Group {
                detailRow(title: "Durum", value: word.isKnown == true ? "Biliniyor" : "Bilinmiyor")
                detailRow(title: "Tekrar Sayısı", value: "\(word.reviewCount)")
                if let learnedDate = word.learnedDate {
                    detailRow(title: "Öğrenme Tarihi", value: formatDate(learnedDate))
                }
                if let lastReviewDate = word.lastReviewDate {
                    detailRow(title: "Son Tekrar", value: formatDate(lastReviewDate))
                }
                if let nextReviewDate = word.nextReviewDate {
                    detailRow(title: "Sonraki Tekrar", value: formatDate(nextReviewDate))
                }
            }
            .font(.subheadline)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(12)
    }
    
    private var otherInfoCard: some View {
        Button(action: {
            withAnimation {
                HapticFeedbackManager.shared.playImpact()
                word.bookmarked.toggle()
            }
        }, label: {
            HStack {
                Text("Yer İmi")
                    .font(.headline)
                Spacer()
                Image(systemName: word.bookmarked ? "bookmark.fill" : "bookmark")
                    .foregroundColor(word.bookmarked ? .blue : .gray)
                Text(word.bookmarked ? "Eklendi" : "Eklenmedi")
                    .font(.subheadline)
                    .contentTransition(.numericText())
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(.secondarySystemGroupedBackground))
            .cornerRadius(12)
        })
        .buttonStyle(.plain)
        
    }
    
    private func detailRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
