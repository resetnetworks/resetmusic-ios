//
//  AppBackground.swift
//  resetmusic-ios-local
//
//  Created by Naushad Ali Khan on 09/03/26.
//
import SwiftUI

/// Reusable background matching the webapp — dark gradient + diagonal streaks + dot pattern
///
/// Industry usage — two patterns:
///
/// 1. As a wrapper (for root/standalone screens):
///    AppBackground { YourView() }
///
/// 2. As a modifier (for screens inside NavigationStack):
///    YourView().appBackground()
///
struct AppBackground<Content: View>: View {

    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        ZStack {
            AppBackgroundLayer()
                .ignoresSafeArea()
            content
        }
    }
}

// MARK: - Standalone background layer (reusable core)

struct AppBackgroundLayer: View {
    var body: some View {
        ZStack {
            // Base gradient: #000000 → #011639
            LinearGradient(
                stops: [
                    .init(color: Color(hex: "000000"), location: 0.0),
                    .init(color: Color(hex: "011639"), location: 1.0)
                ],
                startPoint: .top,
                endPoint: .bottom
            )

            DotPatternOverlay()
        }
        .ignoresSafeArea()
        .allowsHitTesting(false)
    }
}

// MARK: - View Modifier (industry pattern for NavigationStack children)

struct AppBackgroundModifier: ViewModifier {
    func body(content: Content) -> some View {
        ZStack {
            // ✅ Background ignores safe area (fills behind status bar)
            AppBackgroundLayer()
                .ignoresSafeArea()
            // ✅ Content respects safe area (stays below status bar)
            content
        }
    }
}

extension View {
    /// Apply the app background — use this inside NavigationStack screens
    func appBackground() -> some View {
        self.modifier(AppBackgroundModifier())
    }
}



// MARK: - Dot Pattern

private struct DotPatternOverlay: View {
    var body: some View {
        GeometryReader { _ in
            Canvas { context, size in
                let s1: CGFloat = 50, s2: CGFloat = 30, off: CGFloat = 25
                var c = 0
                while CGFloat(c) * s1 < size.width + s1 {
                    var r = 0
                    while CGFloat(r) * s1 < size.height + s1 {
                        context.fill(Path(ellipseIn: CGRect(x: CGFloat(c)*s1-1, y: CGFloat(r)*s1-1, width: 2, height: 2)), with: .color(.white.opacity(0.08)))
                        r += 1
                    }
                    c += 1
                }
                c = 0
                while CGFloat(c) * s2 < size.width + s2 {
                    var r = 0
                    while CGFloat(r) * s2 < size.height + s2 {
                        context.fill(Path(ellipseIn: CGRect(x: CGFloat(c)*s2+off-0.5, y: CGFloat(r)*s2+off-0.5, width: 1, height: 1)), with: .color(.white.opacity(0.04)))
                        r += 1
                    }
                    c += 1
                }
            }
        }
        .blendMode(.overlay)
        .opacity(0.4)
        .allowsHitTesting(false)
    }
}

// MARK: - Hex Color Extension

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r = Double((int >> 16) & 0xFF) / 255
        let g = Double((int >> 8)  & 0xFF) / 255
        let b = Double(int         & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }
}

// MARK: - Preview

#Preview {
    AppBackground {
        VStack {
            Spacer()
            Text("Reset Music")
                .font(.custom("Jura-Bold", size: 32))
                .foregroundColor(.white)
            Spacer()
        }
    }
}
