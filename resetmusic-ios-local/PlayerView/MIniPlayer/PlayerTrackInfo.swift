//
//  PlayerTrackInfo.swift
//  resetmusic-ios-local
//
//  Created by Naushad Ali Khan on 13/03/26.
//


// MARK: - PlayerTrackInfo.swift
import SwiftUI
struct PlayerTrackInfo: View {
    let track: PlayerTrack

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(track.title)
                .font(.custom("Jura-SemiBold", size: 14))
                .foregroundColor(.white)
                .lineLimit(1)
                .transition(.opacity.combined(with: .move(edge: .bottom)))

            if !track.artistName.isEmpty {
                Text(track.artistName)
                    .font(.custom("Jura-Regular", size: 12))
                    .foregroundColor(.white.opacity(0.55))
                    .lineLimit(1)
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.25), value: track.title)
    }
}

#Preview {
    VStack(alignment: .leading, spacing: 20) {
        // Full info
        PlayerTrackInfo(track: PlayerTrack(
            title: "Shifting Layers",
            artistName: "Nariel",
            artistId: "",
            coverImage: ""
        ))
        // No artist
        PlayerTrackInfo(track: PlayerTrack(
            title: "No track playing",
            artistName: "",
            artistId: "",
            coverImage: ""
        ))
        // Long title truncation
        PlayerTrackInfo(track: PlayerTrack(
            title: "This Is A Very Long Track Title That Should Truncate",
            artistName: "Some Artist With A Long Name Too",
            artistId: "",
            coverImage: ""
        ))
    }
    .padding()
    .background(Color(red: 0.04, green: 0.07, blue: 0.18))
}
