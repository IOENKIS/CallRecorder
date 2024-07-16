//
//  SplashView.swift
//  PrinterApp
//
//  Created by IVANKIS on 25.06.2024.
//

import SwiftUI

struct SplashView: View {
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            VStack(spacing: 40){
                Spacer()
                Spacer()
                Image("splashIcon")
                    .resizable()
                    .frame(width: 150, height: 150)
                Text("Call Recorder")
                    .font(.system(size: 25, weight: .medium))
                    .foregroundStyle(.white)
                Spacer()
                Spacer()
                Image("loadingIcon")
                    .resizable()
                    .frame(width: 50, height: 50)
            }
        }
    }
}

#Preview {
    SplashView()
}
