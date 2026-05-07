//
//  AlbumRepositoryImpl.swift
//  resetmusic-ios-local
//
//  Created by Codex on 24/04/26.
//

import Foundation

final class AlbumRepositoryImpl: AlbumRepository {
    private let service: AlbumServiceProtocol
    private let localDataSource: AlbumLocalDataSource

    init(
        service: AlbumServiceProtocol,
        localDataSource: AlbumLocalDataSource
    ) {
        self.service = service
        self.localDataSource = localDataSource
    }

    func getAlbums(page: Int) async throws -> [Album] {
        // Page 1 prefers cache so the UI can render immediately when offline.
        if page == 1 {
            let cachedAlbums = await localDataSource.loadAlbums()

            if !cachedAlbums.isEmpty {
                refreshAlbumsInBackground(page: page)
                return cachedAlbums
            }
        }

        let response = try await service.fetchAlbums(page: page)
        let albums = response.toAlbums()
        await persist(albums, for: page)
        return albums
    }

    private func refreshAlbumsInBackground(page: Int) {
        Task {
            do {
                let response = try await service.fetchAlbums(page: page)
                let refreshedAlbums = response.toAlbums()
                let mergedAlbums = await persist(refreshedAlbums, for: page)

                await MainActor.run {
                    NotificationCenter.default.post(
                        name: .albumsCacheDidRefresh,
                        object: mergedAlbums
                    )
                }
            } catch {
                // Keep cached data when refresh fails.
            }
        }
    }

    @discardableResult
    private func persist(_ albums: [Album], for page: Int) async -> [Album] {
        let albumsToCache: [Album]

        if page == 1 {
            let cachedAlbums = await localDataSource.loadAlbums()
            albumsToCache = merge(primary: albums, secondary: cachedAlbums)
        } else {
            let cachedAlbums = await localDataSource.loadAlbums()
            albumsToCache = merge(primary: cachedAlbums, secondary: albums)
        }

        await localDataSource.saveAlbums(albumsToCache)
        return albumsToCache
    }

    private func merge(primary: [Album], secondary: [Album]) -> [Album] {
        var seenAlbumIDs = Set<String>()
        var mergedAlbums: [Album] = []

        for album in primary + secondary where seenAlbumIDs.insert(album.id).inserted {
            mergedAlbums.append(album)
        }

        return mergedAlbums
    }
}
