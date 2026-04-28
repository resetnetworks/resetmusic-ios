//
//  ArtistEndpoint.swift
//  resetmusic-ios-local
//
//  Created by Naushad Ali Khan on 06/03/26.
//


import Foundation

enum ArtistEndpoint: APIEndpoint {

    case getAll(page: Int)
    case getById(String)

    var path: String {
        switch self {
        case .getAll(let page):
            return "/api/artists?page=\(page)"
        case .getById(let id):
            return "/api/artists/\(id)"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getAll, .getById:
            return .GET
        }
    }

    var body: Data? { nil }

    var requiresAuth: Bool { false }
}