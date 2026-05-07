//
//  WelcomeView.swift
//  resetmusic-ios-local
//
//  Created by Naushad Ali Khan on 09/04/26.
//


import SwiftUI
import Combine

// ─────────────────────────────────────────────
// MARK: - Welcome View
// ─────────────────────────────────────────────
//
// Full-screen hero landing screen shown before login/signup.
// Layout inspired by the reference — full bleed background image,
// large hero text centered vertically, two CTA buttons stacked.
//
// Usage in your app entry point / onboarding coordinator:
//   WelcomeView(
//       onLoginSignUp: { /* show LoginView */ },
//       onBrowseFirst: { /* go to HomeView as guest */ }
//   )

struct WelcomeView: View {

    var onLoginSignUp: () -> Void = {}
    var onBrowseFirst: () -> Void = {}

    // Subtle entrance animation
    @State private var heroVisible   = false
    @State private var buttonsVisible = false
    @State private var currentBgIndex = 0
    @State private var browsePressed = false

    private let bgImages = ["welcome-bg", "welcome-bg-4", "welcome-bg-1"]
    private let bgTimer = Timer.publish(every: 4, on: .main, in: .common).autoconnect()

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .center) {

                // ── 1. Full-bleed background ──────────────────
                backgroundLayer(geo: geo)

                // ── 2. Centered content: hero text + buttons ────
                VStack(spacing: 0) {
                    Spacer()
                        .frame(height: geo.size.height * 0.12)
                    
                    heroText
                        .opacity(heroVisible ? 1 : 0)
                        .offset(y: heroVisible ? 0 : 24)

                    Spacer()
                        .frame(height: 56)

                    buttonStack
                        .opacity(buttonsVisible ? 1 : 0)
                        .offset(y: buttonsVisible ? 0 : 20)

                    Spacer()
                        .frame(height: geo.size.height * 0.08)
                }
                .padding(.horizontal, 24)
            }
            .ignoresSafeArea()
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.7).delay(0.2)) { heroVisible = true }
            withAnimation(.easeOut(duration: 0.6).delay(0.55)) { buttonsVisible = true }
        }
        .onReceive(bgTimer) { _ in
            withAnimation(.easeInOut(duration: 1.2)) {
                currentBgIndex = (currentBgIndex + 1) % bgImages.count
            }
        }
    }

    // ── Background ───────────────────────────────────────────

    @ViewBuilder
    private func backgroundLayer(geo: GeometryProxy) -> some View {
        ZStack {
            // Fallback solid in case image is missing
            Color(red: 0, green: 0.031, blue: 0.063) // #000810
            
            // Cycling background — crossfades every 4 seconds
            ForEach(0..<bgImages.count, id: \.self) { index in
                Image(bgImages[index])
                    .resizable()
                    .scaledToFill()
                    .frame(width: geo.size.width, height: geo.size.height)
                    .clipped()
                    .saturation(0.80)
                    .opacity(index == currentBgIndex ? 1 : 0)
                    .animation(.easeInOut(duration: 1.2), value: currentBgIndex)
                    .ignoresSafeArea()
            }

            // ── Scrim: clear top, strong dark behind headline zone, softer bottom ──
            LinearGradient(
                stops: [
                    .init(color: Color.black.opacity(0.55), location: 0.28),
                    .init(color: Color.black.opacity(0.55), location: 0.42),
                    .init(color: Color.black.opacity(0.55), location: 0.48),
                    .init(color: Color.black.opacity(0.80), location: 0.55),
                    .init(color: Color.black.opacity(0.65), location: 0.72),
                    .init(color: Color(red: 0.024, green: 0.086, blue: 0.224).opacity(0.70), location: 1.0)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        }
    }

    // ── Hero text ────────────────────────────────────────────

    private var heroText: some View {
        VStack(alignment: .leading, spacing: 6) {
            // App name badge - REDUCED SIZE
            HStack(spacing: 8) {
                Image("logo-icon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)

                Text("resetmusic")
                    .font(.custom("Jura-Bold", size: 16))
                    .foregroundColor(Color(red: 0.231, green: 0.51, blue: 0.965))
                    .kerning(1.2)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 7)
            .background(
                Capsule()
                    .fill(Color(red: 0.024, green: 0.086, blue: 0.224).opacity(0.75))
                    .overlay(Capsule().stroke(Color(red: 0.231, green: 0.51, blue: 0.965).opacity(0.6), lineWidth: 1))
            )
            .padding(.bottom, 20)

            // Main headline (replaced deprecated Text concatenation with AttributedString)
            headlineText
                .lineSpacing(2)

            // Subtitle
            Text("discover · subscribe · support artists")
                .font(.custom("Jura-Regular", size: 15))
                .foregroundColor(.white.opacity(0.88))
                .kerning(0.5)
                .padding(.top, 10)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var headlineText: some View {
        let base = "music without\nlimits"
        var attributed = AttributedString(base)

        if let musicRange = attributed.range(of: "music") {
            attributed[musicRange].font = .custom("Jura-Bold", size: 52)
            attributed[musicRange].foregroundColor = .white
        }
        if let withoutRange = attributed.range(of: " without\n") ?? attributed.range(of: " without") {
            // Match the original: regular weight and 85% white
            attributed[withoutRange].font = .custom("Jura-Regular", size: 52)
            attributed[withoutRange].foregroundColor = Color.white.opacity(0.85)
        }
        if let limitsRange = attributed.range(of: "limits") {
            attributed[limitsRange].font = .custom("Jura-Bold", size: 52)
            attributed[limitsRange].foregroundColor = Color(red: 0.231, green: 0.51, blue: 0.965)
        }

        return Text(attributed)
    }

    // ── Button stack ─────────────────────────────────────────

    private var buttonStack: some View {
        VStack(spacing: 14) {
            Button(action: onLoginSignUp) {
                HStack(spacing: 10) {
                    Image(systemName: "person.fill")
                        .font(.system(size: 15, weight: .semibold))
                    Text("log in or sign up")
                        .font(.custom("Jura-Bold", size: 16))
                        .kerning(0.5)
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 54)
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color(red: 0.059, green: 0.196, blue: 0.447),
                                    Color(red: 0.102, green: 0.365, blue: 0.706),
                                    Color(red: 0.231, green: 0.51, blue: 0.965)
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .shadow(color: Color(red: 0.231, green: 0.51, blue: 0.965).opacity(0.3), radius: 12, y: 4)
                )
            }
            .buttonStyle(.plain)

            // Secondary — Browse First
            Button(action: {
                onBrowseFirst()
            }) {
                HStack(spacing: 10) {
                    Image(systemName: "music.note.list")
                        .font(.system(size: 15, weight: .medium))
                    Text("Browse the Catalogue")
                        .font(.custom("Jura-SemiBold", size: 16))
                        .kerning(0.5)
                }
                .foregroundColor(.white.opacity(0.85))
                .frame(maxWidth: .infinity)
                .frame(height: 54)
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .fill(Color.white.opacity(0.06))
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(Color.white.opacity(0.15), lineWidth: 1)
                        )
                )
            }
            .buttonStyle(.plain)
        }
    }
}

// ─────────────────────────────────────────────
// MARK: - Preview
// ─────────────────────────────────────────────

#Preview {
    WelcomeView(
        onLoginSignUp: {},
        onBrowseFirst: {}
    )
}
