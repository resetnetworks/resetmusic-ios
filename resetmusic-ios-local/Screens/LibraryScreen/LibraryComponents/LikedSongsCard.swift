//
//  LikedSongsCard.swift
//  resetmusic-ios-local
//
//  Created by Naushad Ali Khan on 13/04/26.
//


import SwiftUI
import Kingfisher

// ─────────────────────────────────────────────
// MARK: - Liked Songs Card
// ─────────────────────────────────────────────
// Two tiles side by side — 40% left / 60% right.
// Inner edges are sharp, outer edges rounded (r=16).
// Gap of 8pt between tiles.

struct LikedSongsCard: View {
    let item: LikedSongsItem
    var onPlay: () -> Void = {}
    var latestCoverURL: String? = "https://d3tp8cbw5vz2ok.cloudfront.net/covers/11de53a6-975f-45b7-b713-0675b34f6375.jpg"

    private let cardHeight: CGFloat = 120
    private let gap:        CGFloat = 8
    private let r:          CGFloat = 16

    var body: some View {
        GeometryReader { geo in
            let leftWidth  = (geo.size.width - gap) * 0.4
            let rightWidth = (geo.size.width - gap) * 0.6

            HStack(spacing: gap) {

                // ── Left: rounded leading corners only ──
                LikedSongsLeftTile(songCount: item.songCount)
                    .frame(width: leftWidth, height: cardHeight)
                    .clipShape(leftShape(r))
                    .overlay(leftShape(r).stroke(Color(hex: "3B82F6").opacity(0.25), lineWidth: 1))

                // ── Right: rounded trailing corners only ──
                LikedSongsRightTile(coverURL: latestCoverURL, onPlay: onPlay)
                    .frame(width: rightWidth, height: cardHeight)
                    .clipShape(rightShape(r))
                    .overlay(rightShape(r).stroke(Color(hex: "3B82F6").opacity(0.15), lineWidth: 1))
            }
        }
        .frame(height: cardHeight)
    }

    private func leftShape(_ r: CGFloat) -> UnevenRoundedRectangle {
        UnevenRoundedRectangle(
            topLeadingRadius:     r,
            bottomLeadingRadius:  r,
            bottomTrailingRadius: 0,
            topTrailingRadius:    0
        )
    }

    private func rightShape(_ r: CGFloat) -> UnevenRoundedRectangle {
        UnevenRoundedRectangle(
            topLeadingRadius:     0,
            bottomLeadingRadius:  0,
            bottomTrailingRadius: r,
            topTrailingRadius:    r
        )
    }
}

// ─────────────────────────────────────────────
// MARK: - Left Tile
// ─────────────────────────────────────────────
// Blue gradient + heart icon + song count.

struct LikedSongsLeftTile: View {
    let songCount: Int

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(hex: "0B2555"), Color(hex: "1A4B9C"), Color(hex: "3B82F6")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            VStack(spacing: 6) {
                Image(systemName: "heart.fill")
                    .font(.system(size: 34))
                    .foregroundColor(.white)

                Text("\(songCount) songs")
                    .font(.custom("Jura-Regular", size: 11))
                    .foregroundColor(.white.opacity(0.8))
            }
        }
    }
}

// ─────────────────────────────────────────────
// MARK: - Right Tile
// ─────────────────────────────────────────────
// Latest liked song artwork + gradient overlay + play button.

struct LikedSongsRightTile: View {
    let coverURL: String?
    var onPlay: () -> Void = {}

    var body: some View {
        ZStack {
            // Artwork via shared AlbumCoverImage (handles downsampling + placeholder)
            RightTileLikeCardCoverImage(urlString: coverURL)
                .frame(maxWidth: .infinity)

            // Blue-tinted gradient overlay — matches app theme
            LinearGradient(
                stops: [
                    .init(color: .clear,                                                   location: 0.0),
                    .init(color: Color(red: 0.06, green: 0.08, blue: 0.24).opacity(0.65), location: 0.60),
                    .init(color: Color(red: 0.06, green: 0.26, blue: 0.79).opacity(0.95), location: 1.0)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .allowsHitTesting(false)
        }
        .overlay(alignment: .bottomTrailing) {
            LibraryPlayButton(action: onPlay)
                .padding(.trailing, 16)
                .padding(.bottom, 32)
        }
    }
}