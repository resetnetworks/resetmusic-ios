//
//  ResetPasswordView.swift
//  resetmusic-ios-local
//
//  Created by resetstudio01  on 07/05/26.
//

import SwiftUI

struct ResetPasswordView: View {

    let resetToken: String

    @State private var newPassword: String = ""
    @State private var confirmPassword: String = ""
    @State private var isLoading: Bool = false
    @State private var isSuccess: Bool = false
    @State private var errorMessage: String? = nil

    var onBackToLogin: () -> Void = {}

    // MARK: - Validation

    private var hasMinLength:  Bool { newPassword.count >= 8 }
    private var hasLowercase:  Bool { newPassword.range(of: "[a-z]", options: .regularExpression) != nil }
    private var hasUppercase:  Bool { newPassword.range(of: "[A-Z]", options: .regularExpression) != nil }
    private var hasNumber:     Bool { newPassword.range(of: "[0-9]", options: .regularExpression) != nil }
    private var hasSymbol:     Bool { newPassword.range(of: "[^a-zA-Z0-9]", options: .regularExpression) != nil }
    private var passwordsMatch: Bool { !newPassword.isEmpty && newPassword == confirmPassword }

    private var isStrongPassword: Bool {
        hasMinLength && hasLowercase && hasUppercase && hasNumber && hasSymbol
    }

    private var canSubmit: Bool {
        isStrongPassword && passwordsMatch && !isLoading
    }

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 0) {
                Image("logo-icon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 48, height: 48)
                    .padding(.top, 60)
                    .padding(.bottom, 32)

                if isSuccess {
                    successView
                } else {
                    formView
                }
            }
        }
        .onTapGesture {
            UIApplication.shared.sendAction(
                #selector(UIResponder.resignFirstResponder),
                to: nil, from: nil, for: nil
            )
        }
        .appBackground()
    }

    // MARK: - Form

    private var formView: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Text("reset")
                    .font(.custom("Jura-Bold", size: 28))
                    .foregroundColor(Color(red: 0.25, green: 0.55, blue: 1.0))
                Text(" your password")
                    .font(.custom("Jura-Regular", size: 28))
                    .foregroundColor(.white)
            }
            .padding(.bottom, 12)

            Text("Choose a new password for your account.")
                .font(.custom("Jura-Regular", size: 14))
                .foregroundColor(.white.opacity(0.45))
                .multilineTextAlignment(.center)
                .lineSpacing(5)
                .padding(.bottom, 40)

            // ── New password + strength hints ─────────────────
            AuthTextField(
                label: "new password",
                placeholder: "Enter new password",
                icon: "lock",
                text: $newPassword,
                isSecure: true
            )
            .padding(.horizontal, 24)
            .padding(.bottom, 10)

            // Inline strength hints — visible once user starts typing
            if !newPassword.isEmpty {
                PasswordStrengthHints(
                    hasMinLength: hasMinLength,
                    hasLowercase: hasLowercase,
                    hasUppercase: hasUppercase,
                    hasNumber: hasNumber,
                    hasSymbol: hasSymbol
                )
                .padding(.horizontal, 28)
                .padding(.bottom, 20)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }

            // ── Confirm password ──────────────────────────────
            AuthTextField(
                label: "confirm password",
                placeholder: "Re-enter new password",
                icon: "lock.fill",
                text: $confirmPassword,
                isSecure: true
            )
            .padding(.horizontal, 24)
            .padding(.bottom, 8)

            // Confirm match hint
            if !confirmPassword.isEmpty {
                HStack(spacing: 6) {
                    Image(systemName: passwordsMatch ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .font(.system(size: 12))
                        .foregroundColor(
                            passwordsMatch
                            ? Color(red: 0.25, green: 0.55, blue: 1.0)
                            : Color(red: 1.0, green: 0.35, blue: 0.35)
                        )
                    Text(passwordsMatch ? "Passwords match" : "Passwords don't match")
                        .font(.custom("Jura-Regular", size: 12))
                        .foregroundColor(
                            passwordsMatch
                            ? .white.opacity(0.5)
                            : Color(red: 1.0, green: 0.35, blue: 0.35).opacity(0.8)
                        )
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 28)
                .padding(.bottom, 24)
                .transition(.opacity)
            } else {
                Spacer().frame(height: 24)
            }

            // Error
            if let errorMessage {
                Text(errorMessage)
                    .font(.custom("Jura-Regular", size: 13))
                    .foregroundColor(Color(red: 1.0, green: 0.35, blue: 0.35))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 16)
            }

            AuthPrimaryButton(title: "Reset Password", isLoading: isLoading) {
                Task { await submit() }
            }
            .padding(.horizontal, 24)
            .disabled(!canSubmit)
            .opacity(canSubmit ? 1 : 0.5)
            .padding(.bottom, 24)

            Rectangle()
                .fill(Color.white.opacity(0.08))
                .frame(height: 1)
                .padding(.horizontal, 24)
                .padding(.bottom, 20)

            HStack(spacing: 4) {
                Text("Remembered it?")
                    .font(.custom("Jura-Regular", size: 14))
                    .foregroundColor(.white.opacity(0.5))
                Button(action: onBackToLogin) {
                    Text("Back to Login")
                        .font(.custom("Jura-SemiBold", size: 14))
                        .foregroundColor(Color(red: 0.25, green: 0.55, blue: 1.0))
                }
                .buttonStyle(.plain)
            }
            .padding(.bottom, 40)
        }
        .animation(.easeInOut(duration: 0.2), value: newPassword.isEmpty)
        .animation(.easeInOut(duration: 0.2), value: confirmPassword.isEmpty)
    }

    // MARK: - Success

    private var successView: some View {
        VStack(spacing: 0) {
            ZStack {
                Circle()
                    .fill(Color(red: 0.25, green: 0.55, blue: 1.0).opacity(0.12))
                    .frame(width: 80, height: 80)
                Image(systemName: "checkmark")
                    .font(.system(size: 32, weight: .semibold))
                    .foregroundColor(Color(red: 0.25, green: 0.55, blue: 1.0))
            }
            .padding(.bottom, 24)

            Text("password reset!")
                .font(.custom("Jura-Bold", size: 28))
                .foregroundColor(.white)
                .padding(.bottom, 12)

            Text("Your password has been updated.\nYou can now log in with your new password.")
                .font(.custom("Jura-Regular", size: 14))
                .foregroundColor(.white.opacity(0.45))
                .multilineTextAlignment(.center)
                .lineSpacing(5)
                .padding(.bottom, 40)

            AuthPrimaryButton(title: "Back to Login", isLoading: false) {
                onBackToLogin()
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 40)
        }
    }

    // MARK: - Submit

    private func submit() async {
        guard canSubmit else { return }
        errorMessage = nil
        isLoading = true

        // TODO: wire up your API
        // let result = await AuthService.shared.resetPassword(token: resetToken, password: newPassword)

        try? await Task.sleep(nanoseconds: 1_500_000_000)
        isLoading = false
        isSuccess = true
    }
}

// MARK: - Password Strength Hints

private struct PasswordStrengthHints: View {
    let hasMinLength: Bool
    let hasLowercase: Bool
    let hasUppercase: Bool
    let hasNumber: Bool
    let hasSymbol: Bool

    private let accent = Color(red: 0.25, green: 0.55, blue: 1.0)
    private let dim    = Color.white.opacity(0.25)

    var body: some View {
        // Single scrolling row — matches the reference image exactly
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 0) {
                hintItem("8+ chars", met: hasMinLength)
                divider
                hintItem("Lowercase", met: hasLowercase)
                divider
                hintItem("Uppercase", met: hasUppercase)
                divider
                hintItem("Number", met: hasNumber)
                divider
                hintItem("Symbol", met: hasSymbol)
            }
        }
    }

    private func hintItem(_ label: String, met: Bool) -> some View {
        Text(label)
            .font(.custom("Jura-Regular", size: 12))
            .foregroundColor(met ? accent : dim)
            .animation(.easeInOut(duration: 0.15), value: met)
    }

    private var divider: some View {
        Text(" · ")
            .font(.custom("Jura-Regular", size: 12))
            .foregroundColor(Color.white.opacity(0.15))
    }
}

// MARK: - Preview

#Preview {
    ResetPasswordView(resetToken: "preview-token-abc123")
}
