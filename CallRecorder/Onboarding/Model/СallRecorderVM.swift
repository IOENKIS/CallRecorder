import Foundation
import SwiftUI
import Combine
import AVFoundation

final class CallRecorderViewModel: ObservableObject {
    
    @Published var isRecording = false
    @Published var counter = "00:00:00"
    @Published var progress: CGFloat = 0.0
    @Published var allRecords: [Date : [Recording]] = [:]
    var synthVM = SynthViewModel()
    
     var audioRecorder = AudioRecorder.shared
     var audioPlayer = AudioPlayer.shared
    
    private var timer: Timer?
    private var startTime: Date?
    private var recordingDuration: TimeInterval = 60.0  // Example: 60 seconds max duration

    func recordButton() {
        if isRecording {
            self.synthVM.speak(text: "Recording Stopped")
            stopRecording()
        } else {
            self.synthVM.speak(text: "Recording Started")
            startRecording()
        }
    }
    
    private func startRecording() {
        isRecording = true
        audioRecorder.startRecording()
        startTime = Date()
        startTimer()
    }
    
    private func stopRecording() {
        isRecording = false
        audioRecorder.stopRecording()
        stopTimer()
        allRecords = audioRecorder.groupedRecordings
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            self.updateCounter()
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
        counter = "00:00:00"
        progress = 0.0
    }
    
    private func updateCounter() {
        guard let startTime = startTime else { return }
        let elapsed = Date().timeIntervalSince(startTime)
        let hours = Int(elapsed) / 3600
        let minutes = (Int(elapsed) % 3600) / 60
        let seconds = Int(elapsed) % 60
        counter = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        progress = min(CGFloat(elapsed / recordingDuration), 1.0)
    }

    func delete(url: URL) {
        // Delete the recording from the file system
        audioRecorder.deleteRecording(urlToDelete: url)
        
        // Update the allRecords dictionary to remove the deleted recording
        for (key, recordings) in allRecords {
            if let index = recordings.firstIndex(where: { $0.fileURL == url }) {
                allRecords[key]?.remove(at: index)
                if allRecords[key]?.isEmpty == true {
                    allRecords.removeValue(forKey: key)
                }
                break
            }
        }
        
        // Refresh recordings from the audioRecorder
        audioRecorder.fetchRecording()
        allRecords = audioRecorder.groupedRecordings
    }
}

class SynthViewModel: NSObject {
  private var speechSynthesizer = AVSpeechSynthesizer()
  
  override init() {
    super.init()
    self.speechSynthesizer.delegate = self
  }
  
  func speak(text: String) {
    let utterance = AVSpeechUtterance(string: text)
    utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
    speechSynthesizer.speak(utterance)
  }
}

extension SynthViewModel: AVSpeechSynthesizerDelegate {
  func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
    print("started")
  }
  func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didPause utterance: AVSpeechUtterance) {
    print("paused")
  }
  func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didContinue utterance: AVSpeechUtterance) {}
  func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {}
  func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance) {}
  func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
    print("finished")
  }
}
