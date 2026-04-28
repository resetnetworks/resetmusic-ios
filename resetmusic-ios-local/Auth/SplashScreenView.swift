//
//  SplashScreenView.swift
//  resetmusic-ios-local
//
//  Created by Naushad Ali Khan on 09/04/26.
//


import SwiftUI

// ─────────────────────────────────────────────
// MARK: - Splash Screen View
// ─────────────────────────────────────────────

struct SplashScreenView: View {

    var onFinished: () -> Void = {}

    // Arc animation
    @State private var arcProgress: CGFloat = 0.3
    @State private var arcOpacity: CGFloat  = 1
    @State private var arcGlow: CGFloat     = 0.9

    // Bar + whole logo
    @State private var barScale: CGFloat    = 0.85
    @State private var logoOpacity: CGFloat = 0
    @State private var scaleOut: CGFloat    = 1
    @State private var rotationAngle: Double = 0

    var body: some View {
        ZStack {
            // ── Background: same as every other screen in the app ──
            AppBackgroundLayer()

            // ── Logo Content ───────────────────────────────────
            ZStack {
                // Glow effect behind arc
                ArcShape(progress: arcProgress)
                    .stroke(
                        Color(red: 0.231, green: 0.51, blue: 0.965).opacity(0.15 * arcGlow),
                        style: StrokeStyle(lineWidth: 8, lineCap: .round, lineJoin: .round)
                    )
                    .frame(width: 94, height: 94)
                    .blur(radius: 5)
                    .opacity(arcOpacity)

                // Vertical bar
                RoundedRectangle(cornerRadius: 4)
                    .fill(
                        LinearGradient(
                            stops: [
                                .init(color: Color(red: 0.231, green: 0.51, blue: 0.965), location: 0.0),
                                .init(color: Color(red: 0.102, green: 0.365, blue: 0.706), location: 0.5),
                                .init(color: Color(red: 0.059, green: 0.196, blue: 0.447), location: 1.0)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: 5, height: 64)
                    .offset(x: 16, y: -30)
                    .scaleEffect(barScale)
                    .shadow(color: Color(red: 0.231, green: 0.51, blue: 0.965).opacity(0.3), radius: 4, y: 1)

                // Arc stroke (main)
                ArcShape(progress: arcProgress)
                    .stroke(
                        LinearGradient(
                            stops: [
                                .init(color: Color.white, location: 0.0),
                                .init(color: Color(red: 0.231, green: 0.51, blue: 0.965), location: 0.3),
                                .init(color: Color(red: 0.102, green: 0.365, blue: 0.706), location: 0.6),
                                .init(color: Color(red: 0.059, green: 0.196, blue: 0.447), location: 1.0)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round)
                    )
                    .frame(width: 86, height: 86)
                    .opacity(arcOpacity)
                    .rotationEffect(.degrees(rotationAngle))
            }
            .scaleEffect(scaleOut)
            .opacity(logoOpacity)
        }
        .ignoresSafeArea()
        .onAppear { runAnimation() }
    }

    // ── Animation sequence ───────────────────────────────────

    private func runAnimation() {
        withAnimation(.spring(response: 0.5, dampingFraction: 0.7, blendDuration: 0)) {
            logoOpacity = 1
            barScale    = 1
        }
        withAnimation(.easeOut(duration: 0.6).delay(0.15)) {
            rotationAngle = 5
        }
        withAnimation(.timingCurve(0.65, 0, 0.35, 1, duration: 0.65).delay(0.2)) {
            arcProgress = 1
            arcGlow     = 1
        }
        withAnimation(.timingCurve(0.65, 0, 0.35, 1, duration: 0.55).delay(0.9)) {
            arcProgress = 0
            arcGlow     = 0
        }
        withAnimation(.easeOut(duration: 0.3).delay(1.15)) {
            rotationAngle = 0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation(.easeInOut(duration: 0.4)) {
                scaleOut    = 1.15
                logoOpacity = 0
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            onFinished()
        }
    }
}

// ─────────────────────────────────────────────
// MARK: - Arc Shape
// ─────────────────────────────────────────────

private struct ArcShape: Shape {
    var progress: CGFloat

    var animatableData: CGFloat {
        get { progress }
        set { progress = newValue }
    }

    func path(in rect: CGRect) -> Path {
        let center     = CGPoint(x: rect.midX, y: rect.midY)
        let radius     = min(rect.width, rect.height) / 2
        let startAngle = Angle.degrees(-55)
        let endAngle   = Angle.degrees(-55 + 330 * Double(progress))
        var path = Path()
        path.addArc(center: center, radius: radius,
                    startAngle: startAngle, endAngle: endAngle, clockwise: false)
        return path
    }
}

// ─────────────────────────────────────────────
// MARK: - Preview
// ─────────────────────────────────────────────

#Preview {
    SplashScreenView()
}
