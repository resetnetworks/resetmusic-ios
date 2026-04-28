//
//  GenreServiceProtocol.swift
//  resetmusic-ios-local
//
//  Created by resetstudio01  on 21/04/26.
//


import Foundation

//protocol GenreServiceProtocol {
//    func fetchGenre(slug: String) async throws -> Genre
//}

import Foundation

protocol GenreServiceProtocol {
    func fetchGenre(slug: String, page: Int, limit: Int) async throws -> GenreDetailResponse
}
