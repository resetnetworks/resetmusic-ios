//
//  MockArtistService.swift
//  resetmusic-ios-local
//
//  Created by Naushad Ali Khan on 13/03/26.
//


import Foundation

final class MockArtistService: ArtistServiceProtocol {

    func fetchArtists(page: Int) async throws -> ArtistResponse {
        ArtistResponse(
            success: true,
            data: [
                mockArtist
            ],
            pagination: Pagination(total: 1, page: 1, limit: 10, totalPages: 1)
        )
    }

    func searchArtists(query: String, page: Int, limit: Int) async throws -> ArtistSearchResponse {
        ArtistSearchResponse(
            success: true,
            query: query,
            results: [mockArtist],
            total: 1,
            page: page,
            pages: 1
        )
    }

    func fetchArtist(id: String) async throws -> FeaturedArtist {
        mockArtist
    }

    private var mockArtist: FeaturedArtist {
        FeaturedArtist(
            id: "mock-artist-1",
            name: "Nariel",
            slug: "nariel-dvr1ug",
            bio: "shifting through the layers of consciousness NARIEL brings new realms within the infinite possibilities of rhythmic sculpture.",
            location: "Naples",
            country: "IT",
            profileImage: "https://d3tp8cbw5vz2ok.cloudfront.net/artist/e00ad410-a4a9-4095-a9c0-8a44d87f19c9.jpg",
            coverImage: "https://d3tp8cbw5vz2ok.cloudfront.net/covers/11de53a6-975f-45b7-b713-0675b34f6375.jpg",
            subscriptionPlans: [
                ArtistSubscriptionPlan(
                    cycle: "3m",
                    basePrice: Price(currency: "USD", amount: 2.99),
                    convertedPrices: []
                )
            ],
            isMonetizationComplete: true,
            songCount: 16,
            albumCount: 3,
            createdAt: "",
            updatedAt: ""
        )
    }
}
