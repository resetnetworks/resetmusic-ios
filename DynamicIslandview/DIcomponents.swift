//
//  DIcomponents.swift
//  resetmusic-ios-local
//
//  Created by Naushad Ali Khan on 17/03/26.
//

import SwiftUI

// MARK: - DIAlbumArtView
// Matches PlayerArtwork placeholder — same gradient, same corner radius

struct DIAlbumArtView: View {
    let url: String
    var size: CGFloat = 22

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: size == 22 ? 4 : 6)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.10, green: 0.23, blue: 0.54),
                            Color(red: 0.20, green: 0.41, blue: 0.78)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            if let imageURL = URL(string: url) {
                AsyncImage(url: imageURL) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                    default:
                        Image(systemName: "music.note")
                            .font(.system(size: size * 0.3))
                            .foregroundStyle(.white.opacity(0.4))
                    }
                }
            } else {
                Image(systemName: "music.note")
                    .font(.system(size: size * 0.3))
                    .foregroundStyle(.white.opacity(0.4))
            }
        }
        .frame(width: size, height: size)
        .clipShape(RoundedRectangle(cornerRadius: size == 22 ? 4 : 6))
    }
}

// MARK: - DIWaveformView
// Matches your blue accent color (0.25, 0.55, 1.0) from PlayerProgressBar

struct DIWaveformView: View {
    let isPlaying: Bool

    private let heights: [CGFloat] = [4, 11, 7, 13, 5]
    private let delays: [Double]   = [0, 0.1, 0.2, 0.05, 0.15]
    private let durations: [Double] = [0.7, 0.85, 0.6, 1.0, 0.75]

    var body: some View {
        HStack(spacing: 1.5) {
            ForEach(0..<5, id: \.self) { i in
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color(red: 0.25, green: 0.55, blue: 1.0))
                    .frame(width: 2, height: isPlaying ? heights[i] : 3)
                    .animation(
                        isPlaying
                            ? .easeInOut(duration: durations[i])
                                .repeatForever(autoreverses: true)
                                .delay(delays[i])
                            : .easeOut(duration: 0.2),
                        value: isPlaying
                    )
            }
        }
        .frame(width: 14, height: 14)
    }
}

// MARK: - DIProgressArcView
// Arc stroke uses your blue accent — matches PlayerProgressBar fill color

struct DIProgressArcView: View {
    let progress: Double

    var body: some View {
        ZStack {
            Circle()
                .stroke(.white.opacity(0.18), lineWidth: 2)
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    Color(red: 0.25, green: 0.55, blue: 1.0),
                    style: StrokeStyle(lineWidth: 2, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .animation(.linear(duration: 0.5), value: progress)
        }
    }
}
