//
//  UserDefaultsManager.swift
//  resetmusic-ios-local
//
//  Created by Naushad Ali Khan on 16/03/26.
//


import Foundation

final class UserDefaultsManager {

    static let shared = UserDefaultsManager()
    private init() {}

    private let defaults = UserDefaults.standard

    private enum Keys {
        static let lastPlayerTrack = "lastPlayerTrack"
        static let currentAuthUser = "currentAuthUser"
    }

    func saveLastTrack(_ track: PersistedTrack) {
        guard let data = try? JSONEncoder().encode(track) else { return }
        defaults.set(data, forKey: Keys.lastPlayerTrack)
    }

    func loadLastTrack() -> PersistedTrack? {
        guard let data = defaults.data(forKey: Keys.lastPlayerTrack),
              let track = try? JSONDecoder().decode(PersistedTrack.self, from: data)
        else { return nil }
        return track
    }

    func clearLastTrack() {
        defaults.removeObject(forKey: Keys.lastPlayerTrack)
    }

    func saveCurrentUser(_ user: AuthUser) {
        guard let data = try? JSONEncoder().encode(user) else { return }
        defaults.set(data, forKey: Keys.currentAuthUser)
    }

    func loadCurrentUser() -> AuthUser? {
        guard let data = defaults.data(forKey: Keys.currentAuthUser),
              let user = try? JSONDecoder().decode(AuthUser.self, from: data)
        else { return nil }
        return user
    }

    func clearCurrentUser() {
        defaults.removeObject(forKey: Keys.currentAuthUser)
    }
}
