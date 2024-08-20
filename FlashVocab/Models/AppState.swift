//
//  AppState.swift
//  FlashVocab
//
//  Created by Emir Keleş on 10.08.2024.
//

import Foundation
import SwiftData

@Model
class AppState {
    var lastCardIndex: Int
    
    init(lastCardIndex: Int = 0) {
        self.lastCardIndex = lastCardIndex
    }
}
