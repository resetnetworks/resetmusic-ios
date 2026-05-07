//
//  AlbumService.swift
//  resetmusic-ios-local
//
//  Created by Naushad Ali Khan on 04/03/26.
//

import Foundation

final class AlbumService: AlbumServiceProtocol {

    func fetchAlbums(page: Int = 1) async throws -> AlbumResponse {
        try await NetworkManager.shared.request(
            AlbumEndpoint.getAll(page: page),
            responseType: AlbumResponse.self
        )
    }

    func fetchAlbumsByArtist(artistId: String, page: Int = 1) async throws -> ArtistAlbumsResponse {
        try await NetworkManager.shared.request(
            AlbumEndpoint.getByArtist(artistId: artistId, page: page),
            responseType: ArtistAlbumsResponse.self
        )
    }

    func fetchAlbum(id: String) async throws -> Album {
        let response = try await NetworkManager.shared.request(
            AlbumEndpoint.getById(id),
            responseType: AlbumDetailResponse.self
        )
        return response.data
    }
}
