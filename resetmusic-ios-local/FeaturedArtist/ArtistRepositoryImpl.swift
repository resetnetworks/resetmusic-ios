//
//  ArtistRepositoryImpl.swift
//  resetmusic-ios-local
//
//  Created by Codex on 24/04/26.
//

import Foundation

final class ArtistRepositoryImpl: ArtistRepository {
    private let service: ArtistServiceProtocol
    private let localDataSource: ArtistLocalDataSource

    init(
        service: ArtistServiceProtocol,
        localDataSource: ArtistLocalDataSource
    ) {
        self.service = service
        self.localDataSource = localDataSource
    }

    func getArtists(page: Int) async throws -> [FeaturedArtist] {
        if page == 1 {
            let cachedArtists = await localDataSource.loadArtists()

            if !cachedArtists.isEmpty {
                refreshArtistsInBackground(page: page)
                return cachedArtists
            }
        }

        let response = try await service.fetchArtists(page: page)
        let artists = response.toArtists()
        await persist(artists, for: page)
        return artists
    }

    private func refreshArtistsInBackground(page: Int) {
        Task {
            do {
                let response = try await service.fetchArtists(page: page)
                let refreshedArtists = response.toArtists()
                let mergedArtists = await persist(refreshedArtists, for: page)

                await MainActor.run {
                    NotificationCenter.default.post(
                        name: .artistsCacheDidRefresh,
                        object: mergedArtists
                    )
                }
            } catch {
                // Keep cached artists when refresh fails.
            }
        }
    }

    @discardableResult
    private func persist(_ artists: [FeaturedArtist], for page: Int) async -> [FeaturedArtist] {
        let cachedArtists = await localDataSource.loadArtists()
        let artistsToCache: [FeaturedArtist]

        if page == 1 {
            artistsToCache = merge(primary: artists, secondary: cachedArtists)
        } else {
            artistsToCache = merge(primary: cachedArtists, secondary: artists)
        }

        await localDataSource.saveArtists(artistsToCache)
        return artistsToCache
    }

    private func merge(primary: [FeaturedArtist], secondary: [FeaturedArtist]) -> [FeaturedArtist] {
        var seenArtistIDs = Set<String>()
        var mergedArtists: [FeaturedArtist] = []

        for artist in primary + secondary where seenArtistIDs.insert(artist.id).inserted {
            mergedArtists.append(artist)
        }

        return mergedArtists
    }
}
