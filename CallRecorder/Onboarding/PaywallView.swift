//
//  PaywallView.swift
//  PrinterApp
//
//  Created by IVANKIS on 25.06.2024.
//

import SwiftUI

import SwiftUI

struct PaywallView: View {
    var initialOpen: Bool
    @State private var isTrialOn: Bool = true
    @State private var mainView = false
    @State private var optimizeButton = false
    @Environment(\.openURL) private var openURL
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
//            Image(UserDefaults.standard.bool(forKey: "darkMode") == true ? "paywallImage" : "background")
            Image("paywallImage")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            if !UserDefaults.standard.bool(forKey: "testPaywall") || optimizeButton {
                VStack {
                    HStack {
                        Button(action: {
                            if initialOpen {
                                UserDefaults.standard.set(true, forKey: "onboardingDone")
                                mainView.toggle()
                            } else {
                                dismiss()
                            }
                        }) {
                            Image(systemName: "multiply")
                                .resizable()
                                .frame(width: 16, height: 16)
                                .foregroundColor(.white)
                                .opacity(UserDefaults.standard.bool(forKey: "darkMode") ? 0.7 : 1)
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 55)
                    .padding(.top, UIScreen.main.bounds.height > 850 ? 55 : 80)
                    Spacer()
                }
            }
            
            VStack(spacing: 1) {
                Spacer()
                Spacer()
                
                Text((isTrialOn ? "Start to continue App\nwith a 3-day trial and $6.99 per week"
                     : "Start to continue App\njust for $6.99 per week"))
                    .foregroundColor(.white)
                    .font(.system(size: 18, weight: .bold))
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .minimumScaleFactor(0.2)
                    .padding(.horizontal, 10)
                    .padding(.top, 20)
                    .opacity(UserDefaults.standard.bool(forKey: "darkMode") ? 0.7 : 1)
                
//                if UserDefaults.standard.bool(forKey: "testPaywall") {
                    TrialButton(isTrialOn: $isTrialOn)
                        .padding(.top, 20)
//                }
                
                RoundedButton(perform: {
                    Task {
                        if initialOpen {
                            UserDefaults.standard.set(true, forKey: "onboardingDone")
                        }
                        mainView = true
                    }
                }, text: isTrialOn ? "3-days Free Trial then $6.99/week" : "Subscribe for $6.99/week", showImage: false, animate: true)
                .padding(.top, UserDefaults.standard.bool(forKey: "testPaywall") ? /*30*/10 : 10)
                
                HStack(spacing: 49) {
                    Button(action: {
                        openURL(URL(string: "https://google.com")!)
                    }) {
                        Text("Terms")
                            .foregroundColor(.gray)
                            .font(.system(size: 11))
                    }
                    Button(action: {
                        openURL(URL(string: "https://google.com")!)
                    }) {
                        Text("Privacy")
                            .foregroundColor(.gray)
                            .font(.system(size: 11))
                    }
                    Button(action: {
                        // Restore action
                    }) {
                        Text("Restore")
                            .foregroundColor(.gray)
                            .font(.system(size: 11))
                    }
                }
                .padding(.top, 10)
            }
            .padding(.bottom, UIScreen.main.bounds.height > 850 ? 50 : 120)
        }
        .fullScreenCover(isPresented: $mainView) {
            MainView()
        }
        .onAppear {
            if UserDefaults.standard.bool(forKey: "testPaywall") {
                Timer.scheduledTimer(withTimeInterval: 4.99, repeats: false) { _ in
                    optimizeButton = true
                }
            }
        }
    }
}
