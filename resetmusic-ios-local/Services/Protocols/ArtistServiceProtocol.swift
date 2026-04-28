//
//  ArtistServiceProtocol.swift
//  resetmusic-ios-local
//
//  Created by Naushad Ali Khan on 13/03/26.
//


import Foundation

protocol ArtistServiceProtocol {
    func fetchArtists(page: Int) async throws -> ArtistResponse
    func searchArtists(query: String, page: Int, limit: Int) async throws -> ArtistSearchResponse
    func fetchArtist(id: String) async throws -> FeaturedArtist
}
