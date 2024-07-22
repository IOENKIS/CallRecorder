//
//  SettingsView.swift
//  CallRecorder
//
//  Created by IVANKIS on 16.07.2024.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                HStack {
                    Text("Settings")
                        .font(.system(size: 34, weight: .bold))
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding()
                
                List {
                    Section {
                        NavigationLink(destination: Text("Your Number")) {
                            HStack {
                                Image(systemName: "flag.fill")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(.red)
                                VStack(alignment: .leading) {
                                    Text("Your Number")
                                        .font(.system(size: 16, weight: .bold))
                                    Text("+1 855 271 3209")
                                        .foregroundColor(.gray)
                                }
                                Spacer()
                            }
                            .padding()
                        }
                    }
                    .listRowBackground(Color.white)
                    .listStyle(.plain)
                    .cornerRadius(10)
                    
                    Section {
                        NavigationLink(destination: Text("FAQ")) {
                            SettingsRow(iconName: "questionmark.circle", iconColor: .red, title: "FAQ")
                        }
                        NavigationLink(destination: Text("Call Recording Laws")) {
                            SettingsRow(iconName: "doc.text.fill", iconColor: .red, title: "Call Recording Laws")
                        }
                        NavigationLink(destination: Text("Unlimited Access")) {
                            SettingsRow(iconName: "lock.fill", iconColor: .red, title: "Unlimited Access")
                        }
                    }
                    .listRowBackground(Color.white)
                    .cornerRadius(10)
                    
                    Section {
                        NavigationLink(destination: Text("Contact Us")) {
                            SettingsRow(iconName: "envelope.fill", iconColor: .red, title: "Contact Us")
                        }
                        NavigationLink(destination: Text("Privacy Policy")) {
                            SettingsRow(iconName: "shield.fill", iconColor: .red, title: "Privacy Policy")
                        }
                        NavigationLink(destination: Text("Terms of Use")) {
                            SettingsRow(iconName: "doc.fill", iconColor: .red, title: "Terms of Use")
                        }
                        NavigationLink(destination: Text("Share This App")) {
                            SettingsRow(iconName: "square.and.arrow.up.fill", iconColor: .red, title: "Share This App")
                        }
                    }
                    .listRowBackground(Color.white)
                    .cornerRadius(10)
                }
                .listStyle(InsetGroupedListStyle())
            }
            .background(Color.black.edgesIgnoringSafeArea(.all))
        }
    }
}

struct SettingsRow: View {
    let iconName: String
    let iconColor: Color
    let title: String
    
    var body: some View {
        HStack {
            Image(systemName: iconName)
                .resizable()
                .frame(width: 25, height: 25)
                .foregroundColor(iconColor)
            Text(title)
                .font(.system(size: 16))
            Spacer()
        }
        .padding()
    }
}

#Preview {
    SettingsView()
}
