//
//  PlaylistRowCell.swift
//  resetmusic-ios-local
//
//  Created by Naushad Ali Khan on 13/04/26.
//

import SwiftUI

struct PlaylistRowCell: View {
    let playlist: UserPlaylist
    var onTap: () -> Void = {}
    var onMore: () -> Void = {}

    private let gap: CGFloat = 8
    private let r: CGFloat = 12

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: gap) {

                // LEFT TILE → NO radius
                ZStack {
                    LinearGradient(
                        colors: [
                            Color(hex: "060f1e"),
                            Color(hex: "0d2447")
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )

                    Text(playlist.coverEmoji)
                        .font(.system(size: 24))
                }
                .frame(width: 64, height: 64) // 👈 fixed same height
                .overlay(
                    Rectangle()
                        .stroke(Color.white.opacity(0.05), lineWidth: 1)
                )

                // RIGHT TILE → rounded only on right
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(playlist.title)
                            .font(.custom("Jura-Bold", size: 15))
                            .foregroundColor(.white)
                            .lineLimit(1)

                        Text("\(playlist.songCount) songs • playlist")
                            .font(.custom("Jura-Regular", size: 12))
                            .foregroundColor(.white.opacity(0.35))
                    }

                    Spacer()

                    MoreMenuButton(action: onMore)
                }
                .frame(height: 64) // 👈 match left tile height
                .padding(.horizontal, 14)
                .background(
                    UnevenRoundedRectangle(
                        topLeadingRadius: 0,
                        bottomLeadingRadius: 0,
                        bottomTrailingRadius: r,
                        topTrailingRadius: r
                    )
                    .fill(Color.white.opacity(0.04))
                )
                .overlay(
                    UnevenRoundedRectangle(
                        topLeadingRadius: 0,
                        bottomLeadingRadius: 0,
                        bottomTrailingRadius: r,
                        topTrailingRadius: r
                    )
                    .stroke(Color(hex: "3B82F6").opacity(0.12), lineWidth: 1)
                )
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
        }
        .buttonStyle(.plain)
    }
}
