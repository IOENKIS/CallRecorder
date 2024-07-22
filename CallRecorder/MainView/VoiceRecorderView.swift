//
//  VoiceRecorderView.swift
//  CallRecorder
//
//  Created by IVANKIS on 16.07.2024.
//

import SwiftUI
import AVFoundation

struct VoiceRecorderView: View {
    @StateObject private var callRecorderVM = CallRecorderVM()
    @State private var showRecordings = false
    @State private var showPaywall = false

    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()
                Image("recordingWaves")
                VStack {
                    Spacer()

                    Text("Hold to record")
                        .foregroundColor(.white)
                        .font(Font.system(size: 24, weight: .bold))
                    
                    Text(callRecorderVM.counter)
                        .foregroundColor(.white)
                        .opacity(0.5)
                        .padding(.top, 5)
                        .font(Font.system(size: 16))
                    
                    Spacer()

                    Button(action: {
                        callRecorderVM.recordButton(isCallRecording: false)
                    }) {
                        Image("voiceRecorder")
                            .resizable()
                            .frame(width: 200, height: 200)
                    }
                    
                    Spacer()
                    
                    
                    Button {
                        showRecordings = true
                    } label: {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white)
                            .frame(width: 220, height: 60)
                            .overlay {
                                Text("My recordings")
                                    .foregroundColor(.black)
                                    .font(Font.system(size: 18, weight: .bold))
                            }
                    }
                    .padding(.bottom, 40)
                    .fullScreenCover(isPresented: $showRecordings) {
                        MyRecordingsView()
                            .environmentObject(callRecorderVM)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("Voice Recorder")
                        .foregroundColor(.white)
                        .font(.system(size: 24, weight: .bold))
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showPaywall = true
                    }) {
                        Image("premiumButton")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.white)
                    }
                }
            }
        }
        .onAppear {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .black
            appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]

            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().compactAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
            UINavigationBar.appearance().tintColor = .white
        }
        .fullScreenCover(isPresented: $showPaywall, content: {
            PaywallView(initialOpen: false)
        })
    }
}

#Preview {
    VoiceRecorderView()
}
