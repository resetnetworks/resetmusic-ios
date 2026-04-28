//
//  SongService.swift
//  resetmusic-ios-local
//
//  Created by Naushad Ali Khan on 07/03/26.
//


import Foundation

final class SongService: SongServiceProtocol {

    func fetchSongsByAlbum(albumId: String, page: Int = 1) async throws -> SongResponse {
        try await NetworkManager.shared.request(
            SongEndpoint.getByAlbum(albumId: albumId, page: page),
            responseType: SongResponse.self
        )
    }
}
