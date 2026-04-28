//
//  Artist.swift
//  resetmusic-ios-local
//
//  Created by Naushad Ali Khan on 04/03/26.
//


import Foundation

struct Artist: Codable, Hashable {
    let id: String?       // optional — not present in artist-albums endpoint
    let name: String
    let slug: String

    enum CodingKeys: String, CodingKey {
        case id
        case legacyId = "_id"
        case name, slug
    }

    init(id: String?, name: String, slug: String) {
        self.id = id
        self.name = name
        self.slug = slug
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(String.self, forKey: .id)
            ?? container.decodeIfPresent(String.self, forKey: .legacyId)
        name = try container.decode(String.self, forKey: .name)
        slug = try container.decode(String.self, forKey: .slug)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(id, forKey: .legacyId)
        try container.encode(name, forKey: .name)
        try container.encode(slug, forKey: .slug)
    }
}
