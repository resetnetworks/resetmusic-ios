//
//  FeaturedArtist.swift
//  resetmusic-ios-local
//
//  Created by Naushad Ali Khan on 06/03/26.
//


import Foundation

struct FeaturedArtist: Codable, Identifiable, Hashable {

    let id: String
    let name: String
    let slug: String
    let bio: String?
    let location: String?
    let country: String?
    let profileImage: String?
    let coverImage: String?
    let subscriptionPlans: [ArtistSubscriptionPlan]
    let isMonetizationComplete: Bool
    let songCount: Int
    let albumCount: Int
    let createdAt: String
    let updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case legacyId = "_id"
        case name, slug, bio, location, country
        case profileImage, coverImage
        case subscriptionPlans
        case isMonetizationComplete
        case songCount, albumCount
        case createdAt, updatedAt
    }

    init(
        id: String,
        name: String,
        slug: String,
        bio: String?,
        location: String?,
        country: String?,
        profileImage: String?,
        coverImage: String?,
        subscriptionPlans: [ArtistSubscriptionPlan],
        isMonetizationComplete: Bool,
        songCount: Int,
        albumCount: Int,
        createdAt: String,
        updatedAt: String
    ) {
        self.id = id
        self.name = name
        self.slug = slug
        self.bio = bio
        self.location = location
        self.country = country
        self.profileImage = profileImage
        self.coverImage = coverImage
        self.subscriptionPlans = subscriptionPlans
        self.isMonetizationComplete = isMonetizationComplete
        self.songCount = songCount
        self.albumCount = albumCount
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(String.self, forKey: .id)
            ?? container.decode(String.self, forKey: .legacyId)
        name = try container.decode(String.self, forKey: .name)
        slug = try container.decode(String.self, forKey: .slug)
        bio = try container.decodeIfPresent(String.self, forKey: .bio)
        location = try container.decodeIfPresent(String.self, forKey: .location)
        country = try container.decodeIfPresent(String.self, forKey: .country)
        profileImage = try container.decodeIfPresent(String.self, forKey: .profileImage)
        coverImage = try container.decodeIfPresent(String.self, forKey: .coverImage)
        subscriptionPlans = try container.decodeIfPresent([ArtistSubscriptionPlan].self, forKey: .subscriptionPlans) ?? []
        isMonetizationComplete = try container.decodeIfPresent(Bool.self, forKey: .isMonetizationComplete) ?? false
        songCount = try container.decodeIfPresent(Int.self, forKey: .songCount) ?? 0
        albumCount = try container.decodeIfPresent(Int.self, forKey: .albumCount) ?? 0
        createdAt = try container.decodeIfPresent(String.self, forKey: .createdAt) ?? ""
        updatedAt = try container.decodeIfPresent(String.self, forKey: .updatedAt) ?? ""
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .legacyId)
        try container.encode(name, forKey: .name)
        try container.encode(slug, forKey: .slug)
        try container.encodeIfPresent(bio, forKey: .bio)
        try container.encodeIfPresent(location, forKey: .location)
        try container.encodeIfPresent(country, forKey: .country)
        try container.encodeIfPresent(profileImage, forKey: .profileImage)
        try container.encodeIfPresent(coverImage, forKey: .coverImage)
        try container.encode(subscriptionPlans, forKey: .subscriptionPlans)
        try container.encode(isMonetizationComplete, forKey: .isMonetizationComplete)
        try container.encode(songCount, forKey: .songCount)
        try container.encode(albumCount, forKey: .albumCount)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(updatedAt, forKey: .updatedAt)
    }

    var displayPrice: String {
        guard let plan = subscriptionPlans.first,
              let price = plan.basePrice else { return "Free" }
        let cycleLabel: String
        switch plan.cycle {
        case "1m": cycleLabel = "/ Month"
        case "3m": cycleLabel = "/ 3 Months"
        case "6m": cycleLabel = "/ 6 Months"
        case "1y": cycleLabel = "/ Year"
        default:   cycleLabel = "per \(plan.cycle)"
        }
        return "$\(String(format: "%.2f", price.amount)) \(cycleLabel)"
    }

    // Hashable
    static func == (lhs: FeaturedArtist, rhs: FeaturedArtist) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}

struct ArtistSubscriptionPlan: Codable {
    let cycle: String
    let basePrice: Price?
    let convertedPrices: [Price]

    init(cycle: String, basePrice: Price?, convertedPrices: [Price]) {
        self.cycle = cycle
        self.basePrice = basePrice
        self.convertedPrices = convertedPrices
    }

    enum CodingKeys: String, CodingKey {
        case cycle, basePrice, convertedPrices
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        cycle = try container.decode(String.self, forKey: .cycle)
        basePrice = try container.decodeIfPresent(Price.self, forKey: .basePrice)
        convertedPrices = try container.decodeIfPresent([Price].self, forKey: .convertedPrices) ?? []
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(cycle, forKey: .cycle)
        try container.encodeIfPresent(basePrice, forKey: .basePrice)
        try container.encode(convertedPrices, forKey: .convertedPrices)
    }
}

// 👇 DELETE everything below this line — the extension is the duplicate causing the errors
