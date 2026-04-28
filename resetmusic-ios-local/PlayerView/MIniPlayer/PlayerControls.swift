//
//  PlayerControls.swift
//  resetmusic-ios-local
//
//  Created by Naushad Ali Khan on 13/03/26.
//


// MARK: - PlayerControls.swift

import SwiftUI

struct PlayerControls: View {
    let isPlaying: Bool
    var onPrevious: () -> Void = {}
    var onPlayPause: () -> Void = {}
    var onNext: () -> Void = {}

    var body: some View {
        HStack(spacing: 4) {

            // Previous
            Button(action: onPrevious) {
                Image(systemName: "backward.end.fill")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white.opacity(0.8))
                    .frame(width: 36, height: 36)
            }
            .buttonStyle(.plain)

            // Play / Pause
            Button(action: onPlayPause) {
                ZStack {
                    Circle()
                        .fill(.white)
                        .frame(width: 36, height: 36)
                    Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.black)
                        .offset(x: isPlaying ? 0 : 0.5)
                        .scaleEffect(isPlaying ? 1.0 : 0.9)
                        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPlaying)
                }
            }
            .buttonStyle(.plain)

            // Next
            Button(action: onNext) {
                Image(systemName: "forward.end.fill")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white.opacity(0.8))
                    .frame(width: 36, height: 36)
            }
            .buttonStyle(.plain)
        }
    }
}

#Preview {
    VStack(spacing: 24) {
        PlayerControls(isPlaying: true)
        PlayerControls(isPlaying: false)
    }
    .padding()
    .background(Color(red: 0.04, green: 0.07, blue: 0.18))
}
