//
//  ArtistDetailViewModel.swift
//  resetmusic-ios-local
//
//  Created by Naushad Ali Khan on 14/04/26.
//


import Foundation
import Combine
@MainActor
class ArtistDetailViewModel: ObservableObject {
    @Published var artist: FeaturedArtist? = nil
    @Published var isLoading = false

    private let service = ArtistService()

    func load(artistId: String) async {
        isLoading = true
        defer { isLoading = false }

        print("🎨 Loading artist with id: \(artistId)")  // 👈 check if id is correct
        
        do {
            let fetched = try await service.fetchArtist(id: artistId)
            self.artist = fetched
            print("✅ Artist loaded: \(fetched.name)")
        } catch {
            print("❌ Failed to load artist: \(error)")  // 👈 this will tell us why
        }
    }
}
