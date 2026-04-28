//
//  ArtistAlbumViewModel.swift
//  resetmusic-ios-local
//
//  Created by Naushad Ali Khan on 11/03/26.
//


import SwiftUI
import Combine

@MainActor
final class ArtistAlbumViewModel: ObservableObject {

    @Published var albums: [Album] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let service: AlbumServiceProtocol
    private var currentPage = 1
    private var totalPages = 1
    private var artistId: String = ""

    init(service: AlbumServiceProtocol = AlbumService()) {
        self.service = service
    }

    func loadAlbums(for artistId: String) async {
        guard !isLoading else { return }
        self.artistId = artistId
        print("🎨 Loading albums for artistId: \(artistId)")
        isLoading = true
        errorMessage = nil

        do {
            let response = try await service.fetchAlbumsByArtist(artistId: artistId, page: currentPage)
            print("🎵 Albums returned: \(response.albums.map { "\($0.title) - \($0.artist.name)" })")
            albums.append(contentsOf: response.albums)
            totalPages = response.pagination.totalPages
            currentPage += 1
        } catch let decodingError as DecodingError {
            print("❌ Decoding error: \(decodingError)")
            errorMessage = decodingError.localizedDescription
        } catch {
            print("❌ Error: \(error.localizedDescription)")
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    func loadMoreIfNeeded(currentItem: Album) async {
        guard let last = albums.last else { return }
        if currentItem.id == last.id && currentPage <= totalPages {
            await loadAlbums(for: artistId)
        }
    }
}
