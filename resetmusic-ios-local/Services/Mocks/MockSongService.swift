//
//  MockSongService.swift
//  resetmusic-ios-local
//
//  Created by Naushad Ali Khan on 13/03/26.
//


import Foundation

final class MockSongService: SongServiceProtocol {

    func fetchSongsByAlbum(albumId: String, page: Int) async throws -> SongResponse {
        SongResponse(
            success: true,
            album: SongResponseAlbum(
                id: albumId,
                title: "enigmata",
                slug: "enigmata",
                coverImage: "https://d3tp8cbw5vz2ok.cloudfront.net/covers/11de53a6-975f-45b7-b713-0675b34f6375.jpg"
            ),
            songs: [
                mockSong(id: "mock-song-1", title: "Track 01", trackNumber: 1, accessType: "free"),
                mockSong(id: "mock-song-2", title: "Track 02", trackNumber: 2, accessType: "paid")
            ],
            total: 2,
            page: 1,
            pages: 1
        )
    }

    private func mockSong(id: String, title: String, trackNumber: Int, accessType: String) -> Song {
        Song(
            id: id,
            title: title,
            slug: title.lowercased().replacingOccurrences(of: " ", with: "-"),
            duration: 214.0,
            genre: ["Electronic"],
            releaseDate: nil,
            coverImage: nil,
            accessType: accessType,
            albumOnly: false,
            copyright: nil,  // 👈 was <#String?#>
            hlsReady: false,
            artist: SongArtist(id: "mock-artist-1", name: "Nariel", slug: "nariel"),
            album: SongAlbum(id: "mock-album-1", title: "enigmata", slug: "enigmata"),
            basePrice: nil,
            convertedPrices: [],
            audioUrl: nil
        )
    }}
