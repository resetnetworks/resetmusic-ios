//
//  SongEndpoint.swift
//  resetmusic-ios-local
//
//  Created by Naushad Ali Khan on 07/03/26.
//


import Foundation

enum SongEndpoint: APIEndpoint {

    case getByAlbum(albumId: String, page: Int)
    case getById(String)

    var path: String {
        switch self {
        case .getByAlbum(let albumId, let page):
            return "/api/songs/album/\(albumId)?page=\(page)"
        case .getById(let id):
            return "/api/songs/\(id)"
        }
    }

    var method: HTTPMethod { .GET }
    var body: Data? { nil }
    var requiresAuth: Bool { false }
}