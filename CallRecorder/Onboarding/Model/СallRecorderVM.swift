import SwiftUI
import Combine
import AVFoundation

final class CallRecorderVM: ObservableObject {
    
    @Published var isRecording = false
    @Published var counter = "00:00:00"
    @Published var progress: CGFloat = 0.0
    var synthVM = SynthViewModel()
    
    var audioRecorder = AudioRecorder.shared
    var audioPlayer = AudioPlayer.shared
    
    private var timer: Timer?
    private var startTime: Date?
    private var recordingDuration: TimeInterval = 60.0  // Example: 60 seconds max duration

    func recordButton(isCallRecording: Bool) {
        if isRecording {
            self.synthVM.speak(text: "Recording Stopped")
            stopRecording(isCallRecording: isCallRecording)
        } else {
            self.synthVM.speak(text: "Recording Started")
            startRecording(isCallRecording: isCallRecording)
        }
    }
    
    func startRecording(isCallRecording: Bool) {
        isRecording = true
        audioRecorder.startRecording(isCallRecording: isCallRecording)
        startTime = Date()
        startTimer()
    }
    
    func stopRecording(isCallRecording: Bool) {
        isRecording = false
        audioRecorder.stopRecording(isCallRecording: isCallRecording)
        stopTimer()
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
        audioRecorder.deleteRecording(urlToDelete: url)
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
