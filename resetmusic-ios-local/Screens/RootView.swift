//
//  RootView.swift
//  resetmusic-ios-local
//
//  Created by Naushad Ali Khan on 09/03/26.
//


import SwiftUI

struct RootView: View {
    let currentUserName: String
    let onLogout: () async -> Void
    @State private var selectedTab: AppTab = .home
    @StateObject private var playerVM = PlayerViewModel()
    @State private var navigationPath = NavigationPath()
    @State private var isProfileDrawerOpen = false

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottomLeading) {

                Group {
                    switch selectedTab {
                    case .home:
                        NavigationStack(path: $navigationPath) {
                            HomeView(onProfileTap: { openProfileDrawer() })
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
                        NavigationStack { ArtistsView(onProfileTap: { openProfileDrawer() }) }
                            .environmentObject(playerVM)

                    case .search:
                        NavigationStack { SearchScreen(onProfileTap: { openProfileDrawer() }) }
                            .environmentObject(playerVM)

//                case .library:
//                    NavigationStack { LibraryView() }
//                        .environmentObject(playerVM)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .disabled(isProfileDrawerOpen)

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
                    .allowsHitTesting(!isProfileDrawerOpen)

                if isProfileDrawerOpen {
                    Color.black.opacity(0.45)
                        .ignoresSafeArea()
                        .contentShape(Rectangle())
                        .onTapGesture {
                            closeProfileDrawer()
                        }
                        .transition(.opacity)
                        .zIndex(3)

                    GuestModeDrawerView(
                        displayName: currentUserName,
                        onClose: closeProfileDrawer,
                        onLogout: {
                            closeProfileDrawer()
                            await onLogout()
                        }
                    )
                        .frame(width: min(geometry.size.width * 0.84, 360))
                        .frame(maxHeight: .infinity, alignment: .top)
                        .background(Color.clear)
                        .clipShape(
                            UnevenRoundedRectangle(
                                topLeadingRadius: 0,
                                bottomLeadingRadius: 0,
                                bottomTrailingRadius: 28,
                                topTrailingRadius: 28
                            )
                        )
                        .overlay(alignment: .trailing) {
                            Rectangle()
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            Color.white.opacity(0.12),
                                            Color.clear
                                        ],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .frame(width: 1)
                        }
                        .shadow(color: .black.opacity(0.35), radius: 30, x: 12, y: 0)
                        .transition(.move(edge: .leading).combined(with: .opacity))
                        .zIndex(4)
                }
            }
            .ignoresSafeArea(edges: .bottom)
            .animation(.spring(response: 0.4, dampingFraction: 0.8), value: playerVM.currentTrack != nil)
            .animation(.spring(response: 0.32, dampingFraction: 0.82), value: isProfileDrawerOpen)
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

    private func openProfileDrawer() {
        isProfileDrawerOpen = true
    }

    private func closeProfileDrawer() {
        isProfileDrawerOpen = false
    }
}

#Preview {
    RootView(currentUserName: "Guest", onLogout: {})
}
