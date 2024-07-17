//
//  HapticTouchManager.swift
//  PrinterApp
//
//  Created by IVANKIS on 25.06.2024.
//

import SwiftUI

struct HapticTouchManager {
    func produceHaptic() {
        let impactMed = UIImpactFeedbackGenerator(style: .medium)
        impactMed.impactOccurred()
    }
}
