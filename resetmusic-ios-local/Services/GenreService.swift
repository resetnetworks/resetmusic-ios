//
//  GenreService.swift
//  resetmusic-ios-local
//
//  Created by resetstudio01  on 21/04/26.
//


//import Foundation
//
//final class GenreService: GenreServiceProtocol {
//
//    func fetchGenre(slug: String) async throws -> Genre {
//        let response = try await NetworkManager.shared.request(
//            GenreEndpoint.getBySlug(slug),
//            responseType: GenreDetailResponse.self
//        )
//        return response.data
//    }
//}

import Foundation

final class GenreService: GenreServiceProtocol {

    func fetchGenre(slug: String, page: Int, limit: Int) async throws -> GenreDetailResponse {
        try await NetworkManager.shared.request(
            GenreEndpoint.getBySlug(slug, page: page, limit: limit),
            responseType: GenreDetailResponse.self
        )
    }
}
