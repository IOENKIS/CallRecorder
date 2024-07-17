//
//  AudioPlayer.swift
//  CallRecorder
//
//  Created by IVANKIS on 17.07.2024.
//

import SwiftUI
import Combine
import AVFoundation

class AudioPlayer: NSObject, ObservableObject, AVAudioPlayerDelegate {
    
    let objectWillChange = PassthroughSubject<AudioPlayer, Never>()
    
    static let shared = AudioPlayer()
    
    var isPlaying = false {
        didSet {
            objectWillChange.send(self)
        }
    }
    
    var audioPlayer: AVAudioPlayer!
    @Published var currentTime: TimeInterval = 0 // Property to store the current playback time
    
    func startPlayback(audio: URL) {
        let playbackSession = AVAudioSession.sharedInstance()
        
        do {
            try playbackSession.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
        } catch {
            print("Playing over the device's speakers failed")
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audio)
            audioPlayer.delegate = self
            audioPlayer.play()
            isPlaying = true
            
            // Start a timer to periodically update the current time
            Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
                self.currentTime = self.audioPlayer.currentTime
                if !self.isPlaying {
                    timer.invalidate()
                }
            }
            
        } catch {
            print("Playback failed.")
        }
    }
    
    func stopPlayback() {
        audioPlayer.stop()
        isPlaying = false
        currentTime = audioPlayer.currentTime // Update current time when playback stops
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            isPlaying = false
            currentTime = player.currentTime // Update current time when playback finishes
        }
    }
}
