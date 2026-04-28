//
//  resetmusic_ios_localApp.swift
//  resetmusic-ios-local
//
//  Created by Naushad Ali Khan on 04/03/26.
//
import SwiftUI

@main
struct resetmusic_ios_localApp: App {

    @StateObject private var playerVM = PlayerViewModel()
    @State private var showSplash = true

    init() {
        print("🚀 APP INITIALIZING")
        AudioSessionManager.shared.configure()
        print("✅ AudioSessionManager configured")

        // ── Prevent white flash between launch screen and first SwiftUI frame ──
        // Matches the launch screen's #000000 background colour
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .forEach { $0.backgroundColor = .black }
    }

    var body: some Scene {
        WindowGroup {
            ZStack {
                // ── Main app ──
                ContentView()
                    .environmentObject(playerVM)
                    .onAppear {
                        AudioSessionManager.shared.playerViewModel = playerVM
                        print("✅ Set playerViewModel in onAppear: \(AudioSessionManager.shared.playerViewModel != nil)")
                    }
                    .preferredColorScheme(.dark)

                // ── Splash — sits on top, dismisses itself ──
                if showSplash {
                    SplashScreenView {
                        withAnimation(.easeOut(duration: 0.3)) {
                            showSplash = false
                        }
                    }
                    .transition(.opacity)
                    .zIndex(1)
                }
            }
            // ── Match window background so no colour mismatch during init ──
            .background(Color.black.ignoresSafeArea())
        }
    }
}
