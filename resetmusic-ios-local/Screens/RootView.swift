//
//  RootView.swift
//  resetmusic-ios-local
//
//  Created by Naushad Ali Khan on 09/03/26.
//


import SwiftUI

struct RootView: View {
    @State private var selectedTab: AppTab = .home
    @StateObject private var playerVM = PlayerViewModel()
    @State private var navigationPath = NavigationPath()

    var body: some View {
        ZStack(alignment: .bottom) {

            Group {
                switch selectedTab {
                case .home:
                    NavigationStack(path: $navigationPath) {
                        HomeView()
                            .navigationDestination(for: FeaturedArtist.self) { artist in
                                if artist.profileImage != nil || artist.coverImage != nil || artist.bio != nil {
                                    ArtistDetailView(artist: artist)
                                } else {
                                    ArtistLoaderView(
                                        artistId: artist.id,
                                        artistName: artist.name
                                    )
                                }
                            }
                    }
                    .environmentObject(playerVM)

                case .artists:
                    NavigationStack { ArtistsView() }
                        .environmentObject(playerVM)

                case .search:
                    NavigationStack { SearchScreen() }
                        .environmentObject(playerVM)

//                case .library:
//                    NavigationStack { LibraryView() }
//                        .environmentObject(playerVM)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            if playerVM.currentTrack != nil {
                StickyPlayerBar(isFullPlayerPresented: $playerVM.isFullPlayerPresented)
                    .environmentObject(playerVM)
                    .id(playerVM.currentTrack?.songId)
                    .padding(.horizontal, 8)
                    .padding(.bottom, 90)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .zIndex(1)
            }

            CustomTabBar(selectedTab: $selectedTab)
                .zIndex(2)
        }
        .ignoresSafeArea(edges: .bottom)
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: playerVM.currentTrack != nil)
        .environmentObject(playerVM)
        .onChange(of: playerVM.isFullPlayerPresented) { _, isPresented in
            if isPresented {
                Task { await playerVM.resumeIfNeeded() }
            }
        }
        .fullScreenCover(isPresented: $playerVM.isFullPlayerPresented) {
            FullPlayerView(isPresented: $playerVM.isFullPlayerPresented) { artist in
                playerVM.isFullPlayerPresented = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                    selectedTab = .home
                    navigationPath.append(artist)
                }
            }
            .environmentObject(playerVM)
        }
    }
}

#Preview {
    RootView()
}
