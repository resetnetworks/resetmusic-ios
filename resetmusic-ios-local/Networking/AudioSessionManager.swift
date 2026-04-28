//
//  AudioSessionManager.swift
//  resetmusic-ios-local
//
//  Created by Naushad Ali Khan on 24/03/26.
//


import AVFoundation
import UIKit

final class AudioSessionManager {

    static let shared = AudioSessionManager()
    private init() {}

    weak var playerViewModel: PlayerViewModel?

    func configure() {
        do {
            let session = AVAudioSession.sharedInstance()
            
            // Use .playAndRecord for better interruption handling
            try session.setCategory(.playAndRecord,
                                   mode: .default,
                                   options: [.mixWithOthers, .allowBluetooth, .defaultToSpeaker])
            try session.setActive(true)
            print("✅ Audio session configured")
        } catch {
            print("❌ Audio session error: \(error)")
        }

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleInterruption),
            name: AVAudioSession.interruptionNotification,
            object: AVAudioSession.sharedInstance()
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleRouteChange),
            name: AVAudioSession.routeChangeNotification,
            object: AVAudioSession.sharedInstance()
        )
    }

    // MARK: - Interruption Handler
    @objc private func handleInterruption(notification: Notification) {
        guard let info = notification.userInfo,
              let typeValue = info[AVAudioSessionInterruptionTypeKey] as? UInt,
              let type = AVAudioSession.InterruptionType(rawValue: typeValue)
        else {
            print("❌ Failed to parse interruption notification")
            return
        }

        switch type {
        case .began:
            print("🔇 Interruption began — pausing")
            Task { @MainActor in
                self.playerViewModel?.handleInterruptionBegan()
            }

        case .ended:
            // Get the interruption options to know if we should resume
            let optionsValue = info[AVAudioSessionInterruptionOptionKey] as? UInt ?? 0
            let options = AVAudioSession.InterruptionOptions(rawValue: optionsValue)
            let shouldResume = options.contains(.shouldResume)
            
            print("▶️ Interruption ended — should resume: \(shouldResume)")
            Task { @MainActor in
                self.playerViewModel?.handleInterruptionEnded(shouldResume: shouldResume)
            }

        @unknown default:
            print("⚠️ Unknown interruption type")
            break
        }
    }

    // MARK: - Route Change Handler
    @objc private func handleRouteChange(notification: Notification) {
        guard let info = notification.userInfo,
              let reasonValue = info[AVAudioSessionRouteChangeReasonKey] as? UInt,
              let reason = AVAudioSession.RouteChangeReason(rawValue: reasonValue)
        else {
            print("❌ Failed to parse route change notification")
            return
        }

        switch reason {
        case .oldDeviceUnavailable:
            print("🎧 Headphones unplugged — pausing")
            Task { @MainActor in
                self.playerViewModel?.handleHeadphonesUnplugged()
            }

        case .newDeviceAvailable:
            print("🎧 Headphones plugged in")

        default:
            break
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
