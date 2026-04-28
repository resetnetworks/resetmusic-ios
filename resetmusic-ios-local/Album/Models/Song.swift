//
//  Song.swift
//  resetmusic-ios-local
//
//  Created by Naushad Ali Khan on 07/03/26.
//


import Foundation

// MARK: - Song Model

struct Song: Codable, Identifiable{
    let id: String
    let title: String
    let slug: String
    let duration: Double?
    let genre: [String]
    let releaseDate: String?
    let coverImage: String?
    let accessType: String
    let albumOnly: Bool
    let copyright: String?
    let hlsReady: Bool
    let artist: SongArtist
    let album: SongAlbum?
    let basePrice: Price?
    let convertedPrices: [Price]?
    let audioUrl: String?

    enum CodingKeys: String, CodingKey {
        case id
        case legacyId = "_id"
        case title, slug, duration, genre, releaseDate
        case coverImage, accessType, albumOnly, hlsReady
        case artist, album, basePrice, convertedPrices, audioUrl,copyright
    }

    private enum AudioURLValue: Codable {
        case string(String)
        case array([SearchAudioURLItem])
        case null

        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()

            if let value = try? container.decode(String.self) {
                self = .string(value)
            } else if let value = try? container.decode([SearchAudioURLItem].self) {
                self = .array(value)
            } else if container.decodeNil() {
                self = .null
            } else {
                throw DecodingError.typeMismatch(
                    AudioURLValue.self,
                    DecodingError.Context(
                        codingPath: decoder.codingPath,
                        debugDescription: "Unsupported audioUrl value"
                    )
                )
            }
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()

            switch self {
            case .string(let value):
                try container.encode(value)
            case .array:
                try container.encodeNil()
            case .null:
                try container.encodeNil()
            }
        }
    }

    private struct SearchAudioURLItem: Codable {
        let id: String?

        enum CodingKeys: String, CodingKey {
            case id
            case legacyId = "_id"
        }

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            id = try container.decodeIfPresent(String.self, forKey: .id)
                ?? container.decodeIfPresent(String.self, forKey: .legacyId)
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encodeIfPresent(id, forKey: .legacyId)
        }
    }

    init(
        id: String,
        title: String,
        slug: String,
        duration: Double?,
        genre: [String],
        releaseDate: String?,
        coverImage: String?,
        accessType: String,
        albumOnly: Bool,
        copyright: String?,
        hlsReady: Bool,
        artist: SongArtist,
        album: SongAlbum?,
        basePrice: Price?,
        convertedPrices: [Price]?,
        audioUrl: String?
    ) {
        self.id = id
        self.title = title
        self.slug = slug
        self.duration = duration
        self.genre = genre
        self.releaseDate = releaseDate
        self.coverImage = coverImage
        self.accessType = accessType
        self.albumOnly = albumOnly
        self.copyright = copyright
        self.hlsReady = hlsReady
        self.artist = artist
        self.album = album
        self.basePrice = basePrice
        self.convertedPrices = convertedPrices
        self.audioUrl = audioUrl
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(String.self, forKey: .id)
            ?? container.decode(String.self, forKey: .legacyId)
        title = try container.decode(String.self, forKey: .title)
        slug = try container.decode(String.self, forKey: .slug)
        duration = try container.decodeIfPresent(Double.self, forKey: .duration)
        genre = try container.decodeIfPresent([String].self, forKey: .genre) ?? []
        releaseDate = try container.decodeIfPresent(String.self, forKey: .releaseDate)
        coverImage = try container.decodeIfPresent(String.self, forKey: .coverImage)
        accessType = try container.decodeIfPresent(String.self, forKey: .accessType) ?? "free"
        albumOnly = try container.decodeIfPresent(Bool.self, forKey: .albumOnly) ?? false
        copyright = try container.decodeIfPresent(String.self, forKey: .copyright)
        hlsReady = try container.decodeIfPresent(Bool.self, forKey: .hlsReady) ?? false
        artist = try container.decode(SongArtist.self, forKey: .artist)
        album = try container.decodeIfPresent(SongAlbum.self, forKey: .album)
        basePrice = try container.decodeIfPresent(Price.self, forKey: .basePrice)
        convertedPrices = try container.decodeIfPresent([Price].self, forKey: .convertedPrices)
        if let audioURLValue = try container.decodeIfPresent(AudioURLValue.self, forKey: .audioUrl) {
            switch audioURLValue {
            case .string(let value):
                audioUrl = value
            case .array, .null:
                audioUrl = nil
            }
        } else {
            audioUrl = nil
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .legacyId)
        try container.encode(title, forKey: .title)
        try container.encode(slug, forKey: .slug)
        try container.encodeIfPresent(duration, forKey: .duration)
        try container.encode(genre, forKey: .genre)
        try container.encodeIfPresent(releaseDate, forKey: .releaseDate)
        try container.encodeIfPresent(coverImage, forKey: .coverImage)
        try container.encode(accessType, forKey: .accessType)
        try container.encode(albumOnly, forKey: .albumOnly)
        try container.encodeIfPresent(copyright, forKey: .copyright)
        try container.encode(hlsReady, forKey: .hlsReady)
        try container.encode(artist, forKey: .artist)
        try container.encodeIfPresent(album, forKey: .album)
        try container.encodeIfPresent(basePrice, forKey: .basePrice)
        try container.encodeIfPresent(convertedPrices, forKey: .convertedPrices)
        try container.encodeIfPresent(audioUrl, forKey: .audioUrl)
    }

    /// Formats duration in seconds to "m:ss"
    var formattedDuration: String {
        guard let duration else { return "--:--" }
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}

// MARK: - Nested Models

struct SongArtist: Codable {
    let id: String
    let name: String
    let slug: String?

    enum CodingKeys: String, CodingKey {
        case id
        case legacyId = "_id"
        case name, slug
    }

    init(id: String, name: String, slug: String?) {
        self.id = id
        self.name = name
        self.slug = slug
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(String.self, forKey: .id)
            ?? container.decode(String.self, forKey: .legacyId)
        name = try container.decode(String.self, forKey: .name)
        slug = try container.decodeIfPresent(String.self, forKey: .slug)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .legacyId)
        try container.encode(name, forKey: .name)
        try container.encodeIfPresent(slug, forKey: .slug)
    }
}

struct SongAlbum: Codable {
    let id: String
    let title: String
    let slug: String?

    enum CodingKeys: String, CodingKey {
        case id
        case legacyId = "_id"
        case title, slug
    }

    init(id: String, title: String, slug: String?) {
        self.id = id
        self.title = title
        self.slug = slug
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(String.self, forKey: .id)
            ?? container.decode(String.self, forKey: .legacyId)
        title = try container.decode(String.self, forKey: .title)
        slug = try container.decodeIfPresent(String.self, forKey: .slug)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .legacyId)
        try container.encode(title, forKey: .title)
        try container.encodeIfPresent(slug, forKey: .slug)
    }
}

// MARK: - Song Response

struct SongResponse: Codable {
    let success: Bool
    let album: SongResponseAlbum?
    let songs: [Song]
    let total: Int
    let page: Int
    let pages: Int
}

struct SongResponseAlbum: Codable {
    let id: String
    let title: String
    let slug: String
    let coverImage: String?
}
