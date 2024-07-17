//
//  MainView.swift
//  CallRecorder
//
//  Created by IVANKIS on 15.07.2024.
//

import SwiftUI

struct MainView: View {
    @State private var selectedView = 0
    
    var body: some View {
        VStack {
            
            // Вибір між різними виглядами
            if selectedView == 0 {
                CallRecorderView()
            } else if selectedView == 1 {
                VoiceRecorderView()
            } else if selectedView == 2 {
                SettingsView()
            }
            
            HStack(spacing: 0){
                Button(action: {
                    selectedView = 0
                }) {
                    Image(selectedView == 0 ? "callTabItemSelected" : "callTabItem")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
                
                Button(action: {
                    selectedView = 1
                }) {
                    Image(selectedView == 1 ? "voiceTabItemSelected" : "voiceTabItem")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
                
                Button(action: {
                    selectedView = 2
                }) {
                    Image(selectedView == 2 ? "settingsTabItemSelected" : "settingsTabItem")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
            }
            .offset(y: 40)
        }
        .background(Color.black)
    }
}

#Preview {
    MainView()
}
