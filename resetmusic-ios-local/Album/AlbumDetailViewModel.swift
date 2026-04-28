//
//  AlbumDetailViewModel.swift
//  resetmusic-ios-local
//
//  Created by Naushad Ali Khan on 07/03/26.
//

import Foundation
import Combine

@MainActor
final class AlbumDetailViewModel: ObservableObject {

    @Published var songs: [Song] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let service: SongServiceProtocol
    private var currentPage = 1
    private var totalPages = 1
    private var isInitialLoadDone = false

    init(service: SongServiceProtocol = SongService()) {
        self.service = service
    }

    func loadSongs(albumId: String) async {
        if isInitialLoadDone { return }
        await fetchSongs(albumId: albumId, page: 1, reset: true)
        isInitialLoadDone = true
    }

    func loadMoreIfNeeded(currentItem: Song, albumId: String) async {
        guard let last = songs.last else { return }
        guard currentItem.id == last.id else { return }
        guard !isLoading, currentPage <= totalPages else { return }
        await fetchSongs(albumId: albumId, page: currentPage)
    }

    private func fetchSongs(albumId: String, page: Int, reset: Bool = false) async {
        guard !isLoading else { return }
        isLoading = true
        errorMessage = nil

        do {
            let response = try await service.fetchSongsByAlbum(albumId: albumId, page: page)
            if reset {
                songs = response.songs    // ← your actual response shape
            } else {
                songs.append(contentsOf: response.songs)
            }
            totalPages = response.pages   // ← your actual response shape
            currentPage = page + 1
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }
}
