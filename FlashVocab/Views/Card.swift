//
//  Card.swift
//  FlashVocab
//
//  Created by Emir Keleş on 20.07.2024.
//

import SwiftUI

struct Card: View {
    @State private var show: Bool = false
    @State private var offsetSize: CGSize = .zero
    @State private var showToast: Bool = false
    var word: Word
    
    var body: some View {
        ZStack {
            cardBackground
                .overlay(
                    cardContent
                        .padding()
                )
                .overlay(alignment: .bottom) {
                    actionButtons
                }
        }
        .offset(x: offsetSize.width, y: offsetSize.height)
    }
    
    private var cardBackground: some View {
        RoundedRectangle(cornerRadius: 25.0, style: .continuous)
            .fill(.thickMaterial)
            .frame(maxHeight: 550)
            .padding()
    }
    
    private var cardContent: some View {
        VStack(spacing: 40) {
            wordHeader
            if show {
                wordDetails
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: show ? .top : .center)
    }
    
    private var wordHeader: some View {
        VStack {
            Text(word.english.capitalized)
                .font(.largeTitle)
                .foregroundStyle(.primary)
            Text(word.phonetic.capitalized)
                .font(.title3)
                .foregroundStyle(.secondary)
            
        }
        .padding(.top, show ? 40 : 0)
        .offset(y: show ? 0 : -80)
    }
    
    private var wordDetails: some View {
        VStack(spacing: 20) {
            Text(word.turkish.capitalized)
                .font(.title2)
                .padding(.top, -5)
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Meaning:")
                    .font(.headline)
                ForEach(word.englishMeanings, id: \.self) { meaning in
                    Text("(\(word.partOfSpeech)) ")
                        .font(.subheadline)
                    +
                    Text("\(meaning)")
                        .font(.subheadline)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            VStack(alignment: .leading, spacing: 10) {
                Text("Example:")
                    .font(.headline)
                Text("\(attributedSentence)")
                    .font(.subheadline)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .transition(.asymmetric(insertion: .push(from: .bottom), removal: .push(from: .top)))
    }
    
    private var actionButtons: some View {
        HStack(spacing: 20) {
            bookmarkButton
            infoButton
        }
        .padding(.bottom, 20)
        .frame(maxWidth: .infinity, alignment: .center)
    }
    
    private var bookmarkButton: some View {
        Button(action: toggleBookmark) {
            Image(systemName: word.bookmarked ? "bookmark.circle.fill" : "bookmark.circle")
                .resizable()
                .frame(width: 60, height: 60)
        }
        .padding()
        .tint(.orange)
    }
    
    private var infoButton: some View {
        Button(action: toggleInfo) {
            Image(systemName: show ? "info.circle.fill" : "info.circle")
                .resizable()
                .frame(width: 60, height: 60)
        }
        .padding()
        .tint(.gray.opacity(0.8))
    }
    
    private var attributedSentence: AttributedString {
        var attributedString = AttributedString(word.sentence)
        if let range = attributedString.range(of: word.english, options: .caseInsensitive) {
            attributedString[range].font = .callout.bold()
            attributedString[range].underlineStyle = .single
        }
        return attributedString
    }
    
    private func toggleInfo() {
        HapticFeedbackManager.shared.playImpact(style: .medium)
        withAnimation(.snappy(duration: 0.4)) {
            show.toggle()
        }
    }
    
    private func toggleBookmark() {
        HapticFeedbackManager.shared.playImpact(style: .medium)
        if !showToast {
            word.bookmarked.toggle()
            let (icon, title) = word.bookmarked
            ? ("bookmark.fill", "Yer İşaretlerine Eklendi")
            : ("bookmark.slash.fill", "Yer İşaretlerinden Çıkartıldı")
            ToastManager.shared.showToast(icon: icon, title: title)
            showToast = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                showToast = false
            }
        }
    }
}
