//
//  PlayerNavBar.swift
//  resetmusic-ios-local
//
//  Created by resetstudio01  on 27/04/26.
//


import SwiftUI

// ─────────────────────────────────────────────
// MARK: - Nav Bar
// ─────────────────────────────────────────────

struct PlayerNavBar: View {
    let onDismiss: () -> Void
    let onMore: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            // HIG: drag handle — 44pt wide, visually subtle
            RoundedRectangle(cornerRadius: 3)
                .fill(Color.white.opacity(0.2))
                .frame(width: 44, height: 4)
                .padding(.top, 4)

            HStack {
                // HIG: minimum 44×44pt tap target
                Button(action: { triggerHaptic(); onDismiss() }) {
                    Image(systemName: "chevron.down")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white.opacity(0.7))
                        .frame(width: 44, height: 44)
                }
                .buttonStyle(.plain)

                Spacer()

                Text("Now Playing")
                    .font(.custom("Jura-SemiBold", size: 14))
                    .foregroundColor(.white.opacity(0.5))

                Spacer()

                Button(action: { triggerHaptic(); onMore() }) {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 18, weight: .semibold))
                        .rotationEffect(.degrees(90))
                        .foregroundColor(.white.opacity(0.7))
                        .frame(width: 44, height: 44)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 20)
        }
    }
}

// ─────────────────────────────────────────────
// MARK: - Track Info Row
// ─────────────────────────────────────────────

struct FullPlayerTrackInfo: View {
    let track: PlayerTrack?
    let isPlaying: Bool
    let artistTarget: FeaturedArtist?
//    let onShareTap: () -> Void
    let onArtistTap: () -> Void

    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            VStack(alignment: .leading, spacing: 2) {
                ScrollingTrackTitle(
                    text: track?.title ?? "No track",
                    isPlaying: isPlaying
                )
                .id("track_title_\(track?.songId ?? UUID().uuidString)")

                Button(action: { triggerHaptic(); onArtistTap() }) {
                    Text(track?.artistName ?? "")
                        .font(.custom("Jura-Regular", size: 14))
                        .foregroundColor(.white.opacity(0.6))
                        .lineLimit(1)
                }
                .buttonStyle(.plain)
                .disabled(artistTarget == nil)
            }
            .layoutPriority(1)
            .frame(maxWidth: .infinity, alignment: .leading)

//            HStack(spacing: 12) {
//                PlayerActionButton(icon: "plus") {}
//                PlayerActionButton(icon: "arrowshape.turn.up.right", action: onShareTap)
//            }
        }
        .padding(.top, 28)
        .padding(.horizontal, 28)
    }
}

//private struct PlayerActionButton: View {
//    let icon: String
//    var action: () -> Void = {}
//
//    var body: some View {
//        Button(action: { triggerHaptic(); action() }) {
//            Image(systemName: icon)
//                .font(.system(size: icon == "plus" ? 16 : 14, weight: .semibold))
//                .foregroundColor(.white.opacity(0.85))
//                .frame(width: 40, height: 40)
//                .background(Circle().fill(Color.white.opacity(0.08)))
//                .overlay(Circle().stroke(Color.white.opacity(0.12), lineWidth: 1))
//        }
//        .buttonStyle(.plain)
//    }
//}

// ─────────────────────────────────────────────
// MARK: - Preview Banner
// ─────────────────────────────────────────────

struct PreviewBanner: View {
    let onUpgrade: () -> Void

    var body: some View {
        VStack(spacing: 6) {
            Text("You're listening to a 30s preview")
                .font(.custom("Jura-Regular", size: 13))
                .foregroundColor(.white.opacity(0.5))

            Button(action: { triggerHaptic(); onUpgrade() }) {
                Text("Unlock full experience")
                    .font(.custom("Jura-SemiBold", size: 14))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(LinearGradient(
                                colors: [Color(hex: "0F3272"), Color(hex: "1A5DB4"), Color(hex: "3B82F6")],
                                startPoint: .leading, endPoint: .trailing
                            ))
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 14))
            }
            .buttonStyle(.plain)
            .padding(.horizontal, 28)
        }
    }
}
