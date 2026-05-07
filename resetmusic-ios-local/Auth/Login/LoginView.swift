//
//  LoginView.swift
//  resetmusic-ios-local
//
//  Created by Naushad Ali Khan on 12/03/26.
//


import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()

    var onCreateAccount: () -> Void = {}
    var onForgotPassword: () -> Void = {}
    var onAuthenticated: () -> Void = {}

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 0) {

                // Logo
                Image("logo-icon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 48, height: 48)
                    .padding(.top, 60)
                    .padding(.bottom, 32)

                // Title
                HStack(spacing: 0) {
                    Text("login")
                        .font(.custom("Jura-Bold", size: 28))
                        .foregroundColor(Color(red: 0.25, green: 0.55, blue: 1.0))
                    Text(" to musicreset")
                        .font(.custom("Jura-Regular", size: 28))
                        .foregroundColor(.white)
                }
                .padding(.bottom, 40)

                // Form
                VStack(spacing: 20) {
                    AuthTextField(
                        label: "email",
                        placeholder: "Enter your email",
                        icon: "envelope",
                        text: $viewModel.email,
                        keyboardType: .emailAddress
                    )

                    VStack(alignment: .trailing, spacing: 8) {
                        AuthTextField(
                            label: "password",
                            placeholder: "Enter your password",
                            icon: "lock",
                            text: $viewModel.password,
                            isSecure: true
                        )

                        Button(action: onForgotPassword) {
                            Text("Forgot Password?")
                                .font(.custom("Jura-Regular", size: 13))
                                .foregroundColor(.white.opacity(0.5))
                        }
                        .buttonStyle(.plain)
                    }

                    if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .font(.custom("Jura-Regular", size: 13))
                            .foregroundColor(Color(red: 0.85, green: 0.3, blue: 0.3))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }

                    if let successMessage = viewModel.successMessage {
                        Text(successMessage)
                            .font(.custom("Jura-Regular", size: 13))
                            .foregroundColor(Color(red: 0.25, green: 0.55, blue: 1.0))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 32)

                // Login button
                AuthPrimaryButton(title: "Login", isLoading: viewModel.isLoading) {
                    Task {
                        let didSucceed = await viewModel.login()
                        if didSucceed {
                            onAuthenticated()
                        }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 24)

                // Divider
                AuthDivider(label: "Or Sign in With")
                    .padding(.horizontal, 24)
                    .padding(.bottom, 24)

                // Google button
                AuthSocialButton(title: "Continue with Google", imageName: "google-logo") {}
                    .padding(.horizontal, 24)
                    .padding(.bottom, 40)

                // Bottom divider
                Rectangle()
                    .fill(Color.white.opacity(0.08))
                    .frame(height: 1)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 20)

                // Sign up link
                HStack(spacing: 4) {
                    Text("Don't have an account?")
                        .font(.custom("Jura-Regular", size: 14))
                        .foregroundColor(.white.opacity(0.5))
                    Button(action: onCreateAccount) {
                        Text("Create Account")
                            .font(.custom("Jura-SemiBold", size: 14))
                            .foregroundColor(Color(red: 0.25, green: 0.55, blue: 1.0))
                    }
                    .buttonStyle(.plain)
                }
                .padding(.bottom, 40)
            }
        }
        .onTapGesture { UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil) }
        .appBackground()
    }
}

#Preview {
    LoginView()
}
