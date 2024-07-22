//
//  RecordModel.swift
//  CallRecorder
//
//  Created by IVANKIS on 17.07.2024.
//

import Foundation

struct Recording: Identifiable{
    let id = UUID()
    let fileURL: URL
    let createdAt: Date
    let duration: TimeInterval
    let isCallRecording: Bool
    
    var formattedDate: String {
        return createdAt.toString(dateFormat: "yyyy-MM-dd")
    }
}
