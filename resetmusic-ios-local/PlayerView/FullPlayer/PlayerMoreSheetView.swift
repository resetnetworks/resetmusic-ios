//
//  PlayerMoreSheetView.swift
//  resetmusic-ios-local
//
//  Created by Naushad Ali Khan on 13/04/26.
//

import SwiftUI
import Kingfisher

struct PlayerMoreSheetView: View {
    @EnvironmentObject var playerVM: PlayerViewModel
    @Environment(\.dismiss) var dismiss
    let track: PlayerTrack?

    init(track: PlayerTrack? = nil) {
        self.track = track
    }

    private var activeTrack: PlayerTrack? {
        track ?? playerVM.currentTrack
    }

    var body: some View {
        ZStack {

            // 🔥 BACKGROUND
            LinearGradient(
                stops: [
                    .init(color: Color(hex: "000000"), location: 0),
                    .init(color: Color(hex: "011639"), location: 1)
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
                Spacer().frame(height: 24)

                // 🎵 HEADER TRACK
                if let track = activeTrack {
                    HStack(spacing: 12) {

                        KFImage(URL(string: track.coverImage))
                            .resizable()
                            .scaledToFill()
                            .frame(width: 56, height: 56)
                            .clipShape(RoundedRectangle(cornerRadius: 10))

                        VStack(alignment: .leading, spacing: 4) {
                            Text(track.title)
                                .font(.custom("Jura-Bold", size: 16))
                                .foregroundColor(.white)

                            Text(track.artistName)
                                .font(.custom("Jura-Regular", size: 13))
                                .foregroundColor(.white.opacity(0.6))
                        }

                        Spacer()
                    }
                    .padding()
                }

                Divider()
                    .background(Color.white.opacity(0.08))

                // 🔥 ACTION LIST
                VStack(spacing: 0) {

                    MoreActionRow(icon: "square.and.arrow.up", title: "Share") {
                        triggerHaptic()
                        shareTrack()
                    }
                    
                    MoreActionRow(icon: "heart", title: "Add to Liked Songs") {
                        dismiss()
                    }
                    

                    MoreActionRow(icon: "text.badge.plus", title: "Add to Queue") {
                        triggerHaptic()
                        addToQueue()
                    }

//                    MoreActionRow(icon: "plus.circle", title: "Create Playlist") {
//                        triggerHaptic()
//                        createPlaylist()
//                    }

                    MoreActionRow(icon: "music.note.list", title: "Add to Playlist") {
                        triggerHaptic()
                        addToPlaylist()
                    }

                    MoreActionRow(icon: "person", title: "View Artist") {
                        triggerHaptic()
                        viewArtist()
                    }

                    MoreActionRow(icon: "sparkles", title: "More like this") {
                        triggerHaptic()
                        viewGenre()
                    }
                }
                .padding(.top, 10)

                Spacer()
            }
        }
    }
}

// MARK: - ACTIONS
extension PlayerMoreSheetView {

    func shareTrack() {
        guard let track = activeTrack else { return }

        let text = "Listening to \(track.title) by \(track.artistName)"
        let av = UIActivityViewController(activityItems: [text], applicationActivities: nil)

        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let root = scene.windows.first?.rootViewController {
            root.present(av, animated: true)
        }

        dismiss()
    }

    func addToQueue() {
        guard let track = activeTrack else { return }

        // ✅ prevent duplicates
        if !playerVM.queue.contains(where: { $0.songId == track.songId }) {
            playerVM.queue.append(track)
        }

        dismiss()
    }

    func createPlaylist() {
        print("Create playlist tapped")
        dismiss()
    }

    func addToPlaylist() {
        print("Add to playlist tapped")
        dismiss()
    }

    func viewArtist() {
        print("Navigate to artist")
        dismiss()
    }

    func viewGenre() {
        print("Navigate to genre")
        dismiss()
    }

    func triggerHaptic() {
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()
    }
}
