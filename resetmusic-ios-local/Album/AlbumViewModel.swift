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

    private let repository: AlbumRepository
    private var cacheRefreshObserver: AnyCancellable?
    private var currentPage = 1
    private var hasMorePages = true
    private let shouldSkipLoading: Bool

    init(repository: AlbumRepository? = nil) {
        self.repository = repository ?? AlbumViewModel.makeDefaultRepository()
        self.shouldSkipLoading = false
        observeAlbumCacheRefresh()
    }

    convenience init(service: AlbumServiceProtocol) {
        let repository = AlbumRepositoryImpl(
            service: service,
            localDataSource: AlbumLocalDataSourceImpl()
        )
        self.init(repository: repository)
    }

    // Preview init — pre-loads mock data, skips network
    init(albums: [Album]) {
        self.repository = AlbumRepositoryImpl(
            service: MockAlbumService(),
            localDataSource: AlbumLocalDataSourceImpl()
        )
        self.albums = albums
        self.shouldSkipLoading = true
    }

    func loadAlbums() async {
        guard !isLoading, hasMorePages else { return }
        guard !(shouldSkipLoading && !albums.isEmpty) else { return }

        isLoading = true
        errorMessage = nil

        do {
            let fetchedAlbums = try await repository.getAlbums(page: currentPage)

            if fetchedAlbums.isEmpty {
                hasMorePages = false
            } else if currentPage == 1 {
                albums = fetchedAlbums
                currentPage += 1
            } else {
                let existingIDs = Set(albums.map(\.id))
                let newAlbums = fetchedAlbums.filter { !existingIDs.contains($0.id) }

                if newAlbums.isEmpty {
                    hasMorePages = false
                } else {
                    albums.append(contentsOf: newAlbums)
                    currentPage += 1
                }
            }
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    func loadMoreIfNeeded(currentItem: Album) async {
        guard let last = albums.last else { return }
        if currentItem.id == last.id && hasMorePages {
            await loadAlbums()
        }
    }

    private func observeAlbumCacheRefresh() {
        cacheRefreshObserver = NotificationCenter.default.publisher(for: .albumsCacheDidRefresh)
            .compactMap { $0.object as? [Album] }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] refreshedAlbums in
                guard let self else { return }
                self.albums = refreshedAlbums
                self.hasMorePages = true
            }
    }

    private static func makeDefaultRepository() -> AlbumRepository {
        AlbumRepositoryImpl(
            service: AlbumService(),
            localDataSource: AlbumLocalDataSourceImpl()
        )
    }
}
