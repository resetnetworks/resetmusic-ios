//
//  NetworkManager.swift
//  resetmusic-ios-local
//
//  Created by Naushad Ali Khan on 04/03/26.
//

import Foundation

final class NetworkManager {

    static let shared = NetworkManager()
    private init() {}

    func request<T: Decodable>(
        _ endpoint: APIEndpoint,
        responseType: T.Type,
        token: String? = nil
    ) async throws -> T {

        guard let url = URL(string: APIConfig.baseURL + endpoint.path) else {
            throw APIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.httpBody = endpoint.body

        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if endpoint.requiresAuth, let token = token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }

        guard 200..<300 ~= httpResponse.statusCode else {
            let message = String(data: data, encoding: .utf8) ?? "Server error"
            throw APIError.serverError(message)
        }

        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            // 🔍 Detailed decode error — remove before release
            print("🔴 Decode failed for \(T.self): \(error)")
            throw APIError.decodingError
        }
    }
}
