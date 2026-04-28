//
//  StreamResponse.swift
//  resetmusic-ios-local
//
//  Created by Naushad Ali Khan on 14/03/26.
//


import Foundation

// MARK: - Song Stream Response
// GET /stream/song/:id
// No token or no access → isPreview: true (30s preview URL)
// Token + subscribed   → isPreview: false (signed full URL)

struct SongStreamResponse: Codable {
    let url: String
    let uuid: String
    let isPreview: Bool
}

// MARK: - Album Stream Response
// GET /stream/album/:id
// Requires auth always
// Returns array of signed URLs — one per song in the album

struct AlbumStreamResponse: Codable {
    let urls: [String]
}















































