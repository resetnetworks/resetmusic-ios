//
//  MusicAppIntents.swift
//  resetmusic-ios-local
//
//  Created by Naushad Ali Khan on 17/03/26.
//

import AppIntents
import ActivityKit

struct TogglePlayPauseIntent: LiveActivityIntent {
    static var title: LocalizedStringResource = "Toggle play/pause"

    func perform() async throws -> some IntentResult {
        await PlayerViewModel.shared.togglePlayPause()
        return .result()
    }
}

struct SkipPreviousIntent: LiveActivityIntent {
    static var title: LocalizedStringResource = "Previous track"

    func perform() async throws -> some IntentResult {
        await PlayerViewModel.shared.skipPrevious()
        return .result()
    }
}
