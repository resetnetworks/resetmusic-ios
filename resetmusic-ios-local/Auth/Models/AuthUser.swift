//
//  AuthUser.swift
//  resetmusic-ios-local
//
//  Created by Codex on 06/05/26.
//

import Foundation

struct AuthUser: Codable, Identifiable {
    let id: String
    let name: String
    let email: String
    let profileImage: String?
    let authType: String?
    let role: String
    let preferredGenres: [String]
    let likedSongIDs: [String]
    let purchasedSongIDs: [String]
    let purchasedAlbumIDs: [String]
    let playlistIDs: [String]
    let purchaseHistoryIDs: [String]
    let subscribedArtistIDs: [String]
    let createdAt: String
    let updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case legacyID = "_id"
        case name
        case email
        case profileImage
        case authType
        case role
        case preferredGenres
        case likedSongIDs = "likedsong"
        case purchasedSongIDs = "purchasedSongs"
        case purchasedAlbumIDs = "purchasedAlbums"
        case playlistIDs = "playlist"
        case purchaseHistoryIDs = "purchaseHistory"
        case subscribedArtistIDs = "subscribedArtists"
        case createdAt
        case updatedAt
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(String.self, forKey: .id)
            ?? container.decode(String.self, forKey: .legacyID)
        name = try container.decode(String.self, forKey: .name)
        email = try container.decode(String.self, forKey: .email)
        profileImage = try container.decodeIfPresent(String.self, forKey: .profileImage)
        authType = try container.decodeIfPresent(String.self, forKey: .authType)
        role = try container.decode(String.self, forKey: .role)
        preferredGenres = try container.decodeIfPresent([String].self, forKey: .preferredGenres) ?? []
        likedSongIDs = try container.decodeIfPresent([String].self, forKey: .likedSongIDs) ?? []
        purchasedSongIDs = try container.decodeIfPresent([String].self, forKey: .purchasedSongIDs) ?? []
        purchasedAlbumIDs = try container.decodeIfPresent([String].self, forKey: .purchasedAlbumIDs) ?? []
        playlistIDs = try container.decodeIfPresent([String].self, forKey: .playlistIDs) ?? []
        purchaseHistoryIDs = try container.decodeIfPresent([String].self, forKey: .purchaseHistoryIDs) ?? []
        subscribedArtistIDs = try container.decodeIfPresent([String].self, forKey: .subscribedArtistIDs) ?? []
        createdAt = try container.decode(String.self, forKey: .createdAt)
        updatedAt = try container.decode(String.self, forKey: .updatedAt)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .legacyID)
        try container.encode(name, forKey: .name)
        try container.encode(email, forKey: .email)
        try container.encodeIfPresent(profileImage, forKey: .profileImage)
        try container.encodeIfPresent(authType, forKey: .authType)
        try container.encode(role, forKey: .role)
        try container.encode(preferredGenres, forKey: .preferredGenres)
        try container.encode(likedSongIDs, forKey: .likedSongIDs)
        try container.encode(purchasedSongIDs, forKey: .purchasedSongIDs)
        try container.encode(purchasedAlbumIDs, forKey: .purchasedAlbumIDs)
        try container.encode(playlistIDs, forKey: .playlistIDs)
        try container.encode(purchaseHistoryIDs, forKey: .purchaseHistoryIDs)
        try container.encode(subscribedArtistIDs, forKey: .subscribedArtistIDs)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(updatedAt, forKey: .updatedAt)
    }
}
