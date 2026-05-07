//
//  MockAlbumService.swift
//  resetmusic-ios-local
//
//  Created by Naushad Ali Khan on 13/03/26.
//


import Foundation

final class MockAlbumService: AlbumServiceProtocol {

    func fetchAlbums(page: Int) async throws -> AlbumResponse {
        AlbumResponse(
            success: true,
            data: [mockAlbum(id: "mock-album-1", title: "enigmata")],
            pagination: Pagination(total: 1, page: 1, limit: 10, totalPages: 1)
        )
    }

    func fetchAlbumsByArtist(artistId: String, page: Int) async throws -> ArtistAlbumsResponse {
        ArtistAlbumsResponse(
            success: true,
            albums: [
                mockAlbum(id: "mock-album-1", title: "enigmata"),
                mockAlbum(id: "mock-album-2", title: "carbon FM")
            ],
            pagination: Pagination(total: 2, page: 1, limit: 10, totalPages: 1)
        )
    }

    func fetchAlbum(id: String) async throws -> Album {
        mockAlbum(id: id, title: "enigmata")
    }

    private func mockAlbum(id: String, title: String) -> Album {
        Album(
            id: id,
            title: title,
            slug: title.lowercased().replacingOccurrences(of: " ", with: "-"),
            coverImage: "https://d3tp8cbw5vz2ok.cloudfront.net/covers/11de53a6-975f-45b7-b713-0675b34f6375.jpg",
            description: "Mock album description",
            releaseDate: nil,
            genre: ["Electronic"],
            accessType: "free",
            basePrice: nil,
            convertedPrices: [],
            artist: Artist(id: "mock-artist-1", name: "Nariel", slug: "nariel"),
            createdAt: nil,
            updatedAt: nil
        )
    }
}
