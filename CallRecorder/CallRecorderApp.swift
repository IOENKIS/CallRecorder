//
//  CallRecorderApp.swift
//  CallRecorder
//
//  Created by IVANKIS on 15.07.2024.
//
import SwiftUI

@main
struct CallRecorderApp: App {
    @State private var dismissSplash = false
    @Environment(\.scenePhase) var scenePhase
    @State private var purchased: String?

    var body: some Scene {
        WindowGroup {
            ZStack {
                SplashView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            dismissSplash.toggle()
                        }
                    }
                
                if dismissSplash {
                    if UserDefaults.standard.bool(forKey: "onboardingDone") == true {
                        MainView()
                    } else {
                        OnboardingView()
                    }
                }
            }
        }
    }
}
