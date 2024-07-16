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
        OnboardingSlideModel(image: "onb_1_review", title: "Roku TVs remote\ncontrol", description: "Control your TV\nwithout a remote"),
        OnboardingSlideModel(image: "onb_2_review", title: "Touch pad for easy and\nintuitive navigation", description: "Easy content viewing\nand TV control"),
        OnboardingSlideModel(image: "onb_3_review", title: "The most popular\nstreaming channels", description: "Quick access and\ncontrol")
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
