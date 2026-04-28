//
//  AlbumViewModel.swift
//  resetmusic-ios-local
//
//  Created by Naushad Ali Khan on 07/03/26.
//
import SwiftUI
import Combine

@MainActor
final class AlbumViewModel: ObservableObject {

    @Published var albums: [Album] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let service: AlbumServiceProtocol
    private var currentPage = 1
    private var totalPages = 1

    // Standard init — real service
    init(service: AlbumServiceProtocol = AlbumService()) {
        self.service = service
    }

    // Preview init — pre-loads mock data, skips network
    init(albums: [Album]) {
        self.service = MockAlbumService()
        self.albums = albums
    }

    func loadAlbums() async {
        guard !isLoading else { return }

        isLoading = true
        errorMessage = nil

        do {
            let response = try await service.fetchAlbums(page: currentPage)
            albums.append(contentsOf: response.data)
            totalPages = response.pagination.totalPages
            currentPage += 1
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    func loadMoreIfNeeded(currentItem: Album) async {
        guard let last = albums.last else { return }
        if currentItem.id == last.id && currentPage <= totalPages {
            await loadAlbums()
        }
    }
}
