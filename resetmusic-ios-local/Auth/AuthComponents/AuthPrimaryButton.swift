//
//  AuthPrimaryButton.swift
//  resetmusic-ios-local
//
//  Created by Naushad Ali Khan on 12/03/26.
//


import SwiftUI

struct AuthPrimaryButton: View {
    let title: String
    var isLoading: Bool = false
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack {
                if isLoading {
                    ProgressView()
                        .tint(.white)
                } else {
                    Text(title)
                        .font(.custom("Jura-SemiBold", size: 16))
                        .foregroundColor(.white)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(hex: "0F3272"),
                                Color(hex: "1A5DB4"),
                                Color(hex: "3B82F6")
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
            )

            .cornerRadius(12)
        }
        .buttonStyle(.plain)
        .disabled(isLoading)
    }
}
