//
//  SearchServiceProtocol.swift
//  resetmusic-ios-local
//
//  Created by Codex on 13/04/26.
//

import Foundation

protocol SearchServiceProtocol {
    func search(query: String) async throws -> SearchResponse
}
