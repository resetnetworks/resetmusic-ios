//
//  AuthRepository.swift
//  resetmusic-ios-local
//
//  Created by Codex on 06/05/26.
//

import Foundation

protocol AuthRepository {
    func register(name: String, email: String, password: String) async throws -> AuthResponse
    func login(email: String, password: String) async throws -> AuthResponse
    func logout() async throws
    func forgotPassword(email: String) async throws -> ForgotPasswordResponse

    
}
