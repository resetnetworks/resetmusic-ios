//
//  GenreDetailViewModel.swift
//  resetmusic-ios-local
//
//  Created by resetstudio01  on 21/04/26.
//

import Foundation
import Combine

@MainActor
final class GenreDetailViewModel: ObservableObject {

    @Published var genreDetail: GenreDetailResponse? = nil
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil

    private let service: GenreServiceProtocol
    private let pageSize = 32
    private var currentPage = 1
    private var totalPages = 1
    private var currentSlug: String?
    private var hasLoadedInitialPage = false

    init(service: GenreServiceProtocol) {
        self.service = service
    }

    convenience init() {
        self.init(service: GenreService())
    }

    func load(slug: String) async {
        guard currentSlug != slug || !hasLoadedInitialPage else { return }

        currentSlug = slug
        currentPage = 1
        totalPages = 1
        genreDetail = nil
        hasLoadedInitialPage = false

        await fetchGenre(slug: slug, page: 1, reset: true)
    }

    func loadMoreIfNeeded(currentItem: Song) async {
        guard let genreDetail, let lastSong = genreDetail.songs.last else { return }
        guard currentItem.id == lastSong.id else { return }
        guard !isLoading, currentPage <= totalPages else { return }
        guard let currentSlug else { return }

        await fetchGenre(slug: currentSlug, page: currentPage)
    }

    private func fetchGenre(slug: String, page: Int, reset: Bool = false) async {
        guard !isLoading else { return }

        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            let response = try await service.fetchGenre(slug: slug, page: page, limit: pageSize)

            if reset || genreDetail == nil {
                genreDetail = response
            } else if let existingGenreDetail = genreDetail {
                genreDetail = GenreDetailResponse(
                    success: response.success,
                    genre: response.genre,
                    total: response.total,
                    page: response.page,
                    pages: response.pages,
                    songs: existingGenreDetail.songs + response.songs
                )
            }

            totalPages = response.pages
            currentPage = page + 1
            hasLoadedInitialPage = true
        } catch {
            errorMessage = error.localizedDescription
            print("❌ Failed to load genre: \(error)")
        }
    }
}
