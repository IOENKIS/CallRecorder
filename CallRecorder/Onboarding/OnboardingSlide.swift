//
//  OnboardingSlide.swift
//  PrinterApp
//
//  Created by IVANKIS on 25.06.2024.
//

import SwiftUI

struct OnboardingSlide: View {
    let slide: OnboardingSlideModel
    let action: () -> ()
    var currentPage: Int
    
    var body: some View {
        ZStack {
            Image(slide.image)
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                Spacer()
                
                Text(slide.title)
                    .foregroundColor(.white)
                    .font(.system(size: 34, weight: .bold))
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .minimumScaleFactor(0.2)
                    .padding(.horizontal, 40)
                    .padding(.bottom, 20)
                
                Text(slide.description)
                    .foregroundColor(.white)
                    .font(.system(size: 18, weight: .bold))
                    .multilineTextAlignment(.center)
                    .lineLimit(slide.description.count > 67 ? 3 : 2)
                    .minimumScaleFactor(0.2)
                    .padding(.horizontal, 40)
                    .padding(.bottom, 20)
                    .opacity(UserDefaults.standard.bool(forKey: "darkMode") ? 0.7 : 1)

                RoundedButton(perform: action, text: "Continue", showImage: true, animate: true)
                    .padding(.bottom, 40)
            }
            .padding(.bottom, UIScreen.main.bounds.height > 850 ? 40 : 100)
        }
    }
}

struct OnboardingSlideModel: Identifiable {
    let id = UUID()
    let image: String
    let title: String
    let description: String
}
