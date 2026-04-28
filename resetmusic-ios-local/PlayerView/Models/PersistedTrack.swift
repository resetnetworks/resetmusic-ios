//
//  PersistedTrack.swift
//  resetmusic-ios-local
//
//  Created by Naushad Ali Khan on 16/03/26.
//


import Foundation

/// Lightweight Codable version of PlayerTrack for UserDefaults persistence.
struct PersistedTrack: Codable {
    let title: String
    let artistName: String
    let artistId: String?
    let coverImage: String
    let songId: String
    let isPreview: Bool
    let progress: Double     // 0.0 - 1.0 fractional position
    let duration: Double     // total seconds (or 30 for preview)
    
    //these two for persisting userdefault queue
    let queueIds: [String]
    let queueIndex: Int
    let queueSongs: [Song] // ← full Song objects for proper track info after relaunch

}
