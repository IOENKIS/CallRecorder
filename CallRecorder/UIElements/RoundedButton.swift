//
//  RoundedButton.swift
//  PrinterApp
//
//  Created by IVANKIS on 25.06.2024.
//

import SwiftUI

struct RoundedButton: View {
    let perform: () -> Void
    let text: String
    let showImage: Bool
    @State private var isAnimating = false
    let animate: Bool
    
    var body: some View {
        Button(action: {
            HapticTouchManager().produceHaptic()
            perform()
        }) {
            ZStack {
                RoundedRectangle(cornerRadius: 40)
                    .fill(Color.clear)
                    .frame(width: UIScreen.main.bounds.width - 15, height: 60)
                    .background(
                        Image("backgroundButton")
                            .resizable()
                            .scaledToFill()
                    )
                
                Text(text)
                    .foregroundColor(.white)
                    .font(.system(size: 16, weight: .bold))
                
                if showImage {
                    HStack {
                        Spacer()
                        Image("buttonImage")
                            .resizable()
                            .frame(width: 20, height: 17)
                            .padding(.trailing, 55)
                            .foregroundStyle(.white)
                    }
                }
            }
            .padding(.bottom, 40)
        }
        .scaleEffect(isAnimating ? 0.88 : 1)
        .onAppear {
            if animate {
                withAnimation(Animation.easeInOut(duration: 0.49).repeatForever()) {
                    isAnimating.toggle()
                }
            }
        }
    }
}
