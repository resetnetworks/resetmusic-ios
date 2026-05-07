//
//  ArtistLocalDataSource.swift
//  resetmusic-ios-local
//
//  Created by Codex on 24/04/26.
//

import Foundation

protocol ArtistLocalDataSource {
    func loadArtists() async -> [FeaturedArtist]
    func saveArtists(_ artists: [FeaturedArtist]) async
}
