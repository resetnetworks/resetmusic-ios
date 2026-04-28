//
//  Playercontrols.swift
//  resetmusic-ios-local
//
//  Created by resetstudio01  on 27/04/26.
//

import SwiftUI

// ─────────────────────────────────────────────
// MARK: - Progress Bar
// ─────────────────────────────────────────────

struct FullPlayerProgressBar: View {
    @ObservedObject var playerVM: PlayerViewModel
    let displayDuration: Double

    private var currentTime: String { formatTime(playerVM.progress * displayDuration) }
    private var endTime: String     { formatTime(displayDuration) }

    var body: some View {
        VStack(spacing: 6) {
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.white.opacity(0.1))
                        .frame(height: 4)

                    Capsule()
                        .fill(Color(red: 0.25, green: 0.55, blue: 1.0))
                        .frame(width: geo.size.width * playerVM.progress, height: 4)
                        .animation(.linear(duration: 0.1), value: playerVM.progress)

                    // HIG: scrubber thumb — 12pt gives comfortable touch target on thin bar
                    Circle()
                        .fill(.white)
                        .frame(width: 12, height: 12)
                        .offset(x: geo.size.width * playerVM.progress - 6)
                        .animation(.linear(duration: 0.1), value: playerVM.progress)
                }
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { playerVM.seek(to: min(max($0.location.x / geo.size.width, 0), 1)) }
                )
            }
            .frame(height: 12)

            HStack {
                Text(currentTime)
                Spacer()
                Text(endTime)
            }
            .font(.custom("Jura-Regular", size: 12))
            .foregroundColor(.white.opacity(0.4))
        }
    }

    private func formatTime(_ seconds: Double) -> String {
        let s = Int(seconds)
        return String(format: "%d:%02d", s / 60, s % 60)
    }
}

// ─────────────────────────────────────────────
// MARK: - Transport Controls
// ─────────────────────────────────────────────

struct FullPlayerControls: View {
    @ObservedObject var playerVM: PlayerViewModel
    let forceRefresh: Bool
    let onPlayPause: () -> Void

    var body: some View {
        HStack(spacing: 0) {
            // Shuffle
            Button(action: { triggerHaptic(); playerVM.toggleShuffle() }) {
                Image(systemName: "shuffle")
                    .font(.system(size: 20))
                    .foregroundColor(playerVM.isShuffleEnabled
                        ? Color(red: 0.3, green: 0.7, blue: 1.0)
                        : .white.opacity(0.4))
                    .frame(maxWidth: .infinity)
                    // HIG: minimum 44pt touch target even for icon-only buttons
                    .frame(minHeight: 44)
            }
            .buttonStyle(.plain)

            // Previous
            Button(action: { triggerHaptic(); playerVM.skipPrevious() }) {
                Image(systemName: "backward.end.fill")
                    .font(.system(size: 22))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(minHeight: 44)
            }
            .buttonStyle(.plain)

            // Play / Pause — HIG: primary action, larger target (64pt)
            Button(action: onPlayPause) {
                ZStack {
                    Circle()
                        .fill(Color(red: 0.25, green: 0.55, blue: 1.0))
                        .frame(width: 64, height: 64)
                        .shadow(color: Color(red: 0.2, green: 0.5, blue: 1.0).opacity(0.4), radius: 12)

                    Image(systemName: playerVM.isPlaying ? "pause.fill" : "play.fill")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(.white)
                        .offset(x: playerVM.isPlaying ? 0 : 0.5)
                        .contentTransition(.symbolEffect(.replace))
                }
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(.plain)
            .id("playPause_\(playerVM.isPlaying)_\(forceRefresh)")

            // Next
            Button(action: { triggerHaptic(); playerVM.skipNext() }) {
                Image(systemName: "forward.end.fill")
                    .font(.system(size: 22))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(minHeight: 44)
            }
            .buttonStyle(.plain)

            // Repeat
            RepeatButton(playerVM: playerVM)
                .frame(maxWidth: .infinity)
                .frame(minHeight: 44)
        }
        .padding(.horizontal, 4)
    }
}

// ─────────────────────────────────────────────
// MARK: - Repeat Button
// ─────────────────────────────────────────────

struct RepeatButton: View {
    @ObservedObject var playerVM: PlayerViewModel

    var body: some View {
        VStack(spacing: 3) {
            Image(systemName: "repeat")
                .font(.system(size: 20))
                .foregroundColor(playerVM.repeatMode == .off
                    ? .white.opacity(0.4)
                    : Color(red: 0.3, green: 0.7, blue: 1.0))

            // Dot indicator for single-song repeat
            Circle()
                .fill(playerVM.repeatMode == .song
                    ? Color(red: 0.3, green: 0.7, blue: 1.0)
                    : .clear)
                .frame(width: 4, height: 4)
        }
        .contentShape(Rectangle())
        .gesture(
            ExclusiveGesture(TapGesture(count: 2), TapGesture(count: 1))
                .onEnded { value in
                    triggerHaptic()
                    switch value {
                    case .first:  playerVM.enableSongRepeat()
                    case .second: playerVM.toggleQueueRepeat()
                    }
                }
        )
    }
}
