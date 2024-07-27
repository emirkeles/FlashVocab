//
//  Card.swift
//  FlashVocab
//
//  Created by Emir Keleş on 20.07.2024.
//

import SwiftUI
import PopupView


struct Card: View {
    @Namespace private var Namespace
    @State private var show: Bool = false
    @State private var isToggle = false
    @State private var offsetSize: CGSize = .zero
    @State private var showToast: Bool = false
    
    var word: Word
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25.0, style: .continuous)
                .fill(.thickMaterial)
                .frame(maxHeight: 500)
                .padding()
                .overlay(
                    overlayView
                )
                .offset(x: offsetSize.width, y: offsetSize.height)
        }
        .gesture(
            DragGesture()
                .onChanged{ offset in
                    if offset.translation.height < -150 {
                        if !show {
                            withAnimation(.snappy(duration: 0.4)) {
                                show.toggle()
                            }
                        }
                    }
                    if offset.translation.height > 150 {
                        if !showToast {
                            ToastManager.shared.showToast.toggle()
                            showToast.toggle()
                            DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
                                showToast.toggle()
                            }
                        }
                    }
                }
                .onEnded { offset in
                    withAnimation {
                        offsetSize = .zero
                    }
                    
                }
        )
    }
    
    @ViewBuilder
    private var overlayView: some View {
        VStack(spacing: 40) {
                    Text(word.english)
                        .matchedGeometryEffect(id: "word.english", in: Namespace)
                        .foregroundStyle(.primary)
                        .font(.largeTitle)
                        .padding(.top, show ? 40 : 0)
            
                    
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
