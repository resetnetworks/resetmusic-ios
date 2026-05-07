//
//  SearchViewModel.swift
//  resetmusic-ios-local
//
//  Created by Codex on 13/04/26.
//

import Foundation
import Combine

struct SearchResponse: Codable {
    let success: Bool
    let query: String
    let results: SearchResults
}

struct SearchResults: Codable {
    let artists: [FeaturedArtist]
    let songs: [Song]
    let albums: [Album]

    static let empty = SearchResults(artists: [], songs: [], albums: [])
}

@MainActor
final class SearchViewModel: ObservableObject {

    @Published var results: SearchResults = .empty
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var hasSearched = false

    private let service: SearchServiceProtocol
    private var latestQuery = ""

    init(service: SearchServiceProtocol) {
        self.service = service
    }

    convenience init() {
        self.init(service: SearchService())
    }

    func search(query: String) async {
        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        latestQuery = trimmedQuery

        guard !trimmedQuery.isEmpty else {
            results = .empty
            errorMessage = nil
            hasSearched = false
            isLoading = false
            return
        }

        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            let response = try await service.search(query: trimmedQuery)
            guard latestQuery == trimmedQuery else { return }
            results = response.results
            hasSearched = true
        } catch {
            guard latestQuery == trimmedQuery else { return }
            results = .empty
            errorMessage = error.localizedDescription
            hasSearched = true
        }
    }

    func retrySearch() async {
        guard !latestQuery.isEmpty else { return }
        await search(query: latestQuery)
    }
}
