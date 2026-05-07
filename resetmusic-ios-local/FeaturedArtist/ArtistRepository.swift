//
//  ArtistRepository.swift
//  resetmusic-ios-local
//
//  Created by Codex on 24/04/26.
//

import Foundation

protocol ArtistRepository {
    func getArtists(page: Int) async throws -> [FeaturedArtist]
}

extension Notification.Name {
    static let artistsCacheDidRefresh = Notification.Name("artistsCacheDidRefresh")
}
