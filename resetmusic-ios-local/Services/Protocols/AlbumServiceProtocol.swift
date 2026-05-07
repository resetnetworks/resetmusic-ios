//
//  AlbumServiceProtocol.swift
//  resetmusic-ios-local
//
//  Created by Naushad Ali Khan on 13/03/26.
//


import Foundation

protocol AlbumServiceProtocol {
    func fetchAlbums(page: Int) async throws -> AlbumResponse
    func fetchAlbumsByArtist(artistId: String, page: Int) async throws -> ArtistAlbumsResponse
    func fetchAlbum(id: String) async throws -> Album
}
