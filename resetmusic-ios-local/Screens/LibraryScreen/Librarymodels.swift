//
//  Librarymodels.swift
//  resetmusic-ios-local
//
//  Created by Naushad Ali Khan on 06/04/26.
//

import SwiftUI

// MARK: - Liked Songs

struct LikedSongsItem {
    let songCount: Int
    // Pass the latest liked song's cover URL from API response
    var latestCoverURL: String? = nil
}

// MARK: - Favorite Artist

struct FavoriteArtist: Identifiable {
    let id: UUID
    let name: String
    let imageURL: String?
    var isLiked: Bool

    init(id: UUID = UUID(), name: String, imageURL: String? = nil, isLiked: Bool = true) {
        self.id = id
        self.name = name
        self.imageURL = imageURL
        self.isLiked = isLiked
    }
}

// MARK: - Playlist

struct UserPlaylist: Identifiable {
    let id: UUID
    let title: String
    let songCount: Int
    let coverEmoji: String
    var isLiked: Bool
    let coverURL: String? = nil

    init(id: UUID = UUID(), title: String, songCount: Int, coverEmoji: String, isLiked: Bool = false) {
        self.id = id
        self.title = title
        self.songCount = songCount
        self.coverEmoji = coverEmoji
        self.isLiked = isLiked
    }
}

// MARK: - Mock Data

extension FavoriteArtist {
    static let mockList: [FavoriteArtist] = [
        FavoriteArtist(
            name: "Akira Film Script",
            // Real CDN image from your existing FeaturedArtistCard preview
            imageURL: "https://d3tp8cbw5vz2ok.cloudfront.net/artist/56ced079-fede-4a1f-b309-82011918b69e.webp",
            isLiked: true
        ),
        FavoriteArtist(
            name: "Nariel",
            imageURL: "https://d3tp8cbw5vz2ok.cloudfront.net/artist/e00ad410-a4a9-4095-a9c0-8a44d87f19c9.jpg",
            isLiked: true
        ),
        FavoriteArtist(
            name: "Giadar",
            imageURL: "https://d3tp8cbw5vz2ok.cloudfront.net/artist/3c4548f3-6a98-4fcc-bb47-1803d9ffe454.webp",
            isLiked: true
        )
    ]
}

extension FavoriteArtist {
    /// Mock subscribed artists — replace with API response when ready
    static let mockSubscribed: [FavoriteArtist] = [
        FavoriteArtist(
            name: "Nariel",
            imageURL: "https://d3tp8cbw5vz2ok.cloudfront.net/artist/e00ad410-a4a9-4095-a9c0-8a44d87f19c9.jpg",
            isLiked: true
        ),
        FavoriteArtist(
            name: "Giadar",
            imageURL: "https://d3tp8cbw5vz2ok.cloudfront.net/artist/3c4548f3-6a98-4fcc-bb47-1803d9ffe454.webp",
            isLiked: true
        )
    ]
}

extension UserPlaylist {
    static let mockList: [UserPlaylist] = [
        UserPlaylist(title: "Late Night Vibes", songCount: 32, coverEmoji: "🌙", isLiked: true),
        UserPlaylist(title: "Morning Energy",   songCount: 18, coverEmoji: "☀️", isLiked: false),
        UserPlaylist(title: "Chill Focus",      songCount: 44, coverEmoji: "🎧", isLiked: false)
    ]
}

