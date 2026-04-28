//
//  QueueSheetView.swift
//  resetmusic-ios-local
//
//  Created by Naushad Ali Khan on 13/04/26.
//

import SwiftUI
import Kingfisher

struct QueueSheetView: View {
    @EnvironmentObject var playerVM: PlayerViewModel
    @State private var appeared = false
    
    @State private var selectedTrack: PlayerTrack? = nil 

    var body: some View {
        ZStack {

            // 🔥 Background
            LinearGradient(
                stops: [
                    .init(color: Color(hex: "000000"), location: 0.0),
                    .init(color: Color(hex: "011639"), location: 1.0)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .overlay(
                LinearGradient(
                    colors: [
                        Color(red: 0.2, green: 0.5, blue: 1.0).opacity(0.25),
                        Color.clear
                    ],
                    startPoint: .top,
                    endPoint: .center
                )
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {

                // MARK: - Header
                HStack {
                    Text("Queue")
                        .font(.custom("Jura-Bold", size: 22))
                        .foregroundColor(.white)

                    Spacer()

                    Text("\(playerVM.queue.count) Songs")
                        .font(.custom("Jura-Regular", size: 13))
                        .foregroundColor(.white.opacity(0.5))
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)

                // MARK: - Queue List
                ScrollView {
                    VStack(spacing: 0) {
                        ForEach(playerVM.queue, id: \.songId) { track in

                            QueueTrackRow(
                                track: track,
                                isCurrentTrack: track.songId == playerVM.currentTrack?.songId,
                                isPlaying: playerVM.isPlaying,
                                onPlay: {
                                playerVM.playQueueTrack(track)
                                }
                            )
                        }
                    }
                }
                .padding(.top, 10)

                // MARK: - Bottom Button
                Button {
                    playerVM.toggleQueuePlayback()
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: playerVM.isPlaying ? "pause.fill" : "play.fill")

                        Text(playerVM.isPlaying ? "Pause Queue" : "Play Queue")
                            .font(.custom("Jura-SemiBold", size: 14))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Color(red: 0.2, green: 0.5, blue: 1.0)) // ✅ same blue
                    .clipShape(RoundedRectangle(cornerRadius: 12))      // ✅ same shape
                }
                .buttonStyle(.plain)
                .padding(.horizontal, 28)
                .padding(.vertical, 12)
            }
        }
        
        .sheet(item: $selectedTrack) { track in
            PlayerMoreSheetView(track: track)
                .environmentObject(playerVM)
                .presentationDetents([.medium, .large])
        }

    }
}

#Preview {
    QueueSheetView()
        .environmentObject({
            let vm = PlayerViewModel()

            // Mock Queue Data
            vm.queue = [
                PlayerTrack(
                    title: "Blinding Lights",
                    artistName: "The Weeknd",
                    artistId: "1",
                    coverImage: "https://i.scdn.co/image/ab67616d0000b273e3c79c77e2c1d7b5a0c9e4d0",
                    duration: 200,
                    songId: "1"
                ),
                PlayerTrack(
                    title: "Starboy",
                    artistName: "The Weeknd",
                    artistId: "2",
                    coverImage: "https://i.scdn.co/image/ab67616d0000b2734718e2b124b2c2c2b1766fa0",
                    duration: 230,
                    isPreview: true,   // ✅ preview badge test
                    songId: "2"
                ),
                PlayerTrack(
                    title: "Save Your Tears",
                    artistName: "The Weeknd",
                    artistId: "3",
                    coverImage: "https://i.scdn.co/image/ab67616d0000b2738c7f9d9f7a1fcb4b9ac898b1",
                    duration: 215,
                    songId: "3"
                )
            ]

            // Current Playing Track
            vm.currentTrack = vm.queue[1]
            vm.isPlaying = true

            return vm
        }())
}
