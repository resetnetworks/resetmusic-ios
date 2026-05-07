//
//  AuthService.swift
//  resetmusic-ios-local
//
//  Created by Codex on 06/05/26.
//

import Foundation

final class AuthService: AuthServiceProtocol {
    func register(name: String, email: String, password: String) async throws -> AuthResponse {
        let body = try JSONEncoder().encode(
            RegisterRequest(name: name, email: email, password: password)
        )

        return try await NetworkManager.shared.request(
            AuthEndpoint.register(body),
            responseType: AuthResponse.self
        )
    }

    func login(email: String, password: String) async throws -> AuthResponse {
        let body = try JSONEncoder().encode(
            LoginRequest(email: email, password: password)
        )

        return try await NetworkManager.shared.request(
            AuthEndpoint.login(body),
            responseType: AuthResponse.self
        )
    }

    func logout(token: String) async throws {
        _ = try await NetworkManager.shared.request(
            AuthEndpoint.logout,
            responseType: AuthActionResponse.self,
            token: token
        )
    }
    
    
        func forgotPassword(email: String) async throws -> ForgotPasswordResponse {
            let body = try JSONEncoder().encode(ForgotPasswordRequest(email: email))
            return try await NetworkManager.shared.request(
                AuthEndpoint.forgotPassword(body),
                responseType: ForgotPasswordResponse.self
            )
        }
    }
     

