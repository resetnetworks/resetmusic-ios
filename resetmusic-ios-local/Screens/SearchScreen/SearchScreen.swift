//
//  SearchScreen.swift
//  resetmusic-ios-local
//
//  Created by Naushad Ali Khan on 09/03/26.
//


import SwiftUI
import Kingfisher

struct SearchScreen: View {
    @StateObject private var viewModel = SearchViewModel()
    @State private var searchText = ""
    @State private var searchTask: Task<Void, Never>?
    @FocusState private var isSearchFocused: Bool
    @EnvironmentObject private var playerVM: PlayerViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {

            AppTopBar(mode: .title("Search"))

            VStack(alignment: .leading, spacing: 16) {
                SearchField(text: $searchText, placeholderText: "Search artist, album or song")
                    .padding(.horizontal, 16)
                    .focused($isSearchFocused)

                searchContent
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
                await viewModel.search(query: newValue)
            }
        }
        .onDisappear {
            searchTask?.cancel()
        }
    }
}

#Preview {
    NavigationStack {
        SearchScreen()
            .environmentObject(PlayerViewModel())
    }
}

private extension SearchScreen {

    var searchContent: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 24) {
                if viewModel.isLoading && !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    loadingState
                } else if let errorMessage = viewModel.errorMessage {
                    messageState(
                        title: "Search failed",
                        message: errorMessage,
                        systemImage: "exclamationmark.circle"
                    )
                } else if !viewModel.hasSearched {
                    messageState(
                        title: "Search artists, albums, and songs",
                        message: "Start typing to explore the catalog.",
                        systemImage: "magnifyingglass"
                    )
                } else if viewModel.results.artists.isEmpty,
                          viewModel.results.songs.isEmpty,
                          viewModel.results.albums.isEmpty {
                    messageState(
                        title: "No results",
                        message: "Try a different keyword or artist name.",
                        systemImage: "waveform.circle"
                    )
                } else {
                    if !viewModel.results.artists.isEmpty {
                        SearchSection(title: "Artists", count: viewModel.results.artists.count) {
                            VStack(spacing: 12) {
                                ForEach(viewModel.results.artists) { artist in
                                    NavigationLink {
                                        ArtistLoaderView(artistId: artist.id, artistName: artist.name)
                                    } label: {
                                        SearchArtistRow(artist: artist)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                    }

                    if !viewModel.results.songs.isEmpty {
                        SearchSection(title: "Tracks", count: viewModel.results.songs.count) {
                            VStack(spacing: 0) {
                                ForEach(viewModel.results.songs) { song in
                                    TrackRow(
                                        song: song,
                                        isCurrentTrack: playerVM.currentTrack?.songId == song.id,
                                        isPlaying: playerVM.currentTrack?.songId == song.id && playerVM.isPlaying,
                                        onPlay: {
                                            Task {
                                                await playerVM.play(song: song, queue: viewModel.results.songs)
                                            }
                                        }
                                    )
                                }
                            }
                            .background(Color.white.opacity(0.03))
                            .clipShape(RoundedRectangle(cornerRadius: 18))
                            .overlay(
                                RoundedRectangle(cornerRadius: 18)
                                    .stroke(Color.white.opacity(0.06), lineWidth: 1)
                            )
                        }
                    }

                    if !viewModel.results.albums.isEmpty {
                        SearchSection(title: "Albums", count: viewModel.results.albums.count) {
                            VStack(spacing: 12) {
                                ForEach(viewModel.results.albums) { album in
                                    NavigationLink {
                                        AlbumDetailView(album: album)
                                    } label: {
                                        SearchAlbumRow(album: album)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 120)
        }
    }

    var loadingState: some View {
        VStack(spacing: 16) {
            ProgressView()
                .tint(.white)
            Text("Searching...")
                .font(.custom("Jura-Regular", size: 14))
                .foregroundColor(.white.opacity(0.6))
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 80)
    }

    func messageState(title: String, message: String, systemImage: String) -> some View {
        VStack(spacing: 14) {
            Image(systemName: systemImage)
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
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 24)
        .padding(.top, 80)
    }
}

private struct SearchSection<Content: View>: View {
    let title: String
    let count: Int
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text(title)
                    .font(.custom("Jura-Bold", size: 22))
                    .foregroundColor(.white)

                Text("\(count)")
                    .font(.custom("Jura-SemiBold", size: 12))
                    .foregroundColor(Color(red: 0.25, green: 0.55, blue: 1.0))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Color(red: 0.25, green: 0.55, blue: 1.0).opacity(0.12))
                    .clipShape(Capsule())

                Spacer()
            }

            content
        }
    }
}

private struct SearchArtistRow: View {
    let artist: FeaturedArtist

    var body: some View {
        HStack(spacing: 14) {
            KFImage(URL(string: artist.profileImage ?? artist.coverImage ?? ""))
                .placeholder {
                    Circle()
                        .fill(Color.white.opacity(0.08))
                }
                .resizable()
                .scaledToFill()
                .frame(width: 58, height: 58)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(Color.white.opacity(0.08), lineWidth: 1)
                )

            VStack(alignment: .leading, spacing: 4) {
                Text(artist.name)
                    .font(.custom("Jura-SemiBold", size: 16))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Text(artist.locationText)
                    .font(.custom("Jura-Regular", size: 13))
                    .foregroundColor(.white.opacity(0.55))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            Image(systemName: "chevron.right")
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.white.opacity(0.35))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(Color.white.opacity(0.03))
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(Color.white.opacity(0.06), lineWidth: 1)
        )
    }
}

private struct SearchAlbumRow: View {
    let album: Album

    var body: some View {
        HStack(spacing: 14) {
            KFImage(URL(string: album.coverImage ?? ""))
                .placeholder {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white.opacity(0.08))
                }
                .resizable()
                .scaledToFill()
                .frame(width: 64, height: 64)
                .clipShape(RoundedRectangle(cornerRadius: 12))

            VStack(alignment: .leading, spacing: 4) {
                Text(album.title)
                    .font(.custom("Jura-SemiBold", size: 16))
                    .foregroundColor(.white)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Text(album.artist.name)
                    .font(.custom("Jura-Regular", size: 13))
                    .foregroundColor(.white.opacity(0.55))
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            Image(systemName: "chevron.right")
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.white.opacity(0.35))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(Color.white.opacity(0.03))
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(Color.white.opacity(0.06), lineWidth: 1)
        )
    }
}

private extension FeaturedArtist {
    var locationText: String {
        let parts: [String] = [location, country]
            .compactMap { $0 }
            .filter { !$0.isEmpty }

        return parts.isEmpty ? "Artist" : parts.joined(separator: ", ")
    }
}
