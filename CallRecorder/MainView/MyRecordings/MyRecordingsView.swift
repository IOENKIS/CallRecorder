//
//  MyRecordingsView.swift
//  CallRecorder
//
//  Created by IVANKIS on 17.07.2024.
//

import SwiftUI
import AVFoundation
  
struct MyRecordingsView: View {
    
    //    @EnvironmentObject var vm: RecordingsViewModel
    @EnvironmentObject var vm: CallRecorderViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack {
            HStack {
                Text("My Recordings")
                    .font(Font.title2.weight(.bold))
                
                Spacer()
                
                Button {
                    dismiss()
                } label: {
                    Image("dismissButton")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.white)
                }
            }
            .padding(.horizontal)
            .padding(.top, 35)
            
            ScrollView {
                
                ForEach(vm.audioRecorder.groupedRecordings.keys.sorted(by: >), id: \.self) { date in
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Section(header: Text(date.toDayMonthYearString())
                            .foregroundStyle(.gray)
                                
                            .font(Font.system(size: 17, weight: .light))) {
                                
                                ForEach(vm.audioRecorder.groupedRecordings[date]!, id: \.fileURL) { recording in
                                    RecordingRowView(audioURL: recording.fileURL, duration: recording.duration)
                                        .environmentObject(vm)
                                }
                            }
                    }.frame(maxWidth: .infinity, alignment: .center)
                }
            }
        }
        .background(Color.gray.opacity(0.1))
    }
}
