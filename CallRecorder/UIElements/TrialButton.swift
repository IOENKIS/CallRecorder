//
//  TrialButton.swift
//  PrinterApp
//
//  Created by IVANKIS on 25.06.2024.
//

import SwiftUI

struct TrialButton: View {
    @Binding var isTrialOn: Bool
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 40)
                .frame(width: UIScreen.main.bounds.width - 15, height: 60)
                .foregroundColor(Color.white.opacity(0.1))
            
            HStack {
                Text("Free Trial Enabled")
                    .foregroundColor(.white)
                    .font(.system(size: 16, weight: .bold))
                    .padding(.leading, 40)
                Spacer()
            }
            
            HStack {
                Spacer()
                Toggle(isOn: $isTrialOn) {
                    // Empty label closure
                }
                .padding(.trailing, 40)
                .tint(Color.red)
            }
        }
    }
}
