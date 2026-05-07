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

    @Published var albumDetails: Album?
    @Published var songs: [Song] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let service: SongServiceProtocol
    private let albumService: AlbumServiceProtocol
    private var currentPage = 1
    private var totalPages = 1
    private var isInitialLoadDone = false
    private var loadedAlbumID: String?

    init(
        service: SongServiceProtocol = SongService(),
        albumService: AlbumServiceProtocol = AlbumService()
    ) {
        self.service = service
        self.albumService = albumService
    }

    func load(album: Album) async {
        if loadedAlbumID != album.id {
            resetState()
            loadedAlbumID = album.id
        }

        async let songsTask: Void = loadSongs(albumId: album.id)
        async let detailsTask: Void = loadAlbumDetailsIfNeeded(album: album)
        _ = await (songsTask, detailsTask)
    }

    func loadSongs(albumId: String) async {
        if isInitialLoadDone { return }
        await fetchSongs(albumId: albumId, page: 1, reset: true)
        isInitialLoadDone = errorMessage == nil
    }

    func retryLoadSongs(albumId: String) async {
        currentPage = 1
        totalPages = 1
        isInitialLoadDone = false
        await fetchSongs(albumId: albumId, page: 1, reset: true)
        isInitialLoadDone = errorMessage == nil
    }

    func loadMoreIfNeeded(currentItem: Song, albumId: String) async {
        guard let last = songs.last else { return }
        guard currentItem.id == last.id else { return }
        guard !isLoading, currentPage <= totalPages else { return }
        await fetchSongs(albumId: albumId, page: currentPage)
    }

    private func loadAlbumDetailsIfNeeded(album: Album) async {
        guard shouldRefreshDetails(for: album) else {
            albumDetails = album
            return
        }

        do {
            albumDetails = try await albumService.fetchAlbum(id: album.id)
        } catch {
            // Keep the incoming album so the screen still renders if the refresh fails.
            albumDetails = album
        }
    }

    private func shouldRefreshDetails(for album: Album) -> Bool {
        album.description?.isEmpty != false
    }

    private func resetState() {
        albumDetails = nil
        songs = []
        isLoading = false
        errorMessage = nil
        currentPage = 1
        totalPages = 1
        isInitialLoadDone = false
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
