//
//  Genre.swift
//  resetmusic-ios-local
//
//  Created by resetstudio01  on 21/04/26.
//


import Foundation

struct Genre: Codable, Identifiable, Hashable {
    let id: String
    let name: String
    let slug: String
    let description: String?
    let coverImage: String?
    let songCount: Int?
    let albumCount: Int?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name, slug, description
        case coverImage
        case songCount, albumCount
    }
}

//struct GenreDetailResponse: Codable {
//    let data: Genre
//}

struct GenreDetailResponse: Codable {
    let success: Bool
    let genre: String   // 👈 just a String from API
    let total: Int
    let page: Int
    let pages: Int
    let songs: [Song]
}
