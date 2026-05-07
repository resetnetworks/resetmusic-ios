//
//  SkeletonTrackRow.swift
//  resetmusic-ios-local
//
//  Created by resetstudio01  on 04/05/26.
//


import SwiftUI

// ─────────────────────────────────────────────
// MARK: - Skeleton Track Row
// Shared loading placeholder used in GenreDetailView, AlbumDetailView, etc.
// ─────────────────────────────────────────────

struct SkeletonTrackRow: View {
    @State private var phase: CGFloat = 0

    var body: some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 8)
                .fill(shimmerColor)
                .frame(width: 48, height: 48)

            VStack(alignment: .leading, spacing: 6) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(shimmerColor)
                    .frame(width: 160, height: 13)

                RoundedRectangle(cornerRadius: 4)
                    .fill(shimmerColor)
                    .frame(width: 100, height: 11)
            }

            Spacer()

            RoundedRectangle(cornerRadius: 4)
                .fill(shimmerColor)
                .frame(width: 36, height: 11)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
        .onAppear {
            withAnimation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true)) {
                phase = .pi
            }
        }
    }

    private var shimmerColor: Color {
        Color.white.opacity(0.07 + 0.05 * sin(phase))
    }
}