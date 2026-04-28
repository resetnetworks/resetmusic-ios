//
//  MoreMenuButton.swift
//  resetmusic-ios-local
//
//  Created by Naushad Ali Khan on 13/04/26.
//


import SwiftUI

struct MoreMenuButton: View {
    var action: () -> Void = {}

    var body: some View {
        Button(action: action) {
            Image(systemName: "ellipsis")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(Color.white.opacity(0.3))
                .rotationEffect(.degrees(90))
        }
        .buttonStyle(.plain)
    }
}