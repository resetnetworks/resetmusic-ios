//
//  SongServiceProtocol.swift
//  resetmusic-ios-local
//
//  Created by Naushad Ali Khan on 13/03/26.
//


import Foundation
 
protocol SongServiceProtocol {
    func fetchSongsByAlbum(albumId: String, page: Int) async throws -> SongResponse
}
 