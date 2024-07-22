import SwiftUI

struct MyRecordingsView: View {
    @StateObject private var audioRecorder = AudioRecorder.shared
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text("My recordings")
                        .foregroundColor(.white)
                        .font(.system(size: 24, weight: .bold))
                    
                    Spacer()
                    
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image("dismissButton")
                            .font(Font.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.black)
                            .clipShape(Circle())
                    }
                }
                .padding()
                
                if audioRecorder.callRecordings.isEmpty && audioRecorder.voiceRecordings.isEmpty {
                    VStack {
                        Spacer()
                        Image("emptyImage")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 200, height: 200)
                        Spacer()
                    }
                } else {
                    ScrollView {
                        if !audioRecorder.callRecordings.isEmpty {
                            callRecordingsSection
                        }
                        if !audioRecorder.voiceRecordings.isEmpty {
                            voiceRecordingsSection
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.horizontal, 20)
                }
            }
            .navigationBarHidden(true)
            .background(Color.black.edgesIgnoringSafeArea(.all)) // Задній фон всієї в'юшки чорного кольору
        }
    }
    
    private var callRecordingsSection: some View {
        Section(header: Text("Call recordings")
            .foregroundColor(.white)
            .font(.system(size: 20, weight: .bold))
            .padding(.top, 10)
        ) {
            ForEach(audioRecorder.callRecordings) { recording in
                RecordingRowView(
                    audioURL: recording.fileURL,
                    duration: recording.duration,
                    recordingName: getRecordingName(recording, in: audioRecorder.callRecordings),
                    recordingDate: recording.formattedDate
                )
                .environmentObject(CallRecorderVM()) // Передача CallRecorderVM
                .listRowBackground(Color.clear) // Прозорий фон для рядка списку
            }
        }
    }
    
    private var voiceRecordingsSection: some View {
        Section(header: Text("Voice recordings")
            .foregroundColor(.white)
            .font(.system(size: 20, weight: .bold))
            .padding(.top, 10)
        ) {
            ForEach(audioRecorder.voiceRecordings) { recording in
                RecordingRowView(
                    audioURL: recording.fileURL,
                    duration: recording.duration,
                    recordingName: getRecordingName(recording, in: audioRecorder.voiceRecordings),
                    recordingDate: recording.formattedDate
                )
                .environmentObject(CallRecorderVM()) // Передача CallRecorderVM
                .listRowBackground(Color.clear) // Прозорий фон для рядка списку
            }
        }
    }
    
    private func getRecordingName(_ recording: Recording, in recordings: [Recording]) -> String {
        guard let index = recordings.firstIndex(where: { $0.id == recording.id }) else {
            return "Запис"
        }
        return "Запис \(index + 1)"
    }
}

#Preview {
    MyRecordingsView()
        .environmentObject(CallRecorderVM())
}
