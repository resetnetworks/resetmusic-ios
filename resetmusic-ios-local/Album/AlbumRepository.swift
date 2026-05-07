//
//  AlbumRepository.swift
//  resetmusic-ios-local
//
//  Created by Codex on 24/04/26.
//

import Foundation

protocol AlbumRepository {
    func getAlbums(page: Int) async throws -> [Album]
}

extension Notification.Name {
    static let albumsCacheDidRefresh = Notification.Name("albumsCacheDidRefresh")
}
