//
//  AudioRecorder.swift
//  CallRecorder
//
//  Created by IVANKIS on 16.07.2024.
//

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
    
    var recordings = [Recording]()
    
    var recording = false {
        didSet {
            objectWillChange.send(self)
        }
    }
    
    var groupedRecordings: [Date: [Recording]]  = [:]
    
    func startRecording() {
        let recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
        } catch {
            print("Failed to set up recording session")
        }
        
        let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let audioFilename = documentPath.appendingPathComponent("\(Date().toString(dateFormat: "dd-MM-YY 'at' HH:mm:ss")).m4a")
        
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
    
    func stopRecording() {
        audioRecorder.stop()
        recording = false
        
        fetchRecording()
        print("done")
    }
    
    func fetchRecording() {
        recordings.removeAll()
        
        let fileManager = FileManager.default
        let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let directoryContents = try! fileManager.contentsOfDirectory(at: documentDirectory, includingPropertiesForKeys: nil)
        for audio in directoryContents {
            let duration = getAudioDuration(for: audio)
                       let recording = Recording(fileURL: audio, createdAt: getFileDate(for: audio), duration: duration)
                       recordings.append(recording)
        }
        
        recordings.sort(by: { $0.createdAt.compare($1.createdAt) == .orderedDescending})
        
        objectWillChange.send(self)
        
        groupedRecordings = Dictionary(grouping: recordings) { (recording) -> Date in
            let components = Calendar.current.dateComponents([.year, .month, .day], from: recording.createdAt)
            return Calendar.current.date(from: components)!
        }
    }
    
    func deleteRecording(urlToDelete: URL) {
            
            do {
               try FileManager.default.removeItem(at: urlToDelete)
            } catch {
                print("File could not be deleted!")
            }
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
