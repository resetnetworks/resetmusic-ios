//
//  LibraryViewModels.swift
//  resetmusic-ios-local
//
//  Created by Naushad Ali Khan on 06/04/26.
//

import SwiftUI
import Combine

// ─────────────────────────────────────────────
// MARK: - Library ViewModel
// ─────────────────────────────────────────────

@MainActor
final class LibraryViewModel: ObservableObject {

    // MARK: State

    @Published var likedSongs = LikedSongsItem(songCount: 248)
    @Published var artists: [FavoriteArtist]          = FavoriteArtist.mockList       // favourited/wishlisted
    @Published var subscribedArtists: [FavoriteArtist] = FavoriteArtist.mockSubscribed  // paid subscribers
    @Published var playlists: [UserPlaylist]    = UserPlaylist.mockList

    @Published var showCreateSheet = false

    // MARK: Intents

    func toggleArtistLike(id: UUID) {
        guard let idx = artists.firstIndex(where: { $0.id == id }) else { return }
        artists[idx].isLiked.toggle()
    }

    func togglePlaylistLike(id: UUID) {
        guard let idx = playlists.firstIndex(where: { $0.id == id }) else { return }
        playlists[idx].isLiked.toggle()
    }

    func createPlaylist(name: String) {
        let emojis = ["🎸","🎺","🥁","🎷","🎻","🪗","🎙","🎚","🎛"]
        let newPlaylist = UserPlaylist(
            title: name,
            songCount: 0,
            coverEmoji: emojis.randomElement() ?? "🎵",
            isLiked: false
        )
        playlists.insert(newPlaylist, at: 0)
    }

    func deletePlaylist(id: UUID) {
        playlists.removeAll { $0.id == id }
    }
}
