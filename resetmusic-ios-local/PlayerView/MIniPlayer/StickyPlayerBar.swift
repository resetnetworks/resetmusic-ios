//
//  StickyPlayerBar.swift
//  resetmusic-ios-local
//
//  Created by Naushad Ali Khan on 13/03/26.
//


import SwiftUI
import Combine

// MARK: - Models

struct PlayerTrack: Identifiable,Equatable {

    var id: String { songId }
    
    let title: String
    let artistName: String
    var artistId: String
    let coverImage: String
    
    var duration: Int = 0   // ✅ FIX HERE (default value)

    var isLocked: Bool = false
    var isPreview: Bool = false
    var songId: String = ""
    var artist: FeaturedArtist? = nil

    var formattedDuration: String {
        guard duration > 0 else { return "--:--" }
        let minutes = duration / 60
        let seconds = duration % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}
// MARK: - StickyPlayerBar

struct StickyPlayerBar: View {
    @Binding var isFullPlayerPresented: Bool
    @EnvironmentObject var playerVM: PlayerViewModel

    var body: some View {
        VStack(spacing: 0) {
            PlayerProgressBar(progress: playerVM.progress)

            HStack(spacing: 12) {
                PlayerArtwork(
                    url: playerVM.currentTrack?.coverImage ?? "",
                    isPreview: playerVM.currentTrack?.isPreview ?? false
                )
                PlayerTrackInfo(track: playerVM.currentTrack ?? PlayerTrack(
                    title: "No track playing",
                    artistName: "",
                    artistId: "",
                    coverImage: "", duration: 215
                ))

                Spacer()

                PlayerControls(
                    isPlaying: playerVM.isPlaying,
                    onPrevious: { playerVM.skipPrevious() },
                    onPlayPause: { playerVM.togglePlayPause() },
                    onNext: { playerVM.skipNext() }
                )
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 10)
        }
        .background(
            ZStack {
                Color(red: 0.04, green: 0.07, blue: 0.18)
                LinearGradient(
                    colors: [
                        Color(red: 0.08, green: 0.14, blue: 0.32).opacity(0.8),
                        Color(red: 0.03, green: 0.06, blue: 0.16).opacity(0.95)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            }
        )
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.white.opacity(0.07), lineWidth: 1)
        )
        .shadow(color: Color(red: 0.0, green: 0.05, blue: 0.2).opacity(0.6), radius: 16, x: 0, y: 6)
        .onTapGesture {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                isFullPlayerPresented = true
            }
        }
    }
}

#Preview {
    ZStack {
        Color(red: 0.01, green: 0.05, blue: 0.15).ignoresSafeArea()
        VStack {
            Spacer()
            StickyPlayerBar(isFullPlayerPresented: .constant(false))
                .environmentObject({
                    let vm = PlayerViewModel()
                    vm.currentTrack = PlayerTrack(
                        title: "Shifting Layers",
                        artistName: "Nariel",
                        artistId: "",
                        coverImage: "https://d3tp8cbw5vz2ok.cloudfront.net/covers/11de53a6-975f-45b7-b713-0675b34f6375.jpg", duration: 0
                    )
                    vm.isPlaying = true
                    vm.progress = 0.45
                    return vm
                }())
            .padding(.horizontal, 12)
            .padding(.bottom, 20)
        }
    }
}
