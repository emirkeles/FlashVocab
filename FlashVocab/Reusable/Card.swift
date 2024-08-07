//
//  Card.swift
//  FlashVocab
//
//  Created by Emir Keleş on 20.07.2024.
//

import SwiftUI

struct Card: View {
    @Namespace private var Namespace
    @State private var show: Bool = false
    @State private var isToggle = false
    @State private var offsetSize: CGSize = .zero
    @State private var showToast: Bool = false
    @State private var favorite = false
    @State private var size: CGSize = .zero
    var word: Word
    
    private func haptic() {
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()
    }
    
    private func toggleFavorite() {
        haptic()
        withAnimation(.snappy(duration: 0.4)) {
            show.toggle()
        }
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25.0, style: .continuous)
                .fill(.thickMaterial)
                .frame(maxHeight: 540)
                .padding()
                .overlay(
                    overlayView
                )
                .overlay(alignment: .bottom) {
                    HStack(spacing: 20) {
                        Button(action: toggleToast) {
                            Image(systemName: favorite ? "bookmark.circle.fill" : "bookmark.circle")
                                .resizable()
                                .frame(width: 60, height: 60)
                        }
                        .padding()
                        .tint(.orange)
                        Button(action: toggleFavorite) {
                            Image(systemName: show ? "info.circle.fill" : "info.circle")
                                .resizable()
                                .frame(width: 60, height: 60)
                        }
                        .padding()
                        .tint(.gray.opacity(0.8))
                                        }
                    .padding(.bottom, 20)
                    .frame(maxWidth: .infinity, alignment: .center)
                }
                .offset(x: offsetSize.width, y: offsetSize.height)
        }
    }
    
    private func toggleToast() {
        haptic()
        if !showToast {
            if favorite {
                ToastManager.shared.showToast(icon: "bookmark.slash.fill", title: "Yer İşaretlerinden Çıkartıldı")
                favorite.toggle()
                showToast.toggle()
            } else {
                ToastManager.shared.showToast(icon: "bookmark.fill", title: "Yer İşaretlerine Eklendi")
                favorite.toggle()
                showToast.toggle()
            }
            DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                showToast.toggle()
            }
        }
    }
    
    @ViewBuilder
    private var overlayView: some View {
        VStack(spacing: 40) {
                    Text(word.english)
                        .matchedGeometryEffect(id: "word.english", in: Namespace)
                        .foregroundStyle(.primary)
                        .font(.largeTitle)
                        .padding(.top, show ? 40 : 0)
                        .offset(y: show ? 0 : -80)
            
            
                    if show {
                        VStack(spacing: 20) {
                            Text(word.sentence)
                                .font(.callout)
                                .padding(.horizontal)
                                
                            Text("a written or printed work consisting of pages glued or sewn together along one side and bound in covers.")
                                .font(.headline)
                                .padding(.top, 5)
                                .padding(.horizontal, 20)
                            Text(word.turkish)
                                .font(.body)
                                .padding(.top, 5)
                        }
                        .frame(maxHeight: .infinity, alignment: .top)
                        .transition(.asymmetric(insertion: .push(from: .bottom), removal: .push(from: .top)))
                    }
                }
        
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: show ? .top : .center)
            }
    
    private var firstView: some View {
            VStack(spacing: 10) {
                Text(word.english)
                    .matchedGeometryEffect(id: "word.english", in: Namespace)
                    .foregroundStyle(.primary)
                    .font(.largeTitle)
            }
            .padding(.top, 20)
    }
    private var secondView: some View {
            VStack(spacing: 10) {
                Text(word.english)
                    .matchedGeometryEffect(id: "word.english", in: Namespace)
                    .foregroundStyle(.primary)
                    .font(.largeTitle)
                VStack {
                    Text(word.sentence)
                        .font(.callout)
                        .padding(.horizontal)
                        .animation(.easeOut(duration: 0.5), value: show)
                    Text("a written or printed work consisting of pages glued or sewn together along one side and bound in covers.")
                        .font(.headline)
                        .padding(.top, 5)
                        .padding(.horizontal, 20)
                    Text(word.turkish)
                        .font(.body)
                        .padding(.top, 5)
                }
                .transition(.slide)
            }
            
            .offset(y: show ? 0 : 400)
        .padding(.top, 40)
    }
}
