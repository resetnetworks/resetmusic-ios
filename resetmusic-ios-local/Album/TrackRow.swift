//
//  TrackRow.swift
//  resetmusic-ios-local
//
//  Created by Naushad Ali Khan on 07/03/26.
//

import SwiftUI
import Kingfisher

struct TrackRow: View {

    let song: Song
    var isCurrentTrack: Bool = false  // this song is loaded (playing OR paused)
    var isPlaying: Bool = false        // this song is actively playing
    var onPlay: () -> Void = {}
    var onMore: () -> Void = {}

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 16) {

                // Thumbnail — tap to play
                Button(action: onPlay) {
                    ZStack {
                        KFImage(URL(string: song.coverImage ?? ""))
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
                                // Animated waveform when playing
                                Image(systemName: "waveform")
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundColor(Color(red: 0.25, green: 0.55, blue: 1.0))
                                    .symbolEffect(.variableColor.iterative)
                            } else {
                                // Static pause icon when paused
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
                    Text(song.title)
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
                    Text(song.formattedDuration)
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
