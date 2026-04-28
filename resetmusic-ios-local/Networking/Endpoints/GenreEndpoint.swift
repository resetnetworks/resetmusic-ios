//
//  GenreEndpoint.swift
//  resetmusic-ios-local
//
//  Created by resetstudio01  on 21/04/26.
//

import Foundation

enum GenreEndpoint: APIEndpoint {

    case getBySlug(String, page: Int, limit: Int)

    var path: String {
        switch self {
        case .getBySlug(let slug, let page, let limit):
            return "/api/songs/genre/\(slug)?page=\(page)&limit=\(limit)"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getBySlug:
            return .GET
        }
    }

    var body: Data? { nil }

    var requiresAuth: Bool { false }
}
