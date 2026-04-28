//
//  PlayerEndpoint.swift
//  resetmusic-ios-local
//
//  Created by Naushad Ali Khan on 14/03/26.
//


import Foundation

enum PlayerEndpoint: APIEndpoint {

    case streamSong(id: String)
    case streamAlbum(id: String)

    var path: String {
        switch self {
        case .streamSong(let id):
            return "/api/stream/song/\(id)"
        case .streamAlbum(let id):
            return "/api/stream/album/\(id)"
        }
    }

    var method: HTTPMethod { .GET }
    var body: Data? { nil }

    // Optional auth — endpoint works without token (30s preview)
    // token is passed separately from KeychainManager
    var requiresAuth: Bool { false }
}
