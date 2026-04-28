//
//  LockScreenBannerView.swift
//  resetmusic-ios-local
//
//  Created by Naushad Ali Khan on 17/03/26.
//


import SwiftUI
import WidgetKit
import AppIntents
// MARK: - LockScreenBannerView
// Shown on Lock Screen and StandBy — mirrors StickyPlayerBar exactly

struct LockScreenBannerView: View {
    let context: ActivityViewContext<MusicPlayerAttributes>

    var body: some View {
        VStack(spacing: 0) {

            // Progress bar — matches PlayerProgressBar
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color.white.opacity(0.12))
                        .frame(height: 2)
                    Rectangle()
                        .fill(Color(red: 0.25, green: 0.55, blue: 1.0))
                        .frame(width: geo.size.width * context.state.progress, height: 2)
                }
            }
            .frame(height: 2)

            // Main row — matches StickyPlayerBar HStack
            HStack(spacing: 12) {

                // Album art — matches PlayerArtwork size: 44
                DIAlbumArtView(url: context.state.coverImageURL, size: 44)

                // Track info — matches PlayerTrackInfo
                VStack(alignment: .leading, spacing: 2) {
                    Text(context.state.title)
                        .font(.custom("Jura-SemiBold", size: 14))
                        .foregroundStyle(.white)
                        .lineLimit(1)

                    if !context.state.artistName.isEmpty {
                        Text(context.state.artistName)
                            .font(.custom("Jura-Regular", size: 12))
                            .foregroundStyle(.white.opacity(0.55))
                            .lineLimit(1)
                    }
                }

                Spacer()

                // Controls — matches PlayerControls
                HStack(spacing: 4) {

                    // Previous
                    Button(intent: SkipPreviousIntent()) {
                        Image(systemName: "backward.end.fill")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(.white.opacity(0.8))
                            .frame(width: 36, height: 36)
                    }
                    .buttonStyle(.plain)

                    // Play / Pause
                    Button(intent: TogglePlayPauseIntent()) {
                        ZStack {
                            Circle()
                                .fill(.white)
                                .frame(width: 36, height: 36)
                            Image(systemName: context.state.isPlaying ? "pause.fill" : "play.fill")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(.black)
                                .offset(x: context.state.isPlaying ? 0 : 1.5)
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 10)
        }
        // Matches StickyPlayerBar background exactly
        .background(
            ZStack {
                Color(red: 0.04, green: 0.07, blue: 0.18)
                LinearGradient(
                    colors: [
                        Color(red: 0.08, green: 0.14, blue: 0.32).opacity(0.8),
                        Color(red: 0.03, green: 0.06, blue: 0.16).opacity(0.95)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            }
        )
    }
}
