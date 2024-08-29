//
//  SpeechSynthesizer.swift
//  FlashVocab
//
//  Created by Emir Keleş on 25.08.2024.
//

import Foundation
import AVFoundation

class SpeechSynthesizer: NSObject, AVSpeechSynthesizerDelegate {
    private let synthesizer = AVSpeechSynthesizer()
    
    static let shared = SpeechSynthesizer()
    
    private var completionCallBack: (() -> Void)?
    
    private override init() {
        super.init()
        synthesizer.delegate = self
    }
    
    func speak(_ text: String, language: String = "en-US", rate: Float = 0.1, callback: (() -> Void)? = nil) {
        let utterance = AVSpeechUtterance(string: text)
        if let voice = AVSpeechSynthesisVoice(language: language) {
            utterance.voice = voice
            utterance.rate = rate
            completionCallBack = callback
            synthesizer.speak(utterance)
        }
    }
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        completionCallBack?()
        completionCallBack = nil
    }
}
