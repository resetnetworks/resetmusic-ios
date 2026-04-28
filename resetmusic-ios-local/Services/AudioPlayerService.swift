//
//  AudioPlayerService.swift
//  resetmusic-ios-local
//
//  Created by Naushad Ali Khan on 14/03/26.
//


import Foundation
import AVFoundation
import Combine

final class AudioPlayerService: ObservableObject {

    static let shared = AudioPlayerService()

    private var player: AVPlayer?
    private var playerItem: AVPlayerItem?
    private var timeObserver: Any?
    private var cancellables = Set<AnyCancellable>()

    @Published var isPlaying: Bool = false
    @Published var progress: Double = 0.0
    @Published var duration: Double = 0.0
    @Published var isLoading: Bool = false
    @Published var error: String? = nil

    private let baseURL = "https://your-api-base-url.com" // ← replace with your base URL

    private init() {
        setupAudioSession()
    }

    // MARK: - Setup

    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Audio session setup failed: \(error)")
        }
    }

    // MARK: - Playback

    func playSong(id: String) {
        let urlString = "\(baseURL)/song/\(id)"
        guard let url = URL(string: urlString) else { return }
        load(url: url)
    }

    func playAlbum(id: String) {
        let urlString = "\(baseURL)/album/\(id)"
        guard let url = URL(string: urlString) else { return }
        load(url: url)
    }

    private func load(url: URL) {
        // Clean up previous
        stop()
        isLoading = true
        error = nil

        playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)

        // Observe status
        playerItem?.publisher(for: \.status)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] status in
                switch status {
                case .readyToPlay:
                    self?.isLoading = false
                    self?.duration = self?.playerItem?.duration.seconds ?? 0
                    self?.player?.play()
                    self?.isPlaying = true
                    self?.startProgressObserver()
                case .failed:
                    self?.isLoading = false
                    self?.error = self?.playerItem?.error?.localizedDescription
                default:
                    break
                }
            }
            .store(in: &cancellables)

        // Observe end of track
        NotificationCenter.default.publisher(for: .AVPlayerItemDidPlayToEndTime, object: playerItem)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.isPlaying = false
                self?.progress = 0.0
            }
            .store(in: &cancellables)
    }

    func togglePlayPause() {
        guard let player else { return }
        if isPlaying {
            player.pause()
            isPlaying = false
        } else {
            player.play()
            isPlaying = true
        }
    }

    func seek(to progress: Double) {
        guard let player, let item = playerItem else { return }
        let seconds = progress * item.duration.seconds
        let time = CMTime(seconds: seconds, preferredTimescale: 600)
        player.seek(to: time)
        self.progress = progress
    }

    func stop() {
        player?.pause()
        player = nil
        playerItem = nil
        isPlaying = false
        progress = 0.0
        duration = 0.0
        removeProgressObserver()
        cancellables.removeAll()
    }

    // MARK: - Progress Observer

    private func startProgressObserver() {
        guard let player else { return }
        let interval = CMTime(seconds: 0.5, preferredTimescale: 600)
        timeObserver = player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            guard let self, let duration = self.playerItem?.duration.seconds,
                  duration > 0, !duration.isNaN else { return }
            self.progress = time.seconds / duration
        }
    }

    private func removeProgressObserver() {
        if let observer = timeObserver {
            player?.removeTimeObserver(observer)
            timeObserver = nil
        }
    }
}