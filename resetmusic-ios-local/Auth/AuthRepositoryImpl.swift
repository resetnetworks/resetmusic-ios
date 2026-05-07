//
//  AuthRepositoryImpl.swift
//  resetmusic-ios-local
//
//  Created by Codex on 06/05/26.
//

import Foundation

final class AuthRepositoryImpl: AuthRepository {
    private let service: AuthServiceProtocol
    private let keychainManager: KeychainManager

    init(
        service: AuthServiceProtocol,
        keychainManager: KeychainManager = .shared
    ) {
        self.service = service
        self.keychainManager = keychainManager
    }

    func register(name: String, email: String, password: String) async throws -> AuthResponse {
        let response = try await service.register(name: name, email: email, password: password)
        try keychainManager.saveAuthToken(response.token)
        UserDefaultsManager.shared.saveCurrentUser(response.user)
        return response
    }

    func login(email: String, password: String) async throws -> AuthResponse {
        let response = try await service.login(email: email, password: password)
        try keychainManager.saveAuthToken(response.token)
        UserDefaultsManager.shared.saveCurrentUser(response.user)
        return response
    }

    func logout() async throws {
        let token = try keychainManager.loadAuthToken()

        defer {
            try? keychainManager.clearAuthToken()
            UserDefaultsManager.shared.clearCurrentUser()
        }

        guard let token, !token.isEmpty else { return }
        try await service.logout(token: token)
    }
    
    func forgotPassword(email: String) async throws -> ForgotPasswordResponse {
         // No token storage needed — just pass through to service
         return try await service.forgotPassword(email: email)
     }
}
