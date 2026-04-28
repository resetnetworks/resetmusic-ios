//
//  CustomTabButton.swift
//  resetmusic-ios-local
//
//  Created by Naushad Ali Khan on 09/03/26.
//

import SwiftUI

struct CustomTabButton: View {

    let icon: String
    let label: String
    let isSelected: Bool
    let action: () -> Void

    private var iconColor: Color {
        isSelected ? Color(red: 0.25, green: 0.55, blue: 1.0) : Color.white.opacity(0.4)
    }

    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {

                // ✅ Custom home icon for "house", SF Symbol for everything else
                if icon == "house.fill" {
                    HomeIcon(size: 24, color: iconColor)
                        .scaleEffect(isSelected ? 1.05 : 1.0)
                        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
                        .frame(width: 24, height: 24)
                } else {
                    Image(systemName: icon)
                        .font(.system(size: 22, weight: isSelected ? .semibold : .regular))
                        .foregroundColor(iconColor)
                        .scaleEffect(isSelected ? 1.05 : 1.0)
                        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
                }

                Text(label)
                    .font(.custom(isSelected ? "Jura-SemiBold" : "Jura-Regular", size: 11))
                    .foregroundColor(iconColor)
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.plain)
    }
}
