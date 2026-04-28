//
//  ArtistResponse.swift
//  resetmusic-ios-local
//
//  Created by Naushad Ali Khan on 06/03/26.
//


import Foundation

struct ArtistResponse: Codable {
    let success: Bool
    let data: [FeaturedArtist]
    let pagination: Pagination
}

struct ArtistSearchResponse: Codable {
    let success: Bool
    let query: String
    let results: [FeaturedArtist]
    let total: Int
    let page: Int
    let pages: Int
}

struct ArtistDetailResponse: Codable {
    let success: Bool
    let data: FeaturedArtist
}
