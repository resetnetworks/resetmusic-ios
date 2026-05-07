//
//  ForgotPasswordRequest.swift
//  resetmusic-ios-local
//
//  Created by resetstudio01  on 07/05/26.
//


import Foundation

// MARK: - Request

struct ForgotPasswordRequest: Encodable {
    let email: String
}

// MARK: - Response

struct ForgotPasswordResponse: Decodable {
    let success: Bool
    let message: String
}