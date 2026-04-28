//
//  LibraryPlayButton.swift
//  resetmusic-ios-local
//
//  Created by Naushad Ali Khan on 13/04/26.
//


import SwiftUI

struct LibraryPlayButton: View {
    var action: () -> Void = {}
    @State private var isPlaying: Bool = false

    var body: some View {
        Button(action: onPlayPause) {
            ZStack {
                Circle()
                    .fill(.white)
                    .frame(width: 36, height: 36)

                Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color(hex: "0F3272"), Color(hex: "1A5DB4")],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .offset(x: isPlaying ? 0 : 0.5)
                    .scaleEffect(isPlaying ? 1.0 : 0.9)
                    .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPlaying)
            }
        }
        .buttonStyle(.plain)
    }

    private func onPlayPause() {
        isPlaying.toggle()
        action()
    }
}