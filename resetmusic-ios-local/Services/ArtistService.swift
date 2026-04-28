//
//  ArtistService.swift
//  resetmusic-ios-local
//
//  Created by Naushad Ali Khan on 06/03/26.
//


import Foundation

final class ArtistService: ArtistServiceProtocol {

    func fetchArtists(page: Int = 1) async throws -> ArtistResponse {
        try await NetworkManager.shared.request(
            ArtistEndpoint.getAll(page: page),
            responseType: ArtistResponse.self
        )
    }

    func searchArtists(query: String, page: Int = 1, limit: Int = 10) async throws -> ArtistSearchResponse {
        try await NetworkManager.shared.request(
            SearchEndpoint.searchArtists(query: query, page: page, limit: limit),
            responseType: ArtistSearchResponse.self
        )
    }
    
    func fetchArtist(id: String) async throws -> FeaturedArtist {
        let response = try await NetworkManager.shared.request(
            ArtistEndpoint.getById(id),  // 👈 matches your enum: case getById(String)
            responseType: ArtistDetailResponse.self
        )
        return response.data
    }
}
