//
//  OnboardingView.swift
//  PrinterApp
//
//  Created by IVANKIS on 25.06.2024.
//

import SwiftUI
import StoreKit

struct OnboardingView: View {
    var slides = [
        OnboardingSlideModel(image: "onb_1_review", title: "Hello,\nCall Recorder!", description: "Record all your calls and make voice\nnotes without any time limit"),
        OnboardingSlideModel(image: "onb_2_review", title: "Track all calls made\nand received", description: "You'll be able to follow every\nword of your conversation"),
        OnboardingSlideModel(image: "onb_3_review", title: "All important dialog\nand notes in one place", description: "It's easy to manage, listen to,\nand share them")
    ]
    
    @State private var currentPage = 0
    
    var body: some View {
        ZStack {
                TabView(selection: $currentPage) {
                    ForEach(0..<slides.count+1) { index in
                        if index < 3 {
                            OnboardingSlide(slide: slides[index], action: {
                                withAnimation {
                                    if currentPage < slides.count {
                                        currentPage += 1
                                        if UserDefaults.standard.bool(forKey: "fifthSlide") && currentPage == 2 {
                                            requestReview()
                                        }
                                    }
                                }
                            }, currentPage: currentPage)
                            .tag(index)
                        } else {
                            PaywallView(initialOpen: true)
                                .tag(slides.count)
                        }
                    }
                }
                .ignoresSafeArea()
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        }
    }
    
    func requestReview() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
}
