//
//  MockPlayerService.swift
//  resetmusic-ios-local
//
//  Created by Naushad Ali Khan on 14/03/26.
//


import Foundation

final class MockPlayerService: PlayerServiceProtocol {

    func fetchSongStream(songId: String, token: String?) async throws -> SongStreamResponse {
        try await Task.sleep(nanoseconds: 500_000_000)
        return SongStreamResponse(
            url: "https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8",
            uuid: "mock-uuid-song",
            isPreview: token == nil
        )
    }

    func fetchAlbumStream(albumId: String, token: String) async throws -> AlbumStreamResponse {
        try await Task.sleep(nanoseconds: 500_000_000)
        return AlbumStreamResponse(urls: [
            "https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8",
            "https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8",
            "https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8"
        ])
    }
}
