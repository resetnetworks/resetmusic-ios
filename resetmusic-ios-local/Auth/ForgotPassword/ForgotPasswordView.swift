//
//  ForgotPasswordView.swift
//  resetmusic-ios-local
//
//  Created by Naushad Ali Khan on 12/03/26.
//


import SwiftUI

struct ForgotPasswordView: View {

    @State private var email: String = ""
    @State private var isLoading: Bool = false

    var onBackToLogin: () -> Void = {}

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
                    Text("forgot")
                        .font(.custom("Jura-Bold", size: 28))
                        .foregroundColor(Color(red: 0.25, green: 0.55, blue: 1.0))
                    Text(" your password?")
                        .font(.custom("Jura-Regular", size: 28))
                        .foregroundColor(.white)
                }
                .multilineTextAlignment(.center)
                .padding(.bottom, 12)

                Text("Enter your registered email and we'll\nsend you a reset link.")
                    .font(.custom("Jura-Regular", size: 14))
                    .foregroundColor(.white.opacity(0.45))
                    .multilineTextAlignment(.center)
                    .lineSpacing(5)
                    .padding(.bottom, 40)

                // Email field
                AuthTextField(
                    label: "email",
                    placeholder: "Enter your registered email",
                    icon: "envelope",
                    text: $email,
                    keyboardType: .emailAddress
                )
                .padding(.horizontal, 24)
                .padding(.bottom, 32)

                // Send Reset Link button
                AuthPrimaryButton(title: "Send Reset Link", isLoading: isLoading) {
                    isLoading = true
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 24)

                // Bottom divider
                Rectangle()
                    .fill(Color.white.opacity(0.08))
                    .frame(height: 1)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 20)

                // Back to login
                HStack(spacing: 4) {
                    Text("Remember your password?")
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
        }
        .onTapGesture { UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil) }
        .appBackground()
    }
}

#Preview {
    ForgotPasswordView()
}
