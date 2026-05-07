//
//  AuthResponse.swift
//  resetmusic-ios-local
//
//  Created by Codex on 06/05/26.
//

import Foundation

struct AuthResponse: Decodable {
    let user: AuthUser
    let token: String
    let message: String
}

struct AuthActionResponse: Decodable {
    let message: String
}

struct RegisterRequest: Encodable {
    let name: String
    let email: String
    let password: String
}

struct LoginRequest: Encodable {
    let email: String
    let password: String
}
