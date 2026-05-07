//
//  Album.swift
//  resetmusic-ios-local
//
//  Created by Naushad Ali Khan on 04/03/26.
//
import Foundation

struct Album: Codable, Identifiable, Hashable {
    let id: String
    let title: String
    let slug: String
    let coverImage: String?
    let description: String?
    let releaseDate: String?
    let genre: [String]
    let accessType: String
    let basePrice: Price?
    let convertedPrices: [Price]
    let artist: Artist
    let createdAt: String?
    let updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case legacyId = "_id"
        case title, slug, coverImage, description
        case releaseDate, genre, accessType
        case basePrice, convertedPrices
        case artist, createdAt, updatedAt
    }

    init(
        id: String,
        title: String,
        slug: String,
        coverImage: String?,
        description: String?,
        releaseDate: String?,
        genre: [String],
        accessType: String,
        basePrice: Price?,
        convertedPrices: [Price],
        artist: Artist,
        createdAt: String?,
        updatedAt: String?
    ) {
        self.id = id
        self.title = title
        self.slug = slug
        self.coverImage = coverImage
        self.description = description
        self.releaseDate = releaseDate
        self.genre = genre
        self.accessType = accessType
        self.basePrice = basePrice
        self.convertedPrices = convertedPrices
        self.artist = artist
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(String.self, forKey: .id)
            ?? container.decode(String.self, forKey: .legacyId)
        title = try container.decode(String.self, forKey: .title)
        slug = try container.decode(String.self, forKey: .slug)
        coverImage = try container.decodeIfPresent(String.self, forKey: .coverImage)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        releaseDate = try container.decodeIfPresent(String.self, forKey: .releaseDate)
        genre = try container.decodeIfPresent([String].self, forKey: .genre) ?? []
        accessType = try container.decodeIfPresent(String.self, forKey: .accessType) ?? "free"
        basePrice = try container.decodeIfPresent(Price.self, forKey: .basePrice)
        convertedPrices = try container.decodeIfPresent([Price].self, forKey: .convertedPrices) ?? []
        artist = try container.decode(Artist.self, forKey: .artist)
        createdAt = try container.decodeIfPresent(String.self, forKey: .createdAt)
        updatedAt = try container.decodeIfPresent(String.self, forKey: .updatedAt)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .legacyId)
        try container.encode(title, forKey: .title)
        try container.encode(slug, forKey: .slug)
        try container.encodeIfPresent(coverImage, forKey: .coverImage)
        try container.encodeIfPresent(description, forKey: .description)
        try container.encodeIfPresent(releaseDate, forKey: .releaseDate)
        try container.encode(genre, forKey: .genre)
        try container.encode(accessType, forKey: .accessType)
        try container.encodeIfPresent(basePrice, forKey: .basePrice)
        try container.encode(convertedPrices, forKey: .convertedPrices)
        try container.encode(artist, forKey: .artist)
        try container.encodeIfPresent(createdAt, forKey: .createdAt)
        try container.encodeIfPresent(updatedAt, forKey: .updatedAt)
    }

    static func == (lhs: Album, rhs: Album) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}

// MARK: - Album Response

struct AlbumResponse: Codable {
    let success: Bool
    let data: [Album]
    let pagination: Pagination
}

extension AlbumResponse {
    func toAlbums() -> [Album] {
        data
    }
}

struct AlbumDetailResponse: Codable {
    let success: Bool
    let data: Album
}
