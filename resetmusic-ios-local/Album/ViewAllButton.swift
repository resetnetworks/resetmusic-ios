//
//  ViewAllButton.swift
//  resetmusic-ios-local
//
//  Created by Naushad Ali Khan on 07/03/26.
//


import SwiftUI

// MARK: - Shared View All Button

struct ViewAllButton: View {

    var action: () -> Void = {}

    var body: some View {
        Button(action: action) {
            Text("See  All")
                .font(.custom("Jura-Regular", size: 14))
                .foregroundColor(.white.opacity(0.6))
        }
        .buttonStyle(.plain)
    }
}
