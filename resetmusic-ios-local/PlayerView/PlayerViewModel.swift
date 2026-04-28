//
//  PlayerViewModel.swift
//  resetmusic-ios-local
//
//  Created by Naushad Ali Khan on 13/03/26.
//

import Foundation
import AVKit
import Combine

// MARK: - Player Repeat Mode Enumeration
// Defines the three possible repeat behaviors for the player
// - off: No repeating, playback stops after queue ends
// - queue: Repeats the entire queue from beginning
// - song: Repeats the current song indefinitely
enum PlayerRepeatMode {
    case off
    case queue
    case song
}

// MARK: - Main Player ViewModel
// @MainActor ensures all UI updates happen on the main thread
// ObservableObject allows SwiftUI views to observe and react to changes
@MainActor
final class PlayerViewModel: ObservableObject {

    // MARK: - Published State Properties
    // These properties automatically trigger UI updates when changed
    
    @Published var currentTrack: PlayerTrack?           // Currently playing track
    @Published var isPlaying: Bool = false              // Playback state
    @Published var progress: CGFloat = 0.0              // Playback progress (0.0 to 1.0)
    @Published var duration: Double = 0.0               // Total track duration in seconds
    @Published var isFullPlayerPresented: Bool = false  // Full player screen visibility
    @Published var isLoadingStream: Bool = false        // Loading indicator for streaming
    @Published var errorMessage: String? = nil          // Error messages for user
    @Published var queue: [PlayerTrack] = []            // Current playback queue
    @Published var repeatMode: PlayerRepeatMode = .off  // Current repeat mode setting
    @Published var isShuffleEnabled: Bool = false       // Shuffle mode status
    
    // MARK: - Internal State
    // Add this to track if interruption is active
    private var isInterrupted: Bool = false  // Tracks audio interruption state (calls, etc.)

    // MARK: - Dependencies
    // Injected services and managers that handle different aspects of playback
    private let service: PlayerServiceProtocol      // Handles network requests for streams
    private let engine: PlayerAudioEngine           // Core audio playback engine
    private let queueManager: PlayerQueueManager    // Manages queue operations
    private var cancellables = Set<AnyCancellable>() // Stores Combine subscriptions

    // MARK: - Sync Queue to UI
    // Converts internal queue songs to PlayerTrack format for UI display
    // Called whenever queue changes to update the published queue property
    private func syncQueueToUI() {
        self.queue = queueManager.queue.map {
            PlayerTrack(
                title: $0.title,
                artistName: $0.artist.name,
                artistId: $0.artist.id,
                coverImage: $0.coverImage ?? "",
                duration: Int($0.duration ?? 0),
                isPreview: false,
                songId: $0.id
            )
        }
    }
    
    // MARK: - Initialization
    // Sets up the ViewModel with dependencies, restores saved state, and configures observers
    init(service: PlayerServiceProtocol = PlayerService()) {
        self.service = service
        self.engine = PlayerAudioEngine()
        self.queueManager = PlayerQueueManager()

        // Restore previously playing track from UserDefaults
        if let saved = UserDefaultsManager.shared.loadLastTrack() {
            currentTrack = PlayerTrack(
                title: saved.title,
                artistName: saved.artistName,
                artistId: saved.artistId ?? "",
                coverImage: saved.coverImage,
                isPreview: saved.isPreview,
                songId: saved.songId
            )
            progress = CGFloat(saved.progress)
            duration = saved.duration
            queueManager.restoreFromPersisted(
                ids: saved.queueIds,
                index: saved.queueIndex,
                songs: saved.queueSongs
            )
            isShuffleEnabled = queueManager.isShuffled
            hydrateCurrentTrackArtistFromQueue()
        }

        bindEngine()  // Connect engine publishers to ViewModel
        
        // Add notification observer for app state
        setupAppStateObservers()  // Monitor app lifecycle and audio interruptions
    }
    
    // MARK: - App State Observers Setup
    // Registers for system notifications to handle app state changes and audio interruptions
    private func setupAppStateObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appDidBecomeActive),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleAudioInterruption(_:)),
            name: AVAudioSession.interruptionNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleRouteChange(_:)),
            name: AVAudioSession.routeChangeNotification,
            object: nil
        )
    }
    
    // MARK: - App Active Handler
    // Called when app returns to foreground - ensures UI reflects current playback state
    @objc private func appDidBecomeActive() {
        // If we were playing before interruption and it ended, ensure UI is updated
        Task { @MainActor in
            if !isInterrupted && engine.isPlaying {
                isPlaying = true
//                objectWillChange.send()
            }
        }
    }

    // MARK: - Bind Engine to ViewModel
    // Sets up Combine subscriptions to monitor engine state changes
    // Updates ViewModel properties automatically when engine changes
    private func bindEngine() {
        // Monitors engine's playing state and syncs to ViewModel
        engine.$isPlaying
            .receive(on: RunLoop.main)
            .sink { [weak self] value in
                guard let self = self else { return }
                self.isPlaying = value
            }
            .store(in: &cancellables)
        
        // Monitors playback progress (0.0 to 1.0)
        engine.$progress
            .receive(on: RunLoop.main)
            .sink { [weak self] value in
                self?.progress = value
            }
            .store(in: &cancellables)

        // Monitors total duration of current track
        engine.$duration
            .receive(on: RunLoop.main)
            .sink { [weak self] value in
                self?.duration = value
            }
            .store(in: &cancellables)

        // Callback when track finishes naturally
        engine.onTrackFinished = { [weak self] in
            Task { @MainActor [weak self] in
                self?.handleTrackFinished()
            }
        }

        // Callback for progress ticks - used for persisting state
        engine.onProgressTick = { [weak self] progress, duration in
            Task { @MainActor [weak self] in
                self?.persistCurrentState(progress: progress, duration: duration)
            }
        }
    }

    // MARK: - Play Song
    // Primary method to start playback of a song with optional queue
    // Handles loading stream, updating UI, and error states
    func play(song: Song, queue: [Song] = [], token: String? = nil) async {
        queueManager.set(queue: queue, playingSong: song)

        // ✅ ADD THIS LINE
        syncQueueToUI()  // Updates UI queue display

        currentTrack = PlayerTrack(
            title: song.title,
            artistName: song.artist.name,
            artistId: song.artist.id,
            coverImage: song.coverImage ?? "",
            duration: Int(song.duration ?? 0),
            isPreview: false,
            songId: song.id
        )

        // Reset playback state
        progress = 0
        duration = 0
        isLoadingStream = true
        errorMessage = nil
        isInterrupted = false

        do {
            // Fetch stream URL from service
            let response = try await service.fetchSongStream(songId: song.id, token: token)
            currentTrack?.isPreview = response.isPreview

            guard let url = URL(string: response.url) else {
                errorMessage = "Invalid stream URL"
                isLoadingStream = false
                return
            }

            // Load and auto-play the stream
            engine.load(url: url, isPreview: response.isPreview, autoPlay: true)
            isLoadingStream = false

        } catch {
            errorMessage = error.localizedDescription
            isLoadingStream = false
        }
    }

    // MARK: - Playback Controls
    // User-facing playback control methods
    
    func togglePlayPause() {
        // If no player exists, attempt to resume saved state
        if !engine.hasPlayer {
            Task { await resumeIfNeeded(thenPlay: true) }
            return
        }
        
        // Toggle between play and pause states
        if engine.isPlaying {
            engine.pause()
        } else {
            engine.play()
        }
    }

    func toggleQueuePlayback() {
        guard !queueManager.queue.isEmpty else { return }

        // If current track is from queue, just toggle play/pause
        if engine.hasPlayer,
           let currentSong = queueManager.currentSong,
           currentSong.id == currentTrack?.songId {
            togglePlayPause()
            return
        }

        // Otherwise, determine which song to play from queue
        let songToPlay: Song
        if let currentTrack,
           let selectedSong = queueManager.selectSong(withId: currentTrack.songId) {
            songToPlay = selectedSong
        } else if let firstSong = queueManager.queue.first {
            _ = queueManager.selectSong(withId: firstSong.id)
            songToPlay = firstSong
        } else {
            return
        }

        Task {
            await play(song: songToPlay, queue: queueManager.queue)
        }
    }

    func playQueueTrack(_ track: PlayerTrack) {
        guard let song = queueManager.selectSong(withId: track.songId) else { return }

        Task {
            await play(song: song, queue: queueManager.queue)
        }
    }

    func skipNext() {
        guard let step = queueManager.next() else { return }
        Task { await playStep(step) }
    }

    func skipPrevious() {
        // If playing and within first 3 seconds, go to previous track
        // Otherwise, seek to beginning of current track
        if isPlaying && progress * duration > 3 {
            engine.seek(to: 0)
            return
        }
        guard let step = queueManager.previous() else { return }
        Task { await playStep(step) }
    }

    func seek(to fraction: CGFloat) {
        engine.seek(to: fraction)
    }

    func toggleShuffle() {
        guard !queueManager.queue.isEmpty else { return }
        queueManager.toggleShuffle()
        isShuffleEnabled = queueManager.isShuffled
        syncQueueToUI()
    }

    func toggleQueueRepeat() {
        repeatMode = repeatMode == .queue ? .off : .queue
    }

    func enableSongRepeat() {
        repeatMode = .song
    }
    
    func isCurrentAlbum(_ songs: [Song]) -> Bool {
        guard let current = currentTrack else { return false }
        return songs.contains { $0.id == current.songId }
    }

    // MARK: - Resume on Relaunch
    // Restores playback state when app is relaunched
    // Loads saved track and seeks to saved position
    func resumeIfNeeded(thenPlay: Bool = false) async {
        guard !engine.hasPlayer else { return }
        guard let saved = UserDefaultsManager.shared.loadLastTrack(),
              !saved.songId.isEmpty else { return }

        if currentTrack?.songId.isEmpty ?? true {
            currentTrack = PlayerTrack(
                title: saved.title,
                artistName: saved.artistName,
                artistId: saved.artistId ?? "",
                coverImage: saved.coverImage,
                isPreview: saved.isPreview,
                songId: saved.songId
            )
        }

        queueManager.restoreFromPersisted(
            ids: saved.queueIds,
            index: saved.queueIndex,
            songs: saved.queueSongs
        )
        isShuffleEnabled = queueManager.isShuffled
        hydrateCurrentTrackArtistFromQueue()
        isLoadingStream = true

        do {
            let response = try await service.fetchSongStream(songId: saved.songId, token: nil)
            currentTrack?.isPreview = response.isPreview

            guard let url = URL(string: response.url) else {
                isLoadingStream = false
                return
            }

            engine.load(
                url: url,
                isPreview: response.isPreview,
                autoPlay: false,
                restoreProgress: saved.progress,
                restoreDuration: saved.duration
            )
            isLoadingStream = false

            if saved.progress > 0 && saved.duration > 0 {
                let seeked = await engine.seekWhenReady(to: saved.progress * saved.duration)
                if seeked && thenPlay {
                    engine.play()
                    isPlaying = true
                }
            } else if thenPlay {
                engine.play()
                isPlaying = true
            }

        } catch {
            errorMessage = error.localizedDescription
            isLoadingStream = false
        }
    }

    // MARK: - Private Helpers
    // Internal utility methods
    
    @MainActor
    func playAlbum(_ songs: [Song]) async {
        guard let first = songs.first else { return }
        await play(song: first, queue: songs)
    }
    
    // Handles queue step transitions (song or songId)
    private func playStep(_ step: QueueStep) async {
        switch step {
        case .song(let song):
            await play(song: song, queue: queueManager.queue)
            syncQueueToUI()   // ✅ ADD THIS LINE

        case .songId(let id):
            isLoadingStream = true
            do {
                let response = try await service.fetchSongStream(songId: id, token: nil)
                guard let url = URL(string: response.url) else {
                    isLoadingStream = false
                    return
                }

                currentTrack = PlayerTrack(
                    title: currentTrack?.title ?? "",
                    artistName: currentTrack?.artistName ?? "",
                    artistId: currentTrack?.artistId ?? "",
                    coverImage: currentTrack?.coverImage ?? "",
                    duration: Int(duration),
                    isPreview: response.isPreview,
                    songId: id
                )

                engine.load(url: url, isPreview: response.isPreview, autoPlay: true)
                isLoadingStream = false

                syncQueueToUI() // ✅ ALSO ADD HERE (important)

            } catch {
                errorMessage = error.localizedDescription
                isLoadingStream = false
            }
        }
    }

    // Handles logic when a track finishes playing
    private func handleTrackFinished() {
        if repeatMode == .song, let currentSong = queueManager.currentSong {
            Task { await play(song: currentSong, queue: queueManager.queue) }
        } else if let step = queueManager.next() {
            Task { await playStep(step) }
        } else if repeatMode == .queue, let step = queueManager.restartQueue() {
            Task { await playStep(step) }
        } else {
            isPlaying = false
            progress = 0
        }
    }

    // Saves current playback state to UserDefaults for restoration
    private func persistCurrentState(progress: CGFloat, duration: Double) {
        guard let track = currentTrack else { return }
        UserDefaultsManager.shared.saveLastTrack(PersistedTrack(
            title: track.title,
            artistName: track.artistName,
            artistId: track.artistId,
            coverImage: track.coverImage,
            songId: track.songId,
            isPreview: track.isPreview,
            progress: Double(progress),
            duration: duration,
            queueIds: queueManager.currentQueueIds,
            queueIndex: queueManager.currentQueueIndex,
            queueSongs: queueManager.queue
        ))
    }

    // Ensures current track has complete artist information from queue
    private func hydrateCurrentTrackArtistFromQueue() {
        guard let songId = currentTrack?.songId,
              let song = queueManager.song(withId: songId)
        else { return }

        currentTrack?.artistId = song.artist.id
        currentTrack?.artist = FeaturedArtist(
            id: song.artist.id,
            name: song.artist.name,
            slug: song.artist.slug ?? "",  // 👈 safe unwrap
            bio: nil,
            location: nil,
            country: nil,
            profileImage: nil,
            coverImage: nil,
            subscriptionPlans: [],
            isMonetizationComplete: false,
            songCount: 0,
            albumCount: 0,
            createdAt: "",
            updatedAt: ""
        )
    }
    
    // MARK: - Audio Session Event Handlers
    // Methods to handle system audio interruptions (calls, alarms, etc.)
    
    // Called when an audio interruption begins (e.g., incoming call)
    func handleInterruptionBegan() {
        print("🔴🔴🔴 VIEWMODEL: Interruption began")
        print("🔴 isPlaying before: \(isPlaying)")
        isInterrupted = true
        
        if engine.isPlaying {
            engine.pause()
            print("🔴 Paused playback due to interruption")
        }
    }

    // Called when an audio interruption ends
    func handleInterruptionEnded(shouldResume: Bool) {
        print("🟢🟢🟢 VIEWMODEL: Interruption ended — shouldResume: \(shouldResume)")
        print("🟢 isPlaying before: \(isPlaying)")
        
        guard shouldResume else {
            print("🟢 System says not to resume playback")
            isInterrupted = false
            return
        }
        
        Task { @MainActor in
            do {
                print("🟢 Attempting to reactivate audio session...")
                // Reactivate audio session
                try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
                print("🟢 Audio session reactivated")
                
                // Small delay to ensure session is stable
                try await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
                
                print("🟢 Attempting to resume playback...")
                // Resume playback
                engine.play()
                isInterrupted = false
                print("🟢 Successfully resumed after interruption")
                
            } catch {
                print("🟢 Failed to resume after interruption: \(error)")
                
                // Attempt to recover
                do {
                    try AVAudioSession.sharedInstance().setActive(true)
                    engine.play()
                    isInterrupted = false
                    print("🟢 Recovered after initial failure")
                } catch {
                    print("🟢 Recovery failed: \(error)")
                    errorMessage = "Could not resume playback after call"
                    isInterrupted = false
                }
            }
        }
    }
    
    // Handles headphones being unplugged
    func handleHeadphonesUnplugged() {
        print("🎧 Headphones unplugged")
        
        if engine.isPlaying {
            engine.pause()
            print("⏸ Paused due to headphones unplugged")
        }
    }
    
    // MARK: - Notification Handlers
    // Respond to system notifications
    
    @objc private func handleAudioInterruption(_ notification: Notification) {
        guard let info = notification.userInfo,
              let typeValue = info[AVAudioSessionInterruptionTypeKey] as? UInt,
              let type = AVAudioSession.InterruptionType(rawValue: typeValue)
        else { return }

        if type == .began {
            handleInterruptionBegan()
        } else if type == .ended {
            let shouldResume: Bool
            if let optionsValue = info[AVAudioSessionInterruptionOptionKey] as? UInt {
                shouldResume = AVAudioSession.InterruptionOptions(rawValue: optionsValue).contains(.shouldResume)
            } else {
                shouldResume = false
            }
            handleInterruptionEnded(shouldResume: shouldResume)
        }
    }

    @objc private func handleRouteChange(_ notification: Notification) {
        guard let info = notification.userInfo,
              let reasonValue = info[AVAudioSessionRouteChangeReasonKey] as? UInt,
              let reason = AVAudioSession.RouteChangeReason(rawValue: reasonValue)
        else { return }

        if reason == .oldDeviceUnavailable {
            handleHeadphonesUnplugged()
        }
    }
    
    // MARK: - Deinitialization
    // Clean up notification observers when ViewModel is deallocated
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
