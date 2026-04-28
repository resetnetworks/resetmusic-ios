//
//  PlayerUtilities.swift
//  resetmusic-ios-local
//
//  Created by resetstudio01  on 27/04/26.
//

import SwiftUI

// ─────────────────────────────────────────────
// MARK: - Bottom Bar (Queue / AirPlay / Artist)
// ─────────────────────────────────────────────

struct PlayerBottomBar: View {
    let artistTarget: FeaturedArtist?
    let onQueue: () -> Void
    let onArtist: () -> Void

    var body: some View {
        HStack(spacing: 16) {
            BottomBarButton(icon: "list.bullet", label: "Queue", action: onQueue)

            Spacer()

            AirPlayView()
                .frame(width: 32, height: 32)

            Spacer()

            BottomBarButton(
                icon: "person.fill",
                label: "Artist",
                isDisabled: artistTarget == nil,
                action: onArtist
            )
        }
    }
}

// Shared pill-style button used in the bottom bar
private struct BottomBarButton: View {
    let icon: String
    let label: String
    var isDisabled: Bool = false
    let action: () -> Void

    var body: some View {
        Button(action: { triggerHaptic(); action() }) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .semibold))
                Text(label)
                    .font(.custom("Jura-SemiBold", size: 14))
            }
            .foregroundColor(isDisabled ? .white.opacity(0.3) : .white)
            .padding(.horizontal, 18)
            .padding(.vertical, 12)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 14).fill(Color.blue.opacity(0.2))
                    RoundedRectangle(cornerRadius: 14).fill(.ultraThinMaterial)
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(
                            LinearGradient(
                                colors: [Color.blue.opacity(0.6), Color.white.opacity(0.15)],
                                startPoint: .topLeading, endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                }
            )
            .shadow(color: Color.blue.opacity(0.25), radius: 8, y: 4)
        }
        .buttonStyle(.plain)
        .disabled(isDisabled)
    }
}

// ─────────────────────────────────────────────
// MARK: - Scrolling Track Title
// ─────────────────────────────────────────────

struct ScrollingTrackTitle: View {
    let text: String
    let isPlaying: Bool

    @State private var textWidth: CGFloat = 0
    @State private var containerWidth: CGFloat = 0
    @State private var offset: CGFloat = 0
    @State private var animationID = UUID()

    private let spacing: CGFloat = 36
    private let startPause: Double = 2

    private var shouldScroll: Bool { isPlaying && textWidth > containerWidth && containerWidth > 0 }
    private var scrollDistance: CGFloat { max(textWidth - containerWidth + spacing, 0) }
    private var scrollDuration: Double { max(Double(scrollDistance / 22), 6) }

    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .leading) {
                if shouldScroll {
                    HStack(spacing: spacing) { titleText; titleText }
                        .offset(x: offset)
                } else {
                    titleText.frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .task(id: animationID) { await runMarqueeLoop() }
            .onAppear { containerWidth = proxy.size.width; restartMarquee() }
            .onChange(of: proxy.size.width) { _, v in containerWidth = v; restartMarquee() }
            .onChange(of: text)      { _, _ in restartMarquee() }
            .onChange(of: isPlaying) { _, _ in restartMarquee() }
            .onChange(of: textWidth) { _, _ in restartMarquee() }
            .frame(width: proxy.size.width, alignment: .leading)
            .clipped()
            .mask(
                LinearGradient(
                    stops: [
                        .init(color: .clear, location: 0.0),
                        .init(color: .white, location: 0.02),
                        .init(color: .white, location: 0.84),
                        .init(color: .clear, location: 1.0)
                    ],
                    startPoint: .leading, endPoint: .trailing
                )
            )
        }
        .frame(height: 36)
    }

    private var titleText: some View {
        Text(text)
            .font(.custom("Jura-Bold", size: 26))
            .foregroundColor(.white)
            .lineLimit(1)
            .fixedSize(horizontal: true, vertical: false)
            .background(
                GeometryReader { proxy in
                    Color.clear
                        .onAppear { textWidth = proxy.size.width }
                        .onChange(of: proxy.size.width) { _, v in textWidth = v }
                }
            )
    }

    @MainActor
    private func runMarqueeLoop() async {
        offset = 0
        guard shouldScroll else { return }
        while !Task.isCancelled && shouldScroll {
            try? await Task.sleep(nanoseconds: UInt64(startPause * 1_000_000_000))
            guard !Task.isCancelled, shouldScroll else { return }
            withAnimation(.linear(duration: scrollDuration)) { offset = -scrollDistance }
            try? await Task.sleep(nanoseconds: UInt64(scrollDuration * 1_000_000_000))
            guard !Task.isCancelled else { return }
            offset = 0
        }
    }

    private func restartMarquee() { offset = 0; animationID = UUID() }
}

// ─────────────────────────────────────────────
// MARK: - Utilities
// ─────────────────────────────────────────────

/// Clears the sheet's background so AppBackground shows through
struct ClearBackgroundView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        Task { @MainActor in view.superview?.superview?.backgroundColor = .clear }
        return view
    }
    func updateUIView(_ uiView: UIView, context: Context) {}
}

/// HIG: Medium impact haptic — consistent across all interactive elements
func triggerHaptic() {
    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
}
