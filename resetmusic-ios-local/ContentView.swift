//
//  ContentView.swift
//  resetmusic-ios-local
//
//  Created by Naushad Ali Khan on 04/03/26.
//

import SwiftUI

struct ContentView: View {
    @State private var authScreen: AuthScreen = .welcome
    @State private var didCheckStoredSession = false
    @State private var currentUser: AuthUser?
    private let authRepository: AuthRepository = AuthRepositoryImpl(service: AuthService())

    private enum AuthScreen {
        case welcome
        case login
        case signup
        case forgotPassword  // ← new
        case app
    }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            if authScreen == .welcome {
                WelcomeView(
                    onLoginSignUp: {
                        withAnimation(.easeInOut(duration: 0.35)) { authScreen = .login }
                    },
                    onBrowseFirst: {
                        withAnimation(.easeInOut(duration: 0.6)) { authScreen = .app }
                    }
                )
                .transition(.opacity)

            } else if authScreen == .login {
                LoginView(
                    onCreateAccount: {
                        withAnimation(.easeInOut(duration: 0.35)) { authScreen = .signup }
                    },
                    onForgotPassword: {                              // ← wired
                        withAnimation(.easeInOut(duration: 0.35)) { authScreen = .forgotPassword }
                    },
                    onAuthenticated: {
                        currentUser = UserDefaultsManager.shared.loadCurrentUser()
                        withAnimation(.easeInOut(duration: 0.5)) { authScreen = .app }
                    }
                )
                .transition(.opacity)

            } else if authScreen == .signup {
                SignUpView(
                    onLogin: {
                        withAnimation(.easeInOut(duration: 0.35)) { authScreen = .login }
                    },
                    onAuthenticated: {
                        currentUser = UserDefaultsManager.shared.loadCurrentUser()
                        withAnimation(.easeInOut(duration: 0.5)) { authScreen = .app }
                    }
                )
                .transition(.opacity)

            } else if authScreen == .forgotPassword {              // ← new screen
                ForgotPasswordView(
                    onBackToLogin: {
                        withAnimation(.easeInOut(duration: 0.35)) { authScreen = .login }
                    }
                )
                .transition(.opacity)

            } else {
                RootView(
                    currentUserName: currentUser?.name ?? "Guest",
                    onLogout: handleLogout
                )
                .transition(.opacity)
            }
        }
        .task {
            guard !didCheckStoredSession else { return }
            didCheckStoredSession = true
            if let token = try? KeychainManager.shared.loadAuthToken(), !token.isEmpty {
                currentUser = UserDefaultsManager.shared.loadCurrentUser()
                authScreen = .app
            }
        }
    }

    @MainActor
    private func handleLogout() async {
        do {
            try await authRepository.logout()
        } catch {
            // Local session still cleared in repository's defer block
        }
        currentUser = nil
        withAnimation(.easeInOut(duration: 0.4)) { authScreen = .welcome }
    }
}

#Preview {
    ContentView()
}
