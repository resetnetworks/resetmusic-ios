//
//  PlayerServiceProtocol.swift
//  resetmusic-ios-local
//
//  Created by Naushad Ali Khan on 14/03/26.
//


import Foundation

protocol PlayerServiceProtocol {
    /// No token → 30s preview URL
    /// Token + subscribed → full signed URL
    func fetchSongStream(songId: String, token: String?) async throws -> SongStreamResponse

    /// Always requires token — throws if not subscribed
    func fetchAlbumStream(albumId: String, token: String) async throws -> AlbumStreamResponse
}
