//
//  CallRecorderView.swift
//  CallRecorder
//
//  Created by IVANKIS on 16.07.2024.
//

import SwiftUI

struct CallRecorderView: View {
    @StateObject private var callRecorderVM = CallRecorderVM()

    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()
                VStack {
                    Spacer()
                    
                    Text(callRecorderVM.isRecording ? callRecorderVM.counter : "Tap to record")
                        .foregroundColor(.white)
                        .font(Font.system(size: 24, weight: .bold))
                    
                    Spacer()

                    Button(action: {
                        callRecorderVM.recordButton()
                    }) {
                        Image(callRecorderVM.isRecording ? "stop" : "callRecorder")
                            .resizable()
                            .frame(width: 100, height: 100)
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
            .navigationTitle("Call Recorder")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
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
    CallRecorderView()
}
