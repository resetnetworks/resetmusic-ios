//
//  MusicPlayerAttributes.swift
//  resetmusic-ios-local
//
//  Created by Naushad Ali Khan on 17/03/26.
//


import ActivityKit
import SwiftUI

struct MusicPlayerAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var title: String
        var artistName: String
        var coverImageURL: String
        var isPlaying: Bool
        var progress: Double
        var isPreview: Bool
    }
    var trackID: String
}
