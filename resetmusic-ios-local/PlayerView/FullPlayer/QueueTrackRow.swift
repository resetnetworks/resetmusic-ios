//
//  QueueTrackRow.swift
//  resetmusic-ios-local
//
//  Created by Naushad Ali Khan on 13/04/26.
//

import SwiftUI
import Kingfisher

struct QueueTrackRow: View {

    let track: PlayerTrack
    var isCurrentTrack: Bool = false
    var isPlaying: Bool = false

    var onPlay: () -> Void = {}
    var onLike: () -> Void = {}
    var onMore: () -> Void = {}

    var body: some View {
        VStack(spacing: 0) {

            HStack(spacing: 16) {

                // Thumbnail — tap to play
                Button(action: onPlay) {
                    ZStack {
                        KFImage(URL(string: track.coverImage))
                            .placeholder {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color(red: 0.1, green: 0.12, blue: 0.2))
                            }
                            .resizable()
                            .scaledToFill()
                            .frame(width: 52, height: 52)
                            .clipShape(RoundedRectangle(cornerRadius: 8))

                        if isCurrentTrack {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.black.opacity(0.45))
                                .frame(width: 52, height: 52)

                            if isPlaying {
                                // Animated waveform
                                Image(systemName: "waveform")
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundColor(Color(red: 0.25, green: 0.55, blue: 1.0))
                                    .symbolEffect(.variableColor.iterative)
                            } else {
                                // Pause icon
                                Image(systemName: "pause.fill")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(Color(red: 0.25, green: 0.55, blue: 1.0))
                            }
                        }
                    }
                }
                .buttonStyle(.plain)

                // Title
                Button(action: onPlay) {
                    Text(track.title)
                        .font(.custom("Jura-Regular", size: 16))
                        .foregroundColor(isCurrentTrack
                            ? Color(red: 0.25, green: 0.55, blue: 1.0)
                            : .white)
                        .lineLimit(1)
                        .truncationMode(.tail)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .buttonStyle(.plain)

                // Duration
                HStack(spacing: 4) {
                    Image(systemName: "clock")
                        .font(.system(size: 12))
                        .foregroundColor(.white.opacity(0.4))

                    Text(track.formattedDuration) // <-- make sure this exists
                        .font(.custom("Jura-Regular", size: 14))
                        .foregroundColor(.white.opacity(0.6))
                }



                // More
                Button(action: onMore) {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 18))
                        .foregroundColor(.white.opacity(0.6))
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)

            Divider()
                .background(Color.white.opacity(0.08))
                .padding(.horizontal, 16)
        }
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()

        VStack(spacing: 0) {

            // Normal track
            QueueTrackRow(
                track: PlayerTrack(
                    title: "Blinding Lights",
                    artistName: "The Weeknd",
                    artistId: "1",
                    coverImage: "https://i.scdn.co/image/ab67616d0000b273e3c79c77e2c1d7b5a0c9e4d0",
                    duration: 200
                )
            )

            // Current + Playing
            QueueTrackRow(
                track: PlayerTrack(
                    title: "Starboy",
                    artistName: "The Weeknd",
                    artistId: "2",
                    coverImage: "https://i.scdn.co/image/ab67616d0000b2734718e2b124b2c2c2b1766fa0",
                    duration: 230
                ),
                isCurrentTrack: true,
                isPlaying: true
            )

            // Current + Paused
            QueueTrackRow(
                track: PlayerTrack(
                    title: "Save Your Tears",
                    artistName: "The Weeknd",
                    artistId: "3",
                    coverImage: "https://i.scdn.co/image/ab67616d0000b2738c7f9d9f7a1fcb4b9ac898b1",
                    duration: 215
                ),
                isCurrentTrack: true,
                isPlaying: false
            )

        }
        .padding(.horizontal, 12)
    }
}
