//
//  ToastModifier.swift
//  FlashVocab
//
//  Created by Emir Keleş on 8.08.2024.
//

import SwiftUI

struct ToastViewModifier: ViewModifier {
    @Binding var isPresented: Bool
    @Binding var icon: String
    @Binding var title: String
    var color: Color
    
    func body(content: Content) -> some View {
        content
            .popup(isPresented: $isPresented, view: {
                ZStack {
                    HStack {
                        Image(systemName: icon)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 36, height: 36)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text(title)
                        .font(.headline)
                }
                .foregroundColor(.white)
                .padding(EdgeInsets(top: 60, leading: 16, bottom: 16, trailing: 16))
                .frame(maxWidth: .infinity)
                .background(color.gradient)
            }, customize: {
                $0
                    .type(.toast)
                    .position(.top)
                    .animation(.spring)
                    .autohideIn(1)
            })
    }
}
