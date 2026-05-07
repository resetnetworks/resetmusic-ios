//
//  SignUpViewModel.swift
//  resetmusic-ios-local
//
//  Created by Codex on 06/05/26.
//

import Foundation
import Combine

@MainActor
final class SignUpViewModel: ObservableObject {
    @Published var name = ""
    @Published var email = ""
    @Published var password = ""
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var successMessage: String?

    private let repository: AuthRepository

    init(repository: AuthRepository? = nil) {
        self.repository = repository ?? AuthRepositoryImpl(service: AuthService())
    }

    func signUp() async -> Bool {
        errorMessage = validate()
        successMessage = nil

        guard errorMessage == nil else { return false }
        guard !isLoading else { return false }

        isLoading = true
        defer { isLoading = false }

        do {
            let response = try await repository.register(
                name: name.trimmingCharacters(in: .whitespacesAndNewlines),
                email: normalizedEmail,
                password: password
            )
            successMessage = response.message
            errorMessage = nil
            return true
        } catch {
            errorMessage = error.localizedDescription
            return false
        }
    }

    private var normalizedEmail: String {
        email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
    }

    private func validate() -> String? {
        if name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return "Name is required"
        }
        if normalizedEmail.isEmpty {
            return "Email is required"
        }
        if !normalizedEmail.contains("@") {
            return "Enter a valid email"
        }
        if password.isEmpty {
            return "Password is required"
        }
        if password.count < 8 {
            return "Password must be at least 8 characters"
        }
        return nil
    }
}
