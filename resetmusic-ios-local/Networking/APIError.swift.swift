//
//  APIError.swift.swift
//  resetmusic-ios-local
//
//  Created by Naushad Ali Khan on 04/03/26.
//

import Foundation
enum APIError: LocalizedError {
    case invalidURL
    case invalidResponse
    case decodingError
    case serverError(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid server response"
        case .decodingError:
            return "Failed to decode data"
        case .serverError(let message):
            return message
        }
    }
}
