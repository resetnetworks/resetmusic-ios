//
//  SearchEndpoint.swift
//  resetmusic-ios-local
//

import Foundation

enum SearchEndpoint: APIEndpoint {

    case search(query: String)
    case searchArtists(query: String, page: Int, limit: Int)

    var path: String {
        switch self {
        case .search(let query):
            let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
            return "/api/search?q=\(encodedQuery)"
        case .searchArtists(let query, let page, let limit):
            let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
            return "/api/search/artists?q=\(encodedQuery)&page=\(page)&limit=\(limit)"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .search, .searchArtists:
            return .GET
        }
    }

    var body: Data? { nil }

    var requiresAuth: Bool { false }
}
