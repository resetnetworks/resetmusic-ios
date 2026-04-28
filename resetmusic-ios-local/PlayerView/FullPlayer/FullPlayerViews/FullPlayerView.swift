//
//  FullPlayerView.swift
//  resetmusic-ios-local
//
//  Created by resetstudio01  on 27/04/26.
//


import SwiftUI

// ─────────────────────────────────────────────
// MARK: - Full Player View (Container)
// ─────────────────────────────────────────────

struct FullPlayerView: View {
    @Binding var isPresented: Bool
    @EnvironmentObject var playerVM: PlayerViewModel
    var onNavigateToArtist: ((FeaturedArtist) -> Void)? = nil

    @State private var dragOffset: CGFloat = 0
    @State private var isDragging = false
    @State private var appeared = false
    @State private var forceRefresh = false

    @State private var showUpgradeSheet  = false
    @State private var showQueueSheet    = false
    @State private var showMoreSheet     = false
    @State private var showShareSheet    = false

    // MARK: - Computed helpers

    var displayDuration: Double {
        playerVM.currentTrack?.isPreview == true ? 30.0 : playerVM.duration
    }

    private var artworkScale: CGFloat {
        let drag    = 1.0 - (min(dragOffset / 300, 1.0) * 0.3)
        let appear  = appeared ? 1.0 : 0.6
        return drag * appear
    }

    private var artistTarget: FeaturedArtist? {
        if let artist = playerVM.currentTrack?.artist { return artist }
        guard let t = playerVM.currentTrack, !t.artistId.isEmpty else { return nil }
        return FeaturedArtist(
            id: t.artistId, name: t.artistName, slug: "",
            bio: nil, location: nil, country: nil,
            profileImage: nil, coverImage: nil,
            subscriptionPlans: [], isMonetizationComplete: false,
            songCount: 0, albumCount: 0, createdAt: "", updatedAt: ""
        )
    }

    // MARK: - Body

    var body: some View {
        ZStack {
            // Background
            Color.clear.appBackground().ignoresSafeArea()
            LinearGradient(
                colors: [Color(red: 0.08, green: 0.14, blue: 0.40).opacity(0.5), .clear],
                startPoint: .top, endPoint: .center
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                PlayerNavBar(
                    onDismiss: { withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) { isPresented = false } },
                    onMore: { showMoreSheet = true }
                )

                FullPlayerArtwork(
                    url: playerVM.currentTrack?.coverImage ?? "",
                    isPlaying: playerVM.isPlaying,
                    isPreview: playerVM.currentTrack?.isPreview ?? false
                )
                .scaleEffect(artworkScale)
                .animation(
                    isDragging
                        ? .interactiveSpring()
                        : .spring(response: 0.5, dampingFraction: 0.7),
                    value: artworkScale
                )
                .padding(.top, 32)
                .onAppear { withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) { appeared = true } }
                .onDisappear { appeared = false }

                FullPlayerTrackInfo(
                    track: playerVM.currentTrack,
                    isPlaying: playerVM.isPlaying,
                    artistTarget: artistTarget,
                    onShareTap: { showShareSheet = true },
                    onArtistTap: { navigateToArtist() }
                )

                FullPlayerProgressBar(playerVM: playerVM, displayDuration: displayDuration)
                    .padding(.horizontal, 28)
                    .padding(.top, 24)

                if playerVM.currentTrack?.isPreview == true {
                    PreviewBanner { showUpgradeSheet = true }
                        .padding(.top, 16)
                }

                FullPlayerControls(
                    playerVM: playerVM,
                    forceRefresh: forceRefresh,
                    onPlayPause: {
                        playerVM.togglePlayPause()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) { forceRefresh.toggle() }
                    }
                )
                .padding(.top, 36)

                Spacer()

                PlayerBottomBar(
                    artistTarget: artistTarget,
                    onQueue: { showQueueSheet = true },
                    onArtist: { navigateToArtist() }
                )
                .padding(.horizontal, 28)
                .padding(.bottom, 20)
            }
        }
        .presentationBackground(.clear)
        .background(ClearBackgroundView())
        .offset(y: dragOffset)
        .gesture(dismissDrag)
        .animation(isDragging ? nil : .spring(response: 0.3, dampingFraction: 0.7), value: dragOffset)
        .onDisappear { dragOffset = 0 }
        .onReceive(playerVM.$isPlaying) { _ in forceRefresh.toggle() }
        .onReceive(playerVM.$currentTrack) { _ in forceRefresh.toggle() }
        // Sheets
        .sheet(isPresented: $showUpgradeSheet) {
            UpgradeSheetView()
                .environmentObject(playerVM)
                .presentationDetents([.height(320)])
                .presentationDragIndicator(.visible)
        }
        .sheet(isPresented: $showShareSheet) {
            ShareSheetView()
                .environmentObject(playerVM)
                .presentationDetents([.height(300)])
                .presentationDragIndicator(.visible)
                .presentationBackground(.clear)
        }
        .sheet(isPresented: $showQueueSheet) {
            QueueSheetView()
                .environmentObject(playerVM)
                .presentationDetents(playerVM.queue.count > 1 ? [.medium, .large] : [.height(180)])
                .presentationDragIndicator(.visible)
        }
        .sheet(isPresented: $showMoreSheet) {
            PlayerMoreSheetView()
                .environmentObject(playerVM)
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
                .presentationBackground(.ultraThinMaterial)
        }
    }

    // MARK: - Helpers

    private func navigateToArtist() {
        guard let artist = artistTarget else { return }
        triggerHaptic()
        isPresented = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) { onNavigateToArtist?(artist) }
    }

    private var dismissDrag: some Gesture {
        DragGesture()
            .onChanged { value in
                if value.translation.height > 0 { dragOffset = value.translation.height; isDragging = true }
            }
            .onEnded { value in
                if value.translation.height > 120 || value.predictedEndTranslation.height > 200 {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) { isPresented = false }
                } else {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) { dragOffset = 0 }
                }
                isDragging = false
            }
    }
}
