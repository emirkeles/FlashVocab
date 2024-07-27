//
//  FlashVocabApp.swift
//  FlashVocab
//
//  Created by Emir Keleş on 17.07.2024.
//

import SwiftUI
import PopupView

@Observable
class ToastManager {
    private init() {}
    
    var showToast = false
    
    static let shared = ToastManager()
}

@main
struct FlashVocabApp: App {
    @State private var showToast = false
    @State private var toastManager = ToastManager.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modifier(ToastViewModifier(isPresented: $toastManager.showToast))
            //                .popup(isPresented: $toastManager.showToast, view: {
            //                    HStack {
            //                        Image(systemName: "square.and.arrow.up")
            //                                    .frame(width: 48, height: 48)
            //                                    .cornerRadius(24)
            //                                
            //                                VStack(alignment: .leading) {
            //                                    HStack {
            //                                        Text("Camila Morrone")
            //                                            .font(.system(size: 15))
            //                                        
            //                                        Spacer()
            //                                        
            //                                        Text("now")
            //                                            .font(.system(size: 13))
            //                                            .opacity(0.6)
            //                                    }
            //                                    
            //                                    Text("Let's go have a cup of coffee! ☕️")
            //                                        .font(.system(size: 15, weight: .light))
            //                                }
            //                            }
            //                            .foregroundColor(.white)
            //                            .padding(EdgeInsets(top: 56, leading: 16, bottom: 16, trailing: 16))
            //                            .frame(maxWidth: .infinity)
            //                            .background(.thinMaterial)
            //                }, customize: {
            //                    $0
            //                        .type(.toast)
            //                        .position(.top)
            //                        .animation(.spring)
            //                        .autohideIn(2)
            //                })
            //                
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        showToast.toggle()
                    }
                    
                }
                .flashCardDataContainer()
        }
    }
}



struct ToastViewModifier: ViewModifier {
    @Binding var isPresented: Bool
    
    func body(content: Content) -> some View {
        content
            .popup(isPresented: $isPresented, view: {
                ZStack {
                    HStack {
                        Image(systemName: "star.fill")
                            .resizable()
                            .frame(width: 36, height: 36)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text("Favorilere Eklendi")
                        .font(.system(size: 18))
                }
                .foregroundColor(.white)
                .padding(EdgeInsets(top: 56, leading: 16, bottom: 16, trailing: 16))
                .frame(maxWidth: .infinity)
                .background(Color.orange.gradient)
            }, customize: {
                $0
                    .type(.toast)
                    .position(.top)
                    .animation(.spring)
                    .autohideIn(2)
            })
    }
}
