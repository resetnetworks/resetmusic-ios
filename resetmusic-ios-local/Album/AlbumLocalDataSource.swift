//
//  AlbumLocalDataSource.swift
//  resetmusic-ios-local
//
//  Created by Codex on 24/04/26.
//

import Foundation

protocol AlbumLocalDataSource {
    func loadAlbums() async -> [Album]
    func saveAlbums(_ albums: [Album]) async
}
