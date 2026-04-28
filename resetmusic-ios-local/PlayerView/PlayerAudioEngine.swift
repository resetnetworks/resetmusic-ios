//
//  PlayerAudioEngine.swift
//  resetmusic-ios-local
//
//  Created by Naushad Ali Khan on 23/03/26.
//


import Foundation
import AVKit
import Combine

/// Owns AVPlayer entirely. Nothing else should touch AVPlayer directly.
/// Publishes playback state that PlayerViewModel subscribes to.
@MainActor
final class PlayerAudioEngine: ObservableObject {

    // MARK: - Published (VM reads these)
    @Published var isPlaying: Bool = false
    @Published var progress: CGFloat = 0.0
    @Published var duration: Double = 0.0

    // MARK: - Callbacks (VM sets these)
    var onTrackFinished: (() -> Void)?
    var onProgressTick: ((CGFloat, Double) -> Void)?

    // MARK: - Private
    private var player: AVPlayer?
    private var playerItem: AVPlayerItem?
    private var timeObserver: Any?
    private var isSeeking: Bool = false
    private var isPreview: Bool = false

    // MARK: - Setup

    /// Call this every time a new stream URL is ready to play
    func load(url: URL, isPreview: Bool, autoPlay: Bool,
              restoreProgress: Double? = nil, restoreDuration: Double? = nil) {
        self.isPreview = isPreview
        teardown()

        // Restore progress immediately so bar never flashes to 0
        if !autoPlay, let rp = restoreProgress, let rd = restoreDuration, rd > 0 {
            progress = CGFloat(rp)
            duration = rd
        }

        let item = AVPlayerItem(url: url)
        playerItem = item
        player = AVPlayer(playerItem: item)

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(itemDidFinish),
            name: .AVPlayerItemDidPlayToEndTime,
            object: item
        )

        // Fire every 0.05s to update progress
        timeObserver = player?.addPeriodicTimeObserver(
            forInterval: CMTime(seconds: 0.05, preferredTimescale: 600),
            queue: .main
        ) { [weak self] time in
            guard let self,
                  let itemDuration = self.player?.currentItem?.duration.seconds,
                  itemDuration > 0,
                  !self.isSeeking else { return }

            Task { @MainActor in
                let cap = self.isPreview ? 30.0 : itemDuration
                self.duration = cap
                let currentSeconds = min(time.seconds, cap)
                self.progress = CGFloat(currentSeconds / cap)

                // Hard stop at 30s for previews
                if self.isPreview && time.seconds >= 30.0 {
                    self.player?.pause()
                    self.isPlaying = false
                    self.progress = 1.0
                }

                // Tell VM to persist — VM knows track info, engine doesn't
                self.onProgressTick?(self.progress, self.duration)
            }
        }

        if autoPlay {
            player?.play()
            isPlaying = true
        } else {
            isPlaying = false
        }
    }

    // MARK: - Controls

    func play() {
        print("🎵🎵🎵 ENGINE: play() called")  // ADD THIS LINE
        player?.play()
        isPlaying = true
        print("🎵🎵🎵 ENGINE: isPlaying set to true")  // ADD THIS LINE
    }

    func pause() {
        print("🎵🎵🎵 ENGINE: pause() called")  // ADD THIS LINE
        player?.pause()
        isPlaying = false
        print("🎵🎵🎵 ENGINE: isPlaying set to false")  // ADD THIS LINE
    }

    func togglePlayPause() {
        isPlaying ? pause() : play()
    }

    func seek(to fraction: CGFloat) {
        guard let player,
              let dur = player.currentItem?.duration else { return }
        let seconds = Double(fraction) * dur.seconds
        player.seek(to: CMTime(seconds: seconds, preferredTimescale: 600))
    }

    func seekWhenReady(to seconds: Double) async -> Bool {
        guard let playerItem else { return false }
        let seekTime = CMTime(seconds: seconds, preferredTimescale: 600)
        isSeeking = true

        var attempts = 0
        while playerItem.status != .readyToPlay && attempts < 20 {
            try? await Task.sleep(nanoseconds: 250_000_000)
            attempts += 1
        }

        guard playerItem.status == .readyToPlay else {
            isSeeking = false
            return false
        }

        return await withCheckedContinuation { continuation in
            player?.seek(to: seekTime, toleranceBefore: .zero, toleranceAfter: .zero) { [weak self] finished in
                Task { @MainActor [weak self] in
                    guard let self else { continuation.resume(returning: false); return }
                    if finished {
                        self.progress = CGFloat(seconds / self.duration)
                    }
                    self.isSeeking = false
                    continuation.resume(returning: finished)
                }
            }
        }
    }

    var hasPlayer: Bool { player != nil }

    // MARK: - Teardown

    func teardown() {
        if let timeObserver {
            player?.removeTimeObserver(timeObserver)
        }
        NotificationCenter.default.removeObserver(self)
        player?.pause()
        player = nil
        playerItem = nil
        timeObserver = nil
    }

    @objc private func itemDidFinish() {
        isPlaying = false
        onTrackFinished?()
    }
}
