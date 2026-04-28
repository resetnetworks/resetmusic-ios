//
//  AlbumDetailView.swift
//  resetmusic-ios-local
//
//  Created by Naushad Ali Khan on 07/03/26.
//


import SwiftUI
import Kingfisher
import Combine

struct AlbumDetailView: View {

    let album: Album

    @StateObject private var viewModel = AlbumDetailViewModel()
    @EnvironmentObject private var playerVM: PlayerViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var scrollOffset: CGFloat = 0
    @State private var showUpgradeSheet: Bool = false
    @State private var showPlayerMoreSheet: Bool = false
    @State private var selectedSongForMoreSheet: Song?
    
    private var showNavPlayButton: Bool {
        scrollOffset > 380
    }
    @State private var playButtonMinY: CGFloat = 0
    
//    @State private var animateNavPlay = false
    private var isThisAlbumPlaying: Bool {
        playerVM.isCurrentAlbum(viewModel.songs)
    }

    private var coverSize: CGFloat {
        let maxSize: CGFloat = 280
        let minSize: CGFloat = 160
        let progress = Swift.min(Swift.max(scrollOffset / 300, 0), 1)
        return maxSize - (maxSize - minSize) * progress
    }

    private var titleFontSize: CGFloat {
        let maxFont: CGFloat = 20
        let minFont: CGFloat = 12
        let progress = Swift.min(Swift.max(scrollOffset / 300, 0), 1)
        return maxFont - (maxFont - minFont) * progress
    }

    private var infoOpacity: Double {
        Double(Swift.min(Swift.max(1 - scrollOffset / 200, 0), 1))
    }

    private var navTitleOpacity: Double {
        Double(Swift.min(Swift.max((scrollOffset - 180) / 100, 0), 1))
    }

    var body: some View {
        GeometryReader { outer in
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {

                    GeometryReader { inner in
                        Color.clear
                            .onChange(of: inner.frame(in: .global).minY) { _, minY in
                                let top = outer.frame(in: .global).minY
                                scrollOffset = Swift.max(top - minY, 0)
                            }
                    }
                    .frame(height: 0)

                    coverSection
                    infoSection
                    actionSection
                    tracklistSection
                    aboutSection
                }
            }
        }
        .appBackground()
        .task { await viewModel.loadSongs(albumId: album.id) }
        .navigationBarBackButtonHidden(true)
        .animation(.spring(response: 0.35, dampingFraction: 0.8), value: showNavPlayButton)

        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }) {
                    ZStack {
                        Circle()
                            .fill(Color(red: 0.08, green: 0.09, blue: 0.12))
                            .frame(width: 44, height: 44)

                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                    }
                    .contentShape(Circle())
                }
                .buttonStyle(.plain)
            }

            ToolbarItem(placement: .principal) {
                HStack(spacing: 6) {

                    Text(album.title)
                        .font(.custom("Jura-SemiBold", size: 14))
                        .foregroundColor(.white.opacity(navTitleOpacity))
                        .lineLimit(1)
                        .truncationMode(.tail)
                        .frame(
                            maxWidth: showNavPlayButton ? 200 : .infinity,
                            alignment: .leading
                        )
                        .scaleEffect(showNavPlayButton ? 0.92 : 1.0)
                        .offset(x: showNavPlayButton ? -8 : 0)
                        .animation(.spring(response: 0.4, dampingFraction: 0.75), value: showNavPlayButton)

                    // 👇 ALWAYS present
                    navPlayButton
                        .scaleEffect(showNavPlayButton ? 1.0 : 0.6)
                        .opacity(showNavPlayButton ? 1 : 0)
                        .offset(x: showNavPlayButton ? 0 : 30)
                        .allowsHitTesting(showNavPlayButton)
                        .animation(.spring(response: 0.45, dampingFraction: 0.6), value: showNavPlayButton)
                }
            }        }
        .toolbarBackground(.hidden, for: .navigationBar)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showUpgradeSheet) {
            AlbumUpgradeSheetView(album: album)
                .presentationDetents([.height(480)])
                .presentationDragIndicator(.visible)
        }
        .sheet(isPresented: $showPlayerMoreSheet, onDismiss: {
            selectedSongForMoreSheet = nil
        }) {
            PlayerMoreSheetView(track: selectedSongForMoreSheet.map(playerTrack(from:)))
                .environmentObject(playerVM)
                .presentationDetents([.height(420)])
                .presentationDragIndicator(.visible)
        }
    }

    
    // MARK: - navplaybutton
    private var navPlayButton: some View {
        Button(action: {
            Task {
                if isThisAlbumPlaying {
                    playerVM.togglePlayPause()
                } else {
                    await playerVM.playAlbum(viewModel.songs)
                }
            }
        }) {
            let showPause = isThisAlbumPlaying && playerVM.isPlaying

            ZStack {
                Circle()
                    .fill(Color(red: 0.25, green: 0.55, blue: 1.0))
                    .frame(width: 48, height: 48)

                Image(systemName: showPause ? "pause.fill" : "play.fill")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
            }
        }        .buttonStyle(.plain)
    }
    // MARK: - Cover Section

    private var coverSection: some View {
        HStack {
            Spacer()
            ZStack(alignment: .bottom) {

                KFImage(URL(string: album.coverImage ?? ""))
                    .placeholder {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(red: 0.1, green: 0.12, blue: 0.2))
                    }
                    .resizable()
                    .scaledToFill()
                    .frame(width: coverSize, height: coverSize)
                    .clipShape(RoundedRectangle(cornerRadius: 16))

                LinearGradient(
                    stops: [
                        .init(color: .clear, location: 0.0),
                        .init(color: Color(red: 0.06, green: 0.08, blue: 0.24).opacity(0.65), location: 0.60),
                        .init(color: Color(red: 0.06, green: 0.26, blue: 0.79).opacity(0.95), location: 1.0)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .clipShape(RoundedRectangle(cornerRadius: 16))

                Text(album.title)
                    .font(.custom("Jura-Bold", size: titleFontSize))
                    .foregroundColor(.white)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 14)
            }
            .frame(width: coverSize, height: coverSize)
            .animation(
                .spring(response: 0.5, dampingFraction: 0.85, blendDuration: 0.1),
                value: coverSize
            )
            Spacer()
        }
        .padding(.top, 4)
        .padding(.bottom, 32)
    }

    // MARK: - Info Section

    private var infoSection: some View {
        VStack(alignment: .leading, spacing: 10) {

            HStack(spacing: 6) {
                Text("album by ")
                    .font(.custom("Jura-Regular", size: 12))
                    .foregroundColor(.white.opacity(0.5))
                    .tracking(2)

                Text(album.artist.name)
                    .font(.custom("Jura-SemiBold", size: 14))
                    .foregroundColor(.white.opacity(0.8))
            }

            if !album.genre.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 6) {
                        ForEach(album.genre, id: \.self) { tag in
                            Text("#\(tag)")
                                .font(.custom("Jura-Regular", size: 12))
                                .foregroundColor(Color(red: 0.25, green: 0.55, blue: 1.0))
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .background(Color(red: 0.25, green: 0.55, blue: 1.0).opacity(0.1))
                                .clipShape(Capsule())
                                .overlay(Capsule().stroke(Color(red: 0.25, green: 0.55, blue: 1.0).opacity(0.2), lineWidth: 1))
                        }
                    }
                }
            }

            HStack(spacing: 6) {
                if let releaseDate = album.releaseDate {
                    Text(formatDate(releaseDate))
                        .font(.custom("Jura-Regular", size: 12))
                        .foregroundColor(.white.opacity(0.5))
                    Text("·").foregroundColor(.white.opacity(0.3))
                }

                Text("\(viewModel.songs.count) songs")
                    .font(.custom("Jura-Regular", size: 12))
                    .foregroundColor(.white.opacity(0.5))

                if !viewModel.songs.isEmpty {
                    Text("·").foregroundColor(.white.opacity(0.3))
                    Text(totalDuration)
                        .font(.custom("Jura-Regular", size: 12))
                        .foregroundColor(.white.opacity(0.5))
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 24)
    }

    // MARK: - Action Section


    private var actionSection: some View {
        HStack(spacing: 16) {

            Button(action: { showUpgradeSheet = true }) {
                Text("Subscription")
                    .font(.custom("Jura-SemiBold", size: 15))
                    .foregroundColor(Color(red: 0.2, green: 0.5, blue: 1.0))
            }
            .buttonStyle(.plain)

            NavigationLink {
                if let artistId = album.artist.id, !artistId.isEmpty {
                    ArtistLoaderView(
                        artistId: artistId,
                        artistName: album.artist.name
                    )
                } else {
                    ArtistDetailView(artist: fallbackArtistFromAlbum)
                }
            } label: {
                Text("View Artist")
                    .font(.custom("Jura-SemiBold", size: 15))
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(Color(red: 0.2, green: 0.5, blue: 1.0))
//                    .background(
//                        RoundedRectangle(cornerRadius: 14)
//                            .fill(
//                                LinearGradient(
//                                    colors: [
//                                        Color(hex: "0F3272"),
//                                        Color(hex: "1A5DB4"),
//                                        Color(hex: "3B82F6")
//                                    ],
//                                    startPoint: .leading,
//                                    endPoint: .trailing
//                                )
//                            )
//                    )
                    .clipShape(Capsule())
            }
            .buttonStyle(.plain)

            Button(action: {}) {
                Image(systemName: "arrowshape.turn.up.right")
                    .font(.system(size: 16))
                    .foregroundColor(.white.opacity(0.7))
                    .frame(width: 40, height: 40)
                    .background(Color.white.opacity(0.08))
                    .clipShape(Circle())
                    .overlay(
                        Circle().stroke(Color.white.opacity(0.15), lineWidth: 1)
                    )
            }
            .buttonStyle(.plain)

            // 👇 THIS pushes play button to extreme right
           

            // 👇 Your Play/Pause Button
            Button(action: {
                Task {
                    if isThisAlbumPlaying {
                        playerVM.togglePlayPause()
                    } else {
                        await playerVM.playAlbum(viewModel.songs)
                    }
                }
            }) {
                let showPause = isThisAlbumPlaying && playerVM.isPlaying

                ZStack {
                    Circle()
                        .fill(Color(red: 0.25, green: 0.55, blue: 1.0))
                        .frame(width: 48, height: 48)

                    Image(systemName: showPause ? "pause.fill" : "play.fill")
                        .foregroundColor(.white)
                        .font(.system(size: 16, weight: .semibold))
                }
            }
            .background(
                GeometryReader { geo in
                    Color.clear
                        .onAppear {
                            playButtonMinY = geo.frame(in: .global).minY
                        }
                        .onChange(of: geo.frame(in: .global).minY) { _, newValue in
                            playButtonMinY = newValue
                        }
                }
            )
            .buttonStyle(.plain)
            .opacity(showNavPlayButton ? 0 : 1)
            .animation(.easeInOut(duration: 0.25), value: showNavPlayButton)

        }
        .padding(.horizontal, 16)
        .padding(.bottom, 32)
    }

    // MARK: - Tracklist Section

    private var tracklistSection: some View {
        VStack(alignment: .leading, spacing: 0) {

            Text("Tracklist")
                .font(.custom("Jura-Bold", size: 22))
                .foregroundColor(.white)
                .padding(.horizontal, 16)
                .padding(.bottom, 16)

            if viewModel.isLoading {
                ForEach(0..<3, id: \.self) { _ in
                    HStack(spacing: 12) {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.white.opacity(0.06))
                            .frame(width: 52, height: 52)
                        VStack(alignment: .leading, spacing: 6) {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.white.opacity(0.06))
                                .frame(width: 140, height: 14)
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.white.opacity(0.04))
                                .frame(width: 80, height: 11)
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 16)
                }
            } else {
                ForEach(viewModel.songs) { song in
                    TrackRow(
                        song: song,
                        isCurrentTrack: playerVM.currentTrack?.songId == song.id,
                        isPlaying: playerVM.currentTrack?.songId == song.id && playerVM.isPlaying,
                        onPlay: {
                            Task {
                                await playerVM.play(
                                    song: song,
                                    queue: viewModel.songs
                                )
                            }
                        },
                        onMore: {
                            selectedSongForMoreSheet = song
                            showPlayerMoreSheet = true
                        }
                    )
                    .onAppear {
                        Task {
                            await viewModel.loadMoreIfNeeded(currentItem: song, albumId: album.id)
                        }
                    }
                }
            }
        }
        .padding(.bottom, 40)
    }

    // MARK: - About Section

    private var aboutSection: some View {
        VStack(alignment: .leading, spacing: 0) {

            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("about")
                        .font(.custom("Jura-Regular", size: 12))
                        .foregroundColor(Color(red: 0.25, green: 0.55, blue: 1.0))
                        .tracking(2)
                    Text("this album")
                        .font(.custom("Jura-Bold", size: 24))
                        .foregroundColor(.white)
                }
                Spacer()

                // ← connected to upgrade sheet, same style as action section
                Button(action: { showUpgradeSheet = true }) {
                    Text("Subscription")
                        .font(.custom("Jura-SemiBold", size: 16))
                        .foregroundColor(Color(red: 0.2, green: 0.5, blue: 1.0))
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)

            VStack(alignment: .leading, spacing: 20) {

                if let description = album.description, !description.isEmpty {
                    CollapsibleText(text: description, lineLimit: 6)
                }

                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 0.25, green: 0.55, blue: 1.0).opacity(0.4),
                                Color(red: 0.25, green: 0.55, blue: 1.0).opacity(0.05)
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(height: 1)

                HStack(alignment: .top, spacing: 0) {
                    metaItem(label: "ARTIST", value: album.artist.name)
                    Spacer()
                    if let releaseDate = album.releaseDate {
                        metaItem(label: "RELEASED", value: formatDate(releaseDate))
                        Spacer()
                    }
                    metaItem(label: "TRACKS", value: "\(viewModel.songs.count)")
                    Spacer()
                    metaItem(label: "DURATION", value: totalDuration)
                }
            }
            .padding(20)
            .background(
                ZStack {
                    Color(red: 0.05, green: 0.07, blue: 0.14)
                    HStack {
                        Rectangle()
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color(red: 0.25, green: 0.55, blue: 1.0).opacity(0.3),
                                        Color.clear
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: 3)
                        Spacer()
                    }
                }
            )
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.white.opacity(0.07), lineWidth: 1)
            )
            .padding(.horizontal, 16)
        }
        .padding(.bottom, 128)
    }

    // MARK: - Meta Item Helper

    private func metaItem(label: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.custom("Jura-Regular", size: 10))
                .foregroundColor(.white.opacity(0.3))
                .tracking(1)
            Text(value)
                .font(.custom("Jura-SemiBold", size: 13))
                .foregroundColor(.white.opacity(0.85))
                .lineLimit(1)
        }
    }

    private func playerTrack(from song: Song) -> PlayerTrack {
        PlayerTrack(
            title: song.title,
            artistName: song.artist.name,
            artistId: song.artist.id,
            coverImage: song.coverImage ?? "",
            duration: Int(song.duration ?? 0),
            isPreview: false,
            songId: song.id
        )
    }

    // MARK: - Helpers

    private var totalDuration: String {
        let total = viewModel.songs.compactMap { $0.duration }.reduce(0, +)
        return DurationFormatter.albumDuration(total)
    }

    private func formatDate(_ dateString: String) -> String {
        DurationFormatter.releaseDate(dateString)
    }

    private var fallbackArtistFromAlbum: FeaturedArtist {
        FeaturedArtist(
            id: album.artist.id ?? "",
            name: album.artist.name,
            slug: album.artist.slug,
            bio: nil,
            location: nil,
            country: nil,
            profileImage: nil,
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

// MARK: - Preview

#Preview {
    NavigationStack {
        AlbumDetailView(album: Album(
            id: "69b32f69b3217bda23d4dfc5",
            title: "Live at Ramsess Art Garden, Pt. 3",
            slug: "live-at-ramsess-art-garden-pt-3-wu0ina",
            coverImage: "https://d3tp8cbw5vz2ok.cloudfront.net/covers/ed0aebc2-e58b-49cc-ab9c-546dad8343e9.webp",
            description: "In the spring of 2024 Ryan Watts a.k.a. Akira Film Script was approached by his long-time friend and visual art collaborator Lisa Bojorquez to perform a live ambient music and soundscape set for her art opening later that summer at Oakland, CA's Ramsess Art Garden for their inaugural art opening showcase.",
            releaseDate: "2025-09-26T00:00:00.000Z",
            genre: ["electronic", "ambient", "experimental"],
            accessType: "subscription",
            basePrice: nil,
            convertedPrices: [],
            artist: Artist(id: "698615f0a5238e31d0a1e659", name: "Akira Film Script", slug: "akira-film-script-qdxvfx"),
            createdAt: "2026-03-12T21:26:01.237Z",
            updatedAt: "2026-03-12T21:45:34.737Z"
        ))
    }
    .environmentObject(PlayerViewModel())
}
