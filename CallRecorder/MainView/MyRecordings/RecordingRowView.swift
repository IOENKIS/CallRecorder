//
//  RecordingRowView.swift
//  CallRecorder
//
//  Created by IVANKIS on 17.07.2024.
//

import SwiftUI
import AVFoundation

struct RecordingRowView: View {
    
    var audioURL: URL
    var duration: TimeInterval
    
    @State var durationAnimation: TimeInterval = 0.0
    @State var isPlaying = false
    @State private var gradientOffset: CGFloat = 0
    @State private var player: AVPlayer?
    @State private var revealAmount: CGFloat = 0.0
    @State private var deleteAlert = false
    
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    @ObservedObject var audioPlayer = AudioPlayer()
    @EnvironmentObject var vm: CallRecorderViewModel
    
    var body: some View {
        HStack(spacing: 10) {
            if audioPlayer.isPlaying == false {
                Button(action: {
                    self.audioPlayer.startPlayback(audio: self.audioURL)
                    revealAmount = 250
                    durationAnimation = duration
                }) {
                    Image("play")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50)
                }
            } else {
                Button(action: {
                    self.audioPlayer.stopPlayback()
                    revealAmount = 0
                    durationAnimation = 0.0
                }) {
                    Image("stop")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50)
                }
            }
            
            AudioLine(animate: $audioPlayer.isPlaying, duration: $durationAnimation, revealAmount: $revealAmount)
            
            Button {
                deleteAlert = true
            } label: {
                Image(systemName: "trash")
                    .font(Font.system(size: 25))
                    .foregroundStyle(.gray)
            }
        }.padding(8)
            .background(RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(.white))
            .shadow(color: .gray.opacity(0.3), radius: 4)
            .alert(isPresented: $deleteAlert) {
                          Alert(
                              title: Text("Delete Recording"),
                              message: Text("Do you want to delete this recording?"),
                              primaryButton: .destructive(Text("Yes")) {
                                  withAnimation {
                                      vm.delete(url: audioURL)
                                  }
                              },
                              secondaryButton: .cancel()
                          )
                      }
    }
}
