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

    // ✅ 3 columns
    let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    var body: some View {
        VStack(spacing: 0) {
            AppTopBar(mode: .title("Artists"))

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
                        // 🔹 Content
                        if viewModel.artists.isEmpty && viewModel.isLoading {
                            LazyVGrid(columns: columns, spacing: 20) {
                                ForEach(0..<9, id: \.self) { _ in
                                    skeletonCard
                                }
                            }
                            .padding(.horizontal, 16)
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
}

#Preview {
    NavigationStack { ArtistsView() }
}
