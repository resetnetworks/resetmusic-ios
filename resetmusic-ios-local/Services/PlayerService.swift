//
//  PlayerService.swift
//  resetmusic-ios-local
//
//  Created by Naushad Ali Khan on 14/03/26.
//

import Foundation

final class PlayerService: PlayerServiceProtocol {

    /// Song stream — token optional
    /// nil token or no subscription access → server returns preview URL automatically
    func fetchSongStream(songId: String, token: String?) async throws -> SongStreamResponse {
        try await NetworkManager.shared.request(
            PlayerEndpoint.streamSong(id: songId),
            responseType: SongStreamResponse.self,
            token: token
        )
    }

    /// Album stream — always requires token
    func fetchAlbumStream(albumId: String, token: String) async throws -> AlbumStreamResponse {
        try await NetworkManager.shared.request(
            PlayerEndpoint.streamAlbum(id: albumId),
            responseType: AlbumStreamResponse.self,
            token: token
        )
    }
}
