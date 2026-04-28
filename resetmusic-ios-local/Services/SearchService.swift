//
//  SearchService.swift
//  resetmusic-ios-local
//
//  Created by Codex on 13/04/26.
//

import Foundation

final class SearchService: SearchServiceProtocol {

    func search(query: String) async throws -> SearchResponse {
        try await NetworkManager.shared.request(
            SearchEndpoint.search(query: query),
            responseType: SearchResponse.self
        )
    }
}
