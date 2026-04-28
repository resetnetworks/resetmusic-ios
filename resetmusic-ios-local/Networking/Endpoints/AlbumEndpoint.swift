//
//  AlbumEndpoint.swift
//  resetmusic-ios-local
//
//  Created by Naushad Ali Khan on 04/03/26.
//

import Foundation

enum AlbumEndpoint: APIEndpoint {

    case getAll(page: Int)
    case getById(String)
    case getByArtist(artistId: String, page: Int)  // ✅ for ArtistDetailView
    case create(Data)
    case update(id: String, body: Data)

    var path: String {
        switch self {
        case .getAll(let page):
            return "/api/albums?page=\(page)"
        case .getById(let id):
            return "/api/albums/\(id)"
        case .getByArtist(let artistId, let page):
            return "/api/albums/artist/\(artistId)?page=\(page)"
        case .create:
            return "/api/albums"
        case .update(let id, _):
            return "/api/albums/\(id)"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getAll, .getById, .getByArtist:
            return .GET
        case .create:
            return .POST
        case .update:
            return .PATCH
        }
    }

    var body: Data? {
        switch self {
        case .create(let data):
            return data
        case .update(_, let data):
            return data
        default:
            return nil
        }
    }

    var requiresAuth: Bool {
        switch self {
        case .create, .update:
            return true
        default:
            return false
        }
    }
}
