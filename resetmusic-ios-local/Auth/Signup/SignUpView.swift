//
//  SignUpView.swift
//  resetmusic-ios-local
//
//  Created by Naushad Ali Khan on 12/03/26.
//


import SwiftUI

struct SignUpView: View {

    @State private var name: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isLoading: Bool = false

    var onLogin: () -> Void = {}

    private var passwordHints: [(String, Bool)] {
        [
            ("At least 8 characters", password.count >= 8),
            ("Lowercase",             password.range(of: "[a-z]", options: .regularExpression) != nil),
            ("Uppercase",             password.range(of: "[A-Z]", options: .regularExpression) != nil),
            ("Number",                password.range(of: "[0-9]", options: .regularExpression) != nil),
            ("Symbol",                password.range(of: "[^a-zA-Z0-9]", options: .regularExpression) != nil)
        ]
    }

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
                    Text("sign up")
                        .font(.custom("Jura-Bold", size: 28))
                        .foregroundColor(Color(red: 0.25, green: 0.55, blue: 1.0))
                    Text(", to musicreset")
                        .font(.custom("Jura-Regular", size: 28))
                        .foregroundColor(.white)
                }
                .padding(.bottom, 40)

                // Form
                VStack(spacing: 20) {
                    AuthTextField(
                        label: "name",
                        placeholder: "Your name",
                        icon: "person.circle",
                        text: $name
                    )

                    AuthTextField(
                        label: "email",
                        placeholder: "your@email.com",
                        icon: "envelope",
                        text: $email,
                        keyboardType: .emailAddress
                    )

                    VStack(alignment: .leading, spacing: 8) {
                        AuthTextField(
                            label: "password",
                            placeholder: "Create a strong password",
                            icon: "lock",
                            text: $password,
                            isSecure: true
                        )

                        // Password validation hints — only shown while typing
                        if !password.isEmpty {
                            HStack(spacing: 0) {
                                ForEach(Array(passwordHints.enumerated()), id: \.offset) { index, item in
                                    Text(item.0)
                                        .font(.custom("Jura-Regular", size: 11))
                                        .foregroundColor(item.1
                                            ? Color(red: 0.25, green: 0.55, blue: 1.0)
                                            : Color(red: 0.85, green: 0.3, blue: 0.3))
                                    if index < passwordHints.count - 1 {
                                        Text(" · ")
                                            .font(.system(size: 11))
                                            .foregroundColor(.white.opacity(0.25))
                                    }
                                }
                            }
                            .padding(.horizontal, 4)
                        }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 32)

                // Create Account button
                AuthPrimaryButton(title: "Create Account", isLoading: isLoading) {
                    isLoading = true
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
                .padding(.top, 20)

                // Divider
                AuthDivider(label: "Or Sign up With")
                    .padding(.horizontal, 24)
                    .padding(.bottom, 24)

                // Google button
                AuthSocialButton(title: "Continue with Google", imageName: "google-logo") {}
                    .padding(.horizontal, 24)
                    .padding(.bottom, 40)

                // Divider bottom
                Rectangle()
                    .fill(Color.white.opacity(0.08))
                    .frame(height: 1)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 20)

                // Login link
                HStack(spacing: 4) {
                    Text("Already have an account?")
                        .font(.custom("Jura-Regular", size: 14))
                        .foregroundColor(.white.opacity(0.5))
                    Button(action: onLogin) {
                        Text("Login")
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
    SignUpView()
}
