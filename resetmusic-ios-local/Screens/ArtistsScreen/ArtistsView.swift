//
//  ArtistsView.swift
//  resetmusic-ios-local
//
//  Created by Naushad Ali Khan on 09/03/26.
//

import SwiftUI

struct ArtistsView: View {
    @StateObject private var viewModel = ArtistViewModel()
    @State private var selectedArtist: FeaturedArtist? = nil
    @State private var searchText: String = ""
    @State private var searchTask: Task<Void, Never>?
    @FocusState private var isSearchFocused: Bool
    var onProfileTap: () -> Void = {}

    // ✅ 3 columns
    let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    private var trimmedSearchText: String {
        searchText.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var isSearching: Bool {
        !trimmedSearchText.isEmpty
    }

    var body: some View {
        VStack(spacing: 0) {
            AppTopBar(mode: .title("Artists", showsBell: false), onProfileTap: onProfileTap)

            VStack(alignment: .leading, spacing: 16) {
                SearchField(
                    text: $searchText,
                    placeholderText: "Discover amazing artists"
                )
                .focused($isSearchFocused)
                .padding(.horizontal, 16)
                .padding(.bottom, 8)

                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 16) {
                        if isSearching && viewModel.isLoading {
                            loadingState
                        } else if isSearching, let errorMessage = viewModel.errorMessage {
                            retryMessageState(
                                title: "Search failed",
                                message: artistErrorMessage(from: errorMessage),
                                buttonTitle: "Try Again"
                            ) {
                                Task {
                                    await viewModel.retryCurrentRequest()
                                }
                            }
                        } else if isSearching && viewModel.artists.isEmpty {
                            messageState(
                                title: "No artists found",
                                message: "Try a different artist name or keyword."
                            )
                        } else if viewModel.artists.isEmpty && viewModel.isLoading {
                            LazyVGrid(columns: columns, spacing: 20) {
                                ForEach(0..<9, id: \.self) { _ in
                                    skeletonCard
                                }
                            }
                            .padding(.horizontal, 16)
                        } else if let errorMessage = viewModel.errorMessage {
                            retryMessageState(
                                title: "Couldn't load artists",
                                message: artistErrorMessage(from: errorMessage),
                                buttonTitle: "Try Again"
                            ) {
                                Task {
                                    await viewModel.retryCurrentRequest()
                                }
                            }
                        } else {
                            LazyVGrid(columns: columns, spacing: 20) {
                                ForEach(viewModel.artists) { artist in
                                    ArtistSubscribeCard(
                                        name: artist.name,
                                        imageURL: artist.profileImage,
                                        onTap: { selectedArtist = artist }
                                    )
                                }
                            }
                            .padding(.horizontal, 16)

                            if viewModel.isLoading {
                                ProgressView()
                                    .tint(Color.white.opacity(0.4))
                                    .padding(.vertical, 16)
                            }
                        }
                    }
                    .padding(.bottom, 100)
                }
            }
            .padding(.top, 20)
        }
        .appBackground()
        .onTapGesture {
            isSearchFocused = false
        }
        .onChange(of: searchText) { _, newValue in
            searchTask?.cancel()
            searchTask = Task {
                try? await Task.sleep(nanoseconds: 350_000_000)
                guard !Task.isCancelled else { return }
                await viewModel.searchArtists(query: newValue)
            }
        }
        .navigationDestination(item: $selectedArtist) { artist in
            ArtistDetailView(artist: artist)
        }
        .task {
            await viewModel.loadArtists()
        }
        .onDisappear {
            searchTask?.cancel()
        }
    }

    // 🔹 Skeleton (optional adjust later for circle)
    private var skeletonCard: some View {
        VStack(spacing: 8) {
            Circle()
                .fill(Color.white.opacity(0.06))
                .frame(height: 100)

            RoundedRectangle(cornerRadius: 4)
                .fill(Color.white.opacity(0.06))
                .frame(width: 60, height: 10)
        }
        .frame(maxWidth: .infinity)
    }

    private var loadingState: some View {
        VStack(spacing: 16) {
            ProgressView()
                .tint(.white)

            Text("Searching artists...")
                .font(.custom("Jura-Regular", size: 14))
                .foregroundColor(.white.opacity(0.6))
        }
        .frame(maxWidth: .infinity, minHeight: 320)
    }

    private func messageState(title: String, message: String) -> some View {
        VStack(spacing: 14) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 28))
                .foregroundColor(Color(red: 0.25, green: 0.55, blue: 1.0).opacity(0.8))

            Text(title)
                .font(.custom("Jura-SemiBold", size: 18))
                .foregroundColor(.white)

            Text(message)
                .font(.custom("Jura-Regular", size: 14))
                .foregroundColor(.white.opacity(0.55))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, minHeight: 320)
        .padding(.horizontal, 24)
    }

    private func retryMessageState(
        title: String,
        message: String,
        buttonTitle: String,
        action: @escaping () -> Void
    ) -> some View {
        VStack(spacing: 14) {
            Image(systemName: "exclamationmark.circle")
                .font(.system(size: 28))
                .foregroundColor(Color(red: 0.25, green: 0.55, blue: 1.0).opacity(0.8))

            Text(title)
                .font(.custom("Jura-SemiBold", size: 18))
                .foregroundColor(.white)

            Text(message)
                .font(.custom("Jura-Regular", size: 14))
                .foregroundColor(.white.opacity(0.55))
                .multilineTextAlignment(.center)

            Button(action: action) {
                Text(buttonTitle)
                    .font(.custom("Jura-SemiBold", size: 14))
                    .foregroundColor(.white)
                    .padding(.horizontal, 18)
                    .padding(.vertical, 10)
                    .background(Color(red: 0.25, green: 0.55, blue: 1.0))
                    .clipShape(Capsule())
            }
            .padding(.top, 4)
        }
        .frame(maxWidth: .infinity, minHeight: 320)
        .padding(.horizontal, 24)
    }

    private func artistErrorMessage(from errorMessage: String) -> String {
        let lowered = errorMessage.lowercased()
        if lowered.contains("internet") || lowered.contains("offline") || lowered.contains("network") {
            return "Check your connection and try again."
        }

        return "Something went wrong. Try again."
    }
}

#Preview {
    NavigationStack { ArtistsView() }
}
