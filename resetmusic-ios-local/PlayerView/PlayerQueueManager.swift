//
//  PlayerQueueManager.swift
//  resetmusic-ios-local
//
//  Created by Naushad Ali Khan on 23/03/26.
//


import Foundation

final class PlayerQueueManager {

    // MARK: - State
    private(set) var queue: [Song] = []
    private(set) var currentIndex: Int = 0
    private(set) var isShuffled: Bool = false

    private(set) var persistedQueueIds: [String] = []
    private(set) var persistedQueueIndex: Int = 0
    private var originalQueue: [Song] = []

    // MARK: - Queue Setup

    func set(queue: [Song], playingSong song: Song) {
        self.queue = queue.isEmpty ? [song] : queue
        self.currentIndex = self.queue.firstIndex(where: { $0.id == song.id }) ?? 0
        self.originalQueue = self.queue
        self.isShuffled = false
        persistedQueueIds = []
        persistedQueueIndex = 0
    }

    func restoreFromPersisted(ids: [String], index: Int, songs: [Song] = []) {
        if !songs.isEmpty {
            // Full Song objects available — restore real queue
            // skipNext/skipPrevious will hit .song path with full track info
            queue = songs
            currentIndex = index
            originalQueue = songs
            isShuffled = false
            persistedQueueIds = []
            persistedQueueIndex = 0
        } else {
            // Only IDs available — fallback path
            persistedQueueIds = ids
            persistedQueueIndex = index
            queue = []
            currentIndex = 0
            originalQueue = []
            isShuffled = false
        }
    }

    func toggleShuffle() {
        guard !queue.isEmpty else { return }

        if isShuffled {
            let currentSong = currentSong
            queue = originalQueue.isEmpty ? queue : originalQueue
            if let currentSong,
               let index = queue.firstIndex(where: { $0.id == currentSong.id }) {
                currentIndex = index
            }
            isShuffled = false
            return
        }

        originalQueue = queue

        guard let currentSong = currentSong else {
            queue.shuffle()
            currentIndex = 0
            isShuffled = true
            return
        }

        var remainingSongs = queue.filter { $0.id != currentSong.id }
        remainingSongs.shuffle()
        queue = [currentSong] + remainingSongs
        currentIndex = 0
        isShuffled = true
    }

    // MARK: - Navigation

    func next() -> QueueStep? {
        if !queue.isEmpty {
            guard currentIndex < queue.count - 1 else { return nil }
            currentIndex += 1
            return .song(queue[currentIndex])
        }
        guard !persistedQueueIds.isEmpty,
              persistedQueueIndex < persistedQueueIds.count - 1 else { return nil }
        persistedQueueIndex += 1
        return .songId(persistedQueueIds[persistedQueueIndex])
    }

    func previous() -> QueueStep? {
        if !queue.isEmpty {
            guard currentIndex > 0 else { return nil }
            currentIndex -= 1
            return .song(queue[currentIndex])
        }
        guard !persistedQueueIds.isEmpty,
              persistedQueueIndex > 0 else { return nil }
        persistedQueueIndex -= 1
        return .songId(persistedQueueIds[persistedQueueIndex])
    }

    func restartQueue() -> QueueStep? {
        if !queue.isEmpty {
            guard !queue.isEmpty else { return nil }
            currentIndex = 0
            return .song(queue[currentIndex])
        }

        guard !persistedQueueIds.isEmpty else { return nil }
        persistedQueueIndex = 0
        return .songId(persistedQueueIds[persistedQueueIndex])
    }

    func song(withId id: String) -> Song? {
        queue.first { $0.id == id }
    }

    @discardableResult
    func selectSong(withId id: String) -> Song? {
        guard let index = queue.firstIndex(where: { $0.id == id }) else { return nil }
        currentIndex = index
        return queue[index]
    }

    var currentSong: Song? {
        guard queue.indices.contains(currentIndex) else { return nil }
        return queue[currentIndex]
    }

    // MARK: - Persistence Helpers

    var currentQueueIds: [String] {
        queue.isEmpty ? persistedQueueIds : queue.map { $0.id }
    }

    var currentQueueIndex: Int {
        queue.isEmpty ? persistedQueueIndex : currentIndex
    }
}

enum QueueStep {
    case song(Song)
    case songId(String)
}
