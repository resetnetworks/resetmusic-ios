//
//  MusicLiveActivityWidget.swift
//  resetmusic-ios-local
//
//  Created by Naushad Ali Khan on 17/03/26.
//


import SwiftUI
import WidgetKit
import ActivityKit
import AppIntents

struct MusicLiveActivityWidget: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: MusicPlayerAttributes.self) { context in

            // Lock Screen + StandBy banner
            LockScreenBannerView(context: context)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded (long-press) — left empty, add later if needed
                DynamicIslandExpandedRegion(.leading)  { }
                DynamicIslandExpandedRegion(.trailing) { }
                DynamicIslandExpandedRegion(.bottom)   { }

            } compactLeading: {
                // Left pill — album art + waveform
                HStack(spacing: 4) {
                    DIAlbumArtView(url: context.state.coverImageURL)
                    DIWaveformView(isPlaying: context.state.isPlaying)
                }
                .padding(.leading, 2)

            } compactTrailing: {
                // Right pill — prev, play/pause, progress arc
                HStack(spacing: 4) {
                    Button(intent: SkipPreviousIntent()) {
                        Image(systemName: "backward.end.fill")
                            .font(.system(size: 9, weight: .semibold))
                            .foregroundStyle(.white.opacity(0.8))
                    }
                    .buttonStyle(.plain)

                    Button(intent: TogglePlayPauseIntent()) {
                        Image(systemName: context.state.isPlaying ? "pause.fill" : "play.fill")
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundStyle(.white)
                    }
                    .buttonStyle(.plain)

                    DIProgressArcView(progress: context.state.progress)
                        .frame(width: 20, height: 20)
                }
                .padding(.trailing, 4)

            } minimal: {
                // Single island (two apps competing) — just the arc
                DIProgressArcView(progress: context.state.progress)
                    .frame(width: 20, height: 20)
            }
        }
        .contentMarginsDisabled()
        .supplementalActivityFamilies([.small, .medium])
    }
}
