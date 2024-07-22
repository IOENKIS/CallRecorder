import SwiftUI
import AVFoundation

struct RecordingRowView: View {
    
    var audioURL: URL
    var duration: TimeInterval
    var recordingName: String
    var recordingDate: String
    
    @State private var isPlaying = false
    @State private var currentTime: TimeInterval = 0.0
    @State private var deleteAlert = false
    @State private var timer: Timer?
    @State private var showingShareSheet = false
    
    @EnvironmentObject var vm: CallRecorderVM
    
    var body: some View {
        VStack {
            HStack(spacing: 10) {
                if !isPlaying {
                    Button(action: {
                        startPlayback()
                    }) {
                        Image("play")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 50)
                    }
                    .padding(.trailing, 10)
                } else {
                    Button(action: {
                        stopPlayback()
                    }) {
                        Image("stop")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 50)
                    }
                    .padding(.trailing, 10)
                }
                
                VStack(alignment: .leading) {
                    Text(recordingName)
                        .foregroundColor(.white)
                        .font(.system(size: 16, weight: .bold))
                    
                    Text(recordingDate)
                        .foregroundColor(.white)
                        .font(.system(size: 14))
                }
                
                Spacer()
                
                Menu {
                    Button(action: {
                        showingShareSheet = true
                    }) {
                        Label("Share", systemImage: "square.and.arrow.up")
                            .foregroundColor(.red)
                    }
                    
                    Button(action: {
                        deleteAlert = true
                    }) {
                        Label("Delete", systemImage: "trash")
                            .foregroundColor(.red)
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .font(Font.system(size: 25))
                        .foregroundColor(.gray)
                        .padding(.trailing, 10)
                }
            }
            
            if isPlaying {
                ProgressView(value: currentTime, total: duration)
                    .accentColor(.white)
                    .progressViewStyle(LinearProgressViewStyle(tint: .white))
                    .padding(.top, 5)
                
                HStack {
                    Text(timeString(from: currentTime))
                        .foregroundColor(.white)
                        .font(.system(size: 14))
                    Spacer()
                    Text("-\(timeString(from: duration - currentTime))")
                        .foregroundColor(.white)
                        .font(.system(size: 14))
                }
            }
        }
        .padding(8)
        .background(RoundedRectangle(cornerRadius: 10)
            .foregroundColor(.red))
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
        .sheet(isPresented: $showingShareSheet, content: {
            ActivityView(activityItems: [audioURL])
        })
        .onAppear {
            setupTimer()
        }
        .onDisappear {
            stopTimer()
        }
    }
    
    private func startPlayback() {
        let audioPlayer = AudioPlayer.shared
        audioPlayer.startPlayback(audio: audioURL)
        isPlaying = true
    }
    
    private func stopPlayback() {
        let audioPlayer = AudioPlayer.shared
        audioPlayer.stopPlayback()
        isPlaying = false
        currentTime = 0
    }
    
    private func setupTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            guard let audioPlayer = AudioPlayer.shared.audioPlayer else { return }
            self.currentTime = audioPlayer.currentTime
            if !audioPlayer.isPlaying {
                self.stopTimer()
            }
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func timeString(from time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

struct ActivityView: UIViewControllerRepresentable {
    var activityItems: [Any]
    var applicationActivities: [UIActivity]? = nil

    func makeUIViewController(context: UIViewControllerRepresentableContext<ActivityView>) -> UIActivityViewController {
        return UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: UIViewControllerRepresentableContext<ActivityView>) {}
}
