//
//  LibraryView.swift
//  resetmusic-ios-local
//
//  Created by Naushad Ali Khan on 06/04/26.
//

import SwiftUI
import Kingfisher
// ─────────────────────────────────────────────
// MARK: - Library View (Main Screen)
// ─────────────────────────────────────────────

struct LibraryView: View {
    @EnvironmentObject var playerVM: PlayerViewModel
    @StateObject private var vm = LibraryViewModel()
    var onProfileTap: () -> Void = {}
    
    // 🔥 Search State
     @State private var showSearch = false
     @State private var searchText = ""
     @FocusState private var isSearchFocused: Bool

    var body: some View {
        VStack(spacing: 0) {

            AppTopBar(
                mode: .library(
                    title: "Library",
                    onSearch: {
                        withAnimation(.easeInOut(duration: 0.25)) {
                            showSearch.toggle() // 🔥 FIX
                        }

                        if showSearch {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                isSearchFocused = true
                            }
                        } else {
                            isSearchFocused = false // 🔥 dismiss keyboard when hiding
                        }
                    },
                    onAdd: {
                        vm.showCreateSheet = true
                    }
                ),
                onProfileTap: onProfileTap
            )
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 16) {
                    
                
                    // 🔥 Animated Search Field
                    if showSearch {
                        HStack {
                            SearchField(text: $searchText,
                                        placeholderText: "Search from your music")
                                .focused($isSearchFocused)
                        }
                        .padding(.horizontal, 12)
                        .transition(.move(edge: .top).combined(with: .opacity))
                    }
                    
                    
                    LikedSongsSection(item: vm.likedSongs)
                    FavoriteArtistsSection(
                        artists: vm.artists,
                        subscribedArtists: vm.subscribedArtists
                    )
                    YourPlaylistsSection(
                        playlists: $vm.playlists,
                        onToggleLike: vm.togglePlaylistLike,
                        onCreateNew: { vm.showCreateSheet = true },
                        onDelete: vm.deletePlaylist
                    )
                }
                .padding(.vertical, 24)
                .padding(.bottom, 100)
            }
        }
        .appBackground()
        .onTapGesture {
            isSearchFocused = false
            
            if showSearch {
                withAnimation(.easeInOut(duration: 0.2)) {
                    showSearch = false
                }
            }
        }
        .sheet(isPresented: $vm.showCreateSheet) {
            CreatePlaylistSheet(isPresented: $vm.showCreateSheet) { name in
                vm.createPlaylist(name: name)
            }
        }
    }
}

// ─────────────────────────────────────────────
// MARK: - Section: Liked Songs
// ─────────────────────────────────────────────

private struct LikedSongsSection: View {
    let item: LikedSongsItem

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionBanner(title: "liked songs")

            LikedSongsCard(
                item: item,
                // Swap nil → real URL once API returns latest liked song cover
                latestCoverURL: nil
            )
            .padding(.horizontal, 16)
        }
    }
}

// ─────────────────────────────────────────────
// MARK: - Artist Filter Chip
// ─────────────────────────────────────────────

/// Filter type for the artists section
enum ArtistFilter: String, CaseIterable {
    case subscribed = "subscribed"
    case favourites = "favourites"
}

/// Single pill chip — filled blue when selected, outlined when not
private struct ArtistFilterChip: View {
    let filter: ArtistFilter
    let isSelected: Bool
    var onTap: () -> Void = {}

    var body: some View {
        Button(action: onTap) {
            Text(filter.rawValue)
                .font(.custom("Jura-SemiBold", size: 12))
                .foregroundColor(isSelected ? .white : Color.white.opacity(0.45))
                .kerning(0.5)
                .padding(.horizontal, 14)
                .padding(.vertical, 7)
                .background(
                    Capsule()
                        .fill(isSelected
                              ? Color(hex: "1A5DB4")
                              : Color.white.opacity(0.06))
                        .overlay(
                            Capsule()
                                .stroke(
                                    isSelected
                                        ? Color(hex: "3B82F6").opacity(0.6)
                                        : Color.white.opacity(0.12),
                                    lineWidth: 1
                                )
                        )
                )
        }
        .buttonStyle(.plain)
        .animation(.easeInOut(duration: 0.18), value: isSelected)
    }
}

// ─────────────────────────────────────────────
// MARK: - Section: Favorite Artists
// ─────────────────────────────────────────────

private struct FavoriteArtistsSection: View {
    let artists: [FavoriteArtist]          // favourited/wishlisted
    let subscribedArtists: [FavoriteArtist] // subscribed
    var onSeeAll: () -> Void = {}

    @State private var selectedFilter: ArtistFilter = .subscribed

    private var displayedArtists: [FavoriteArtist] {
        switch selectedFilter {
        case .subscribed: return subscribedArtists
        case .favourites: return artists
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {

            // ── Header: title + See All ──
            HStack {
                SectionBanner(title: "your artists")
                Spacer()
                ViewAllButton(action: onSeeAll)
                    .padding(.trailing, 16)
            }

            // ── Filter chips ──
            HStack(spacing: 8) {
                ForEach(ArtistFilter.allCases, id: \.self) { filter in
                    ArtistFilterChip(
                        filter: filter,
                        isSelected: selectedFilter == filter,
                        onTap: { selectedFilter = filter }
                    )
                }
            }
            .padding(.horizontal, 16)

            // ── Artist cards ──
            if displayedArtists.isEmpty {
                Text(selectedFilter == .subscribed
                     ? "no subscriptions yet"
                     : "no favourites yet")
                    .font(.custom("Jura-Regular", size: 13))
                    .foregroundColor(.white.opacity(0.3))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(displayedArtists) { artist in
                            FeaturedArtistCard(artist: artist.asFeaturedArtist)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                }
                .transition(.opacity.combined(with: .move(edge: .leading)))
                .animation(.easeInOut(duration: 0.2), value: selectedFilter)
            }
        }
    }
}

// ─────────────────────────────────────────────
// MARK: - Section: Your Playlists
// ─────────────────────────────────────────────

private struct YourPlaylistsSection: View {
    @Binding var playlists: [UserPlaylist]
    var onToggleLike: (UUID) -> Void = { _ in }
    var onCreateNew: () -> Void = {}
    var onDelete: (UUID) -> Void = { _ in }
    var onSeeAll: () -> Void = {}

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                SectionBanner(title: "your playlists")
                Spacer()
                ViewAllButton(action: onSeeAll)
                    .padding(.trailing, 16)
            }

            VStack(spacing: 8) {
                ForEach(Array(playlists.enumerated()), id: \.element.id) { index, playlist in
                    PlaylistRowCell(
                        playlist: playlist,
//                        isLiked: Binding(
//                            get: { playlists[index].isLiked },
//                            set: { _ in onToggleLike(playlist.id) }
//                        )
                    )
                    .contextMenu {
                        Button(role: .destructive) {
                            onDelete(playlist.id)
                        } label: {
                            Label("Delete Playlist", systemImage: "trash")
                        }
                    }
                }

                CreatePlaylistRow(action: onCreateNew)
            }
            .padding(.horizontal, 16)
        }
    }
}

// ─────────────────────────────────────────────
// MARK: - FavoriteArtist → FeaturedArtist bridge
// ─────────────────────────────────────────────
// Converts your local FavoriteArtist model into FeaturedArtist so the
// shared FeaturedArtistCard component works with zero modifications.

private extension FavoriteArtist {
    var asFeaturedArtist: FeaturedArtist {
        FeaturedArtist(
            id: id.uuidString,
            name: name,
            slug: name.lowercased().replacingOccurrences(of: " ", with: "-"),
            bio: nil,
            location: nil,
            country: nil,
            profileImage: imageURL,
            coverImage: nil,
            subscriptionPlans: [],
            isMonetizationComplete: false,
            songCount: 0,
            albumCount: 0,
            createdAt: "",
            updatedAt: ""
        )
    }
}

// ─────────────────────────────────────────────
// MARK: - Preview
// ─────────────────────────────────────────────

#Preview {
    LibraryView()
        .environmentObject({
            let vm = PlayerViewModel()
            vm.currentTrack = PlayerTrack(
                title: "Our Afternoon (Live 8-...)",
                artistName: "Akira Film Script",
                artistId: "", // added mock artist id
                coverImage: ""
            )
            vm.isPlaying = true
            return vm
        }())
}

#Preview("Empty Library") {
    LibraryView()
        .environmentObject(PlayerViewModel())
}
