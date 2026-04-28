//
//  AppTopBar.swift
//  resetmusic-ios-local
//
//  Created by Naushad Ali Khan on 09/03/26.
//


import SwiftUI

/// Reusable top bar for all screens
/// - Home mode:    avatar + greeting + name + bell
/// - Title mode:   leading title + bell
/// - Library mode: leading title + search + plus button
struct AppTopBar: View {

    enum Mode {
        case home(userName: String)
        case title(String, onSearch: (() -> Void)? = nil)
        case library(title: String = "library", onSearch: () -> Void = {}, onAdd: () -> Void)
    }

    let mode: Mode

    var body: some View {
        HStack(spacing: 16) {
            switch mode {

            // ── Home ──────────────────────────────────
            case .home(let userName):
                profileAvatar(userName: userName)

                VStack(alignment: .leading, spacing: 2) {
                    Text(GreetingHelper.greeting)
                        .font(.custom("Jura-Regular", size: 14))
                        .foregroundColor(.white.opacity(0.6))
                    Text(userName)
                        .font(.custom("Jura-SemiBold", size: 18))
                        .foregroundColor(.blue)
                }

                Spacer()

                Button(action: {}) {
                    Image(systemName: "bell")
                        .font(.system(size: 22))
                        .foregroundColor(.gray)
                }
                .buttonStyle(.plain)

            // ── Title ─────────────────────────────────
            case .title(let title, let onSearch):
                profileAvatar(userName: "Naushad")

                Text(title)
                    .font(.custom("Jura-Bold", size: 20))
                    .foregroundColor(.blue)

                Spacer()

                HStack(spacing: 18) {
                    if let onSearch {
                        Button(action: onSearch) {
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 22, weight: .medium))
                                .foregroundColor(.gray)
                        }
                        .buttonStyle(.plain)
                    }

                    Button(action: {}) {
                        Image(systemName: "bell")
                            .font(.system(size: 22))
                            .foregroundColor(.gray)
                    }
                }
                .buttonStyle(.plain)

            // ── Library ───────────────────────────────
            case .library(let title, let onSearch, let onAdd):
                profileAvatar(userName: "Naushad")

                Text(title)
                    .font(.custom("Jura-Bold", size: 20))
                    .foregroundColor(.blue)

                Spacer()

                HStack(spacing: 18) {
                    // 🔍 Search Button
                    Button(action: onSearch) {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 22, weight: .medium))
                            .foregroundColor(.gray)
                    }
                    .buttonStyle(.plain)

                    // ➕ Add Button
                    Button(action: onAdd) {
                        Image(systemName: "plus")
                            .font(.system(size: 26, weight: .medium))
                            .foregroundColor(.gray)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 8)
    }

    private func profileAvatar(userName: String) -> some View {
        ZStack {
            Circle()
                .fill(Color(red: 0.6, green: 0.4, blue: 0.1))
                .frame(width: 38, height: 38)

            Text(String(userName.prefix(1)).uppercased())
                .font(.system(size: 15, weight: .bold))
                .foregroundColor(.white)
        }
    }
}

// ─────────────────────────────────────────────
// MARK: - Preview
// ─────────────────────────────────────────────

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        VStack(spacing: 0) {
            AppTopBar(mode: .home(userName: "Naushad"))
            Divider().overlay(Color.white.opacity(0.1))
            AppTopBar(mode: .title("Artists"))
            Divider().overlay(Color.white.opacity(0.1))
            AppTopBar(mode: .library(onSearch: {}, onAdd: {}))
            Spacer()
        }
        .padding(.top, 8)
    }
}
