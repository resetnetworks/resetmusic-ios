//
//  ForgotPasswordViewModel.swift
//  resetmusic-ios-local
//
//  Created by resetstudio01  on 07/05/26.
//


import Foundation
import Combine

@MainActor
final class ForgotPasswordViewModel: ObservableObject {
    @Published var email = ""
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var successMessage: String?

    private let repository: AuthRepository

    init(repository: AuthRepository? = nil) {
        self.repository = repository ?? AuthRepositoryImpl(service: AuthService())
    }

    func sendResetLink() async {
        errorMessage = validate()
        successMessage = nil

        guard errorMessage == nil else { return }
        guard !isLoading else { return }

        isLoading = true
        defer { isLoading = false }

        do {
            let response = try await repository.forgotPassword(email: normalizedEmail)
            successMessage = response.message
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private var normalizedEmail: String {
        email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
    }

    private func validate() -> String? {
        if normalizedEmail.isEmpty { return "Email is required" }
        if !normalizedEmail.contains("@") { return "Enter a valid email" }
        return nil
    }
}
