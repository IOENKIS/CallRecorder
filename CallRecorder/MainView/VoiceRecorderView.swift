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

    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()
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
                        // Дія кнопки, якщо потрібно
                    }) {
                        Image("voiceRecorder")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .gesture(
                                LongPressGesture(minimumDuration: 0.1)
                                    .onChanged { _ in
                                        callRecorderVM.startRecording()
                                    }
                                    .onEnded { _ in
                                        callRecorderVM.stopRecording()
                                    }
                            )
                    }
                    
                    Spacer()
                    
                    Button {
                        // Дія кнопки "My recordings"
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
                        // Дія кнопки
                    }) {
                        Image(systemName: "premiumButton")
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
    }
}

#Preview {
    VoiceRecorderView()
}
