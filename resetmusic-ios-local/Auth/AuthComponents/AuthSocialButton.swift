//
//  AuthSocialButton.swift
//  resetmusic-ios-local
//
//  Created by Naushad Ali Khan on 12/03/26.
//


import SwiftUI

struct AuthSocialButton: View {
    let title: String
    let icon: String           // SF Symbol name or use imageName
    let imageName: String?     // Asset image name (e.g. "google-logo")
    let action: () -> Void

    init(title: String, icon: String = "", imageName: String? = nil, action: @escaping () -> Void) {
        self.title = title
        self.icon = icon
        self.imageName = imageName
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: 10) {
                if let imageName {
                    Image(imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                } else if !icon.isEmpty {
                    Image(systemName: icon)
                        .font(.system(size: 18))
                        .foregroundColor(.white)
                }
                Text(title)
                    .font(.custom("Jura-SemiBold", size: 15))
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .background(Color(red: 0.08, green: 0.10, blue: 0.18))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.white.opacity(0.12), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}