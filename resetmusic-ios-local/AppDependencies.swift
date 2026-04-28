//
//  AppDependencies.swift
//  resetmusic-ios-local
//
//  Created by Naushad Ali Khan on 13/03/26.
//


import Foundation
import Combine
/// Single source of truth for all app-level dependencies.
/// Created once in ResetMusicApp and injected as @EnvironmentObject.
final class AppDependencies: ObservableObject {

    let albumService: AlbumServiceProtocol
    let artistService: ArtistServiceProtocol
    let songService: SongServiceProtocol

    // MARK: - Real (Production)

    init(
        albumService: AlbumServiceProtocol = AlbumService(),
        artistService: ArtistServiceProtocol = ArtistService(),
        songService: SongServiceProtocol = SongService()
    ) {
        self.albumService = albumService
        self.artistService = artistService
        self.songService = songService
    }

    // MARK: - Mock (Previews / Tests)

    static var mock: AppDependencies {
        AppDependencies(
            albumService: MockAlbumService(),
            artistService: MockArtistService(),
            songService: MockSongService()
        )
    }
}
