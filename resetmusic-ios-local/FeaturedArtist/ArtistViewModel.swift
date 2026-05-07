//
//  ArtistViewModel.swift
//  resetmusic-ios-local
//
//  Created by Naushad Ali Khan on 06/03/26.
//


import SwiftUI
import Combine

@MainActor
final class ArtistViewModel: ObservableObject {

    @Published var artists: [FeaturedArtist] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let repository: ArtistRepository
    private let service: ArtistServiceProtocol
    private var cacheRefreshObserver: AnyCancellable?
    private var currentPage = 1
    private var hasMorePages = true
    private var latestQuery = ""
    private var lastFailedPage: Int?

    init(
        repository: ArtistRepository? = nil,
        service: ArtistServiceProtocol = ArtistService()
    ) {
        self.repository = repository ?? ArtistViewModel.makeDefaultRepository(service: service)
        self.service = service
        observeArtistCacheRefresh()
    }

    func loadArtists(reset: Bool = false) async {
        guard !isLoading || reset else { return }

        latestQuery = ""

        if reset {
            currentPage = 1
            hasMorePages = true
            artists = []
            lastFailedPage = nil
        }

        guard hasMorePages, currentPage != lastFailedPage else { return }

        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            let fetchedArtists = try await repository.getArtists(page: currentPage)
            guard latestQuery.isEmpty else { return }
            lastFailedPage = nil

            if fetchedArtists.isEmpty {
                hasMorePages = false
            } else if currentPage == 1 {
                artists = fetchedArtists
                currentPage += 1
            } else {
                let existingIDs = Set(artists.map(\.id))
                let newArtists = fetchedArtists.filter { !existingIDs.contains($0.id) }

                if newArtists.isEmpty {
                    hasMorePages = false
                } else {
                    artists.append(contentsOf: newArtists)
                    currentPage += 1
                }
            }
        } catch {
            guard latestQuery.isEmpty else { return }
            lastFailedPage = currentPage
            errorMessage = error.localizedDescription
        }
    }

    func searchArtists(query: String) async {
        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        latestQuery = trimmedQuery

        guard !trimmedQuery.isEmpty else {
            await loadArtists(reset: true)
            return
        }

        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            let response = try await service.searchArtists(query: trimmedQuery, page: 1, limit: 10)
            guard latestQuery == trimmedQuery else { return }
            artists = response.results
        } catch {
            guard latestQuery == trimmedQuery else { return }
            artists = []
            errorMessage = error.localizedDescription
        }
    }

    func retryCurrentRequest() async {
        if latestQuery.isEmpty {
            await loadArtists(reset: true)
        } else {
            await searchArtists(query: latestQuery)
        }
    }

    func loadMoreIfNeeded(currentItem: FeaturedArtist) async {
        guard let last = artists.last else { return }
        if currentItem.id == last.id && hasMorePages {
            await loadArtists()
        }
    }

    private func observeArtistCacheRefresh() {
        cacheRefreshObserver = NotificationCenter.default.publisher(for: .artistsCacheDidRefresh)
            .compactMap { $0.object as? [FeaturedArtist] }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] refreshedArtists in
                guard let self, self.latestQuery.isEmpty else { return }
                self.artists = refreshedArtists
                self.hasMorePages = true
                self.lastFailedPage = nil
            }
    }

    private static func makeDefaultRepository(service: ArtistServiceProtocol) -> ArtistRepository {
        ArtistRepositoryImpl(
            service: service,
            localDataSource: ArtistLocalDataSourceImpl()
        )
    }
}
