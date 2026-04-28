//
//  ArtistAlbumsResponse.swift
//  resetmusic-ios-local
//
//  Created by Naushad Ali Khan on 11/03/26.
//


import Foundation

struct ArtistAlbumsResponse: Codable {
    let success: Bool
    let albums: [Album]
    let pagination: Pagination
}






























