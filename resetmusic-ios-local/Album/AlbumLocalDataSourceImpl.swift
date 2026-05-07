//
//  AlbumLocalDataSourceImpl.swift
//  resetmusic-ios-local
//
//  Created by Codex on 24/04/26.
//

import Foundation

final class AlbumLocalDataSourceImpl: AlbumLocalDataSource {
    private let fileManager: FileManager
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder
    private let fileName = "albums_cache.json"

    init(
        fileManager: FileManager = .default,
        encoder: JSONEncoder = JSONEncoder(),
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.fileManager = fileManager
        self.encoder = encoder
        self.decoder = decoder
    }

    func loadAlbums() async -> [Album] {
        guard let fileURL = cacheFileURL(),
              fileManager.fileExists(atPath: fileURL.path) else {
            return []
        }

        do {
            let data = try Data(contentsOf: fileURL)
            return try decoder.decode([Album].self, from: data)
        } catch {
            return []
        }
    }

    func saveAlbums(_ albums: [Album]) async {
        guard let fileURL = cacheFileURL() else { return }

        do {
            let data = try encoder.encode(albums)
            try data.write(to: fileURL, options: .atomic)
        } catch {
            return
        }
    }

    private func cacheFileURL() -> URL? {
        fileManager.urls(for: .documentDirectory, in: .userDomainMask)
            .first?
            .appendingPathComponent(fileName)
    }
}
