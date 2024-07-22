import SwiftUI
import Combine
import AVFoundation

class AudioRecorder: NSObject, ObservableObject {
    
    static let shared = AudioRecorder()
    
    override init() {
        super.init()
        fetchRecording()
    }
    
    let objectWillChange = PassthroughSubject<AudioRecorder, Never>()
    
    var audioRecorder: AVAudioRecorder!
    
    @Published var callRecordings = [Recording]()
    @Published var voiceRecordings = [Recording]()
    
    var recording = false {
        didSet {
            objectWillChange.send(self)
        }
    }
    
    func startRecording(isCallRecording: Bool) {
        let recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
        } catch {
            print("Failed to set up recording session")
        }
        
        let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let audioFilename = documentPath.appendingPathComponent("\(isCallRecording ? "call_" : "voice_")\(Date().toString(dateFormat: "yyyy-MM-dd_HH-mm-ss")).m4a")
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.record()

            recording = true
        } catch {
            print("Could not start recording")
        }
    }
    
    func stopRecording(isCallRecording: Bool) {
        audioRecorder.stop()
        recording = false
        
        let newRecording = Recording(fileURL: audioRecorder.url, createdAt: Date(), duration: getAudioDuration(for: audioRecorder.url), isCallRecording: isCallRecording)
        
        if isCallRecording {
            callRecordings.append(newRecording)
        } else {
            voiceRecordings.append(newRecording)
        }
        
        objectWillChange.send(self)
    }
    
    func fetchRecording() {
        callRecordings.removeAll()
        voiceRecordings.removeAll()
        
        let fileManager = FileManager.default
        let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let directoryContents = try! fileManager.contentsOfDirectory(at: documentDirectory, includingPropertiesForKeys: nil)
        for audio in directoryContents {
            let duration = getAudioDuration(for: audio)
            let isCallRecording = audio.lastPathComponent.hasPrefix("call_")
            let recording = Recording(fileURL: audio, createdAt: getFileDate(for: audio), duration: duration, isCallRecording: isCallRecording)
            if recording.isCallRecording {
                callRecordings.append(recording)
            } else {
                voiceRecordings.append(recording)
            }
        }
        
        callRecordings.sort(by: { $0.createdAt.compare($1.createdAt) == .orderedDescending })
        voiceRecordings.sort(by: { $0.createdAt.compare($1.createdAt) == .orderedDescending })
        
        objectWillChange.send(self)
    }
    
    func deleteRecording(urlToDelete: URL) {
        do {
            try FileManager.default.removeItem(at: urlToDelete)
        } catch {
            print("File could not be deleted!")
        }
        callRecordings.removeAll { $0.fileURL == urlToDelete }
        voiceRecordings.removeAll { $0.fileURL == urlToDelete }
        fetchRecording()
    }
}

func getFileDate(for file: URL) -> Date {
    if let attributes = try? FileManager.default.attributesOfItem(atPath: file.path) as [FileAttributeKey: Any],
        let creationDate = attributes[FileAttributeKey.creationDate] as? Date {
        return creationDate
    } else {
        return Date()
    }
}

func getAudioDuration(for file: URL) -> TimeInterval {
    let audioAsset = AVURLAsset(url: file)
    return CMTimeGetSeconds(audioAsset.duration)
}
