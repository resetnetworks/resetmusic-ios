//
//  ArtistBookmarkBadge.swift
//  resetmusic-ios-local
//
//  Created by Naushad Ali Khan on 10/04/26.
//


import SwiftUI

// ─────────────────────────────────────────────
// MARK: - Artist Bookmark Badge
// ─────────────────────────────────────────────
// Reusable bottom-right bookmark circle.
// Drop onto any artist card via .overlay or ZStack.

struct ArtistBookmarkBadge: View {
    @Binding var isFavourited: Bool

    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.55)) {
                isFavourited.toggle()
            }
        }) {
            ZStack {
                Circle()
                    .fill(Color.black.opacity(0.65))
                    .frame(width: 36, height: 36)

                Image(systemName: isFavourited ? "bookmark.fill" : "bookmark")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(isFavourited ? Color(hex: "3B82F6") : Color.white.opacity(0.5))
                    .scaleEffect(isFavourited ? 1.15 : 1.0)
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        HStack(spacing: 24) {
            // Unfavourited
            ArtistBookmarkBadge(isFavourited: .constant(false))
            // Favourited
            ArtistBookmarkBadge(isFavourited: .constant(true))
        }
    }
}
