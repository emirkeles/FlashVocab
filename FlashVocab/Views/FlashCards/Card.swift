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
        VStack(spacing: 20) {
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
                .readingLocation(onChange: { location in
                    print(location)
                })
                .font(.largeTitle)
                .foregroundStyle(.primary)
                Text(word.phonetic)
                    .font(.title3)
                    .foregroundStyle(.secondary)
                
                Text("(\(word.partOfSpeech))")
                    .font(.subheadline)
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
                    Text("• ")
                        .font(.subheadline)
                        .fontWeight(.bold)
                    +
                    Text("\(meaning)")
                        .font(.subheadline)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text("Example:")
                        .font(.headline)
                    Button(action: {
                        HapticFeedbackManager.shared.playSelection()
                        SpeechSynthesizer.shared.speak(word.sentence, rate: 0.25)
                    }, label: {
                        Image(systemName: "speaker.3.fill")
                            .foregroundStyle(.blue)
                    })
                }
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
            speechButton
            infoButton
        }
        .padding(.bottom, 20)
        .frame(maxWidth: .infinity, alignment: .center)
    }
    
    private var speechButton: some View {
        Button(action: speakWord, label: {
            Image(systemName: "speaker.wave.2.circle")
                .resizable()
                .frame(width: 60, height: 60)
        })
        .padding()
        .tint(.blue)
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
            attributedString[range].font = .callout.bold().italic()
            attributedString[range].underlineStyle = .single
        }
        return attributedString
    }
    
    private func speakWord() {
        HapticFeedbackManager.shared.playImpact(style: .medium)
        SpeechSynthesizer.shared.speak(word.english)
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
            
            if word.bookmarked {
                AnalyticsManager.shared.logWordBookmarked(word: word.english)
            } else {
                AnalyticsManager.shared.logWordUnbookmarked(word: word.english)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                showToast = false
            }
        }
    }
}
