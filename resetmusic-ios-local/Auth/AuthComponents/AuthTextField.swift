//
//  AuthTextField.swift
//  resetmusic-ios-local
//
//  Created by Naushad Ali Khan on 12/03/26.
//


import SwiftUI

struct AuthTextField: View {
    let label: String
    let placeholder: String
    let icon: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    var isSecure: Bool = false
    @State private var isVisible: Bool = false
    @FocusState private var isFocused: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(.custom("Jura-Regular", size: 13))
                .foregroundColor(.white.opacity(0.55))
                .tracking(0.5)

            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 15))
                    .foregroundColor(isFocused
                        ? Color(red: 0.25, green: 0.55, blue: 1.0)
                        : .white.opacity(0.35))
                    .frame(width: 20)
                    .animation(.easeInOut(duration: 0.2), value: isFocused)

                ZStack(alignment: .leading) {
                    // Custom placeholder
                    if text.isEmpty {
                        Text(placeholder)
                            .font(.custom("Jura-Regular", size: 15))
                            .foregroundColor(.white.opacity(0.3))
                    }

                    if isSecure && !isVisible {
                        SecureField("", text: $text)
                            .font(.custom("Jura-Regular", size: 15))
                            .foregroundColor(.white)
                            .tint(Color(red: 0.25, green: 0.55, blue: 1.0))
                            .focused($isFocused)
                    } else {
                        TextField("", text: $text)
                            .font(.custom("Jura-Regular", size: 15))
                            .foregroundColor(.white)
                            .keyboardType(keyboardType)
                            .autocapitalization(.none)
                            .tint(Color(red: 0.25, green: 0.55, blue: 1.0))
                            .focused($isFocused)
                    }
                }

                if isSecure {
                    Button(action: { isVisible.toggle() }) {
                        Image(systemName: isVisible ? "eye" : "eye.slash")
                            .font(.system(size: 14))
                            .foregroundColor(.white.opacity(0.35))
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(Color(red: 0.08, green: 0.10, blue: 0.18))
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(
                        isFocused
                            ? Color(red: 0.25, green: 0.55, blue: 1.0)
                            : Color.white.opacity(0.1),
                        lineWidth: isFocused ? 1.5 : 1
                    )
                    .animation(.easeInOut(duration: 0.2), value: isFocused)
            )
        }
    }
}


// MARK: - Preview

#Preview {
    ZStack {
        Color(red: 0.01, green: 0.05, blue: 0.15).ignoresSafeArea()
        VStack(spacing: 20) {
            AuthTextField(
                label: "email",
                placeholder: "Enter your email",
                icon: "envelope",
                text: .constant(""),
                keyboardType: .emailAddress
            )
            AuthTextField(
                label: "email filled",
                placeholder: "Enter your email",
                icon: "envelope",
                text: .constant("test@email.com"),
                keyboardType: .emailAddress
            )
            AuthTextField(
                label: "password",
                placeholder: "Enter your password",
                icon: "lock",
                text: .constant(""),
                isSecure: true
            )
        }
        .padding(24)
    }
}
