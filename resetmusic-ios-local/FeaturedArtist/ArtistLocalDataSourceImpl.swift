//
//  ArtistLocalDataSourceImpl.swift
//  resetmusic-ios-local
//
//  Created by Codex on 24/04/26.
//

import Foundation

final class ArtistLocalDataSourceImpl: ArtistLocalDataSource {
    private let fileManager: FileManager
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder
    private let fileName = "artists_cache.json"

    init(
        fileManager: FileManager = .default,
        encoder: JSONEncoder = JSONEncoder(),
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.fileManager = fileManager
        self.encoder = encoder
        self.decoder = decoder
    }

    func loadArtists() async -> [FeaturedArtist] {
        guard let fileURL = cacheFileURL(),
              fileManager.fileExists(atPath: fileURL.path) else {
            return []
        }

        do {
            let data = try Data(contentsOf: fileURL)
            return try decoder.decode([FeaturedArtist].self, from: data)
        } catch {
            return []
        }
    }

    func saveArtists(_ artists: [FeaturedArtist]) async {
        guard let fileURL = cacheFileURL() else { return }

        do {
            let data = try encoder.encode(artists)
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
