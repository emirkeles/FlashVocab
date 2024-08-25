//
//  SpeechSynthesizer.swift
//  FlashVocab
//
//  Created by Emir Keleş on 25.08.2024.
//

import Foundation
import AVFoundation

class SpeechSynthesizer {
    private let synthesizer = AVSpeechSynthesizer()
    
    static let shared = SpeechSynthesizer()
    
    private init() { }
    
    func speak(_ text: String, language: String = "en-US") {
        let utterance = AVSpeechUtterance(string: text)
        if let voice = AVSpeechSynthesisVoice(language: language) {
            utterance.voice = voice
            utterance.rate = 0.3
            synthesizer.speak(utterance)
        }
    }
}
