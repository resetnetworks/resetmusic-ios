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

    private let service: ArtistServiceProtocol
    private var currentPage = 1
    private var totalPages = 1
    private var latestQuery = ""

    init(service: ArtistServiceProtocol = ArtistService()) {
        self.service = service
    }

    func loadArtists(reset: Bool = false) async {
        guard !isLoading || reset else { return }

        latestQuery = ""

        if reset {
            currentPage = 1
            totalPages = 1
            artists = []
        }

        isLoading = true
        errorMessage = nil

        do {
            let response = try await service.fetchArtists(page: currentPage)
            guard latestQuery.isEmpty else { return }
            artists.append(contentsOf: response.data)
            totalPages = response.pagination.totalPages
            currentPage += 1
        } catch {
            guard latestQuery.isEmpty else { return }
            errorMessage = error.localizedDescription
        }

        isLoading = false
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

        do {
            let response = try await service.searchArtists(query: trimmedQuery, page: 1, limit: 10)
            guard latestQuery == trimmedQuery else { return }
            artists = response.results
        } catch {
            guard latestQuery == trimmedQuery else { return }
            artists = []
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    func loadMoreIfNeeded(currentItem: FeaturedArtist) async {
        guard let last = artists.last else { return }
        if currentItem.id == last.id && currentPage <= totalPages {
            await loadArtists()
        }
    }
}
