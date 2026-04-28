//
//  GenreDetailView.swift
//  resetmusic-ios-local
//
//  Created by resetstudio01  on 21/04/26.
//

import SwiftUI
import Kingfisher

struct GenreDetailView: View {

    let slug: String
    let title: String

    @StateObject private var viewModel = GenreDetailViewModel()
    @EnvironmentObject private var playerVM: PlayerViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var scrollOffset: CGFloat = 0
    
    private var isCurrentGenrePlaying: Bool {
        guard let songs = viewModel.genreDetail?.songs,
              let current = playerVM.currentTrack else { return false }

        return songs.contains(where: { $0.id == current.songId }) && playerVM.isPlaying
    }

    private var showNavPlayButton: Bool {
        scrollOffset > 220
    }
    
    // MARK: - Calculate Total Duration
    private var totalDuration: String {
        guard let songs = viewModel.genreDetail?.songs else { return "0:00" }
        let total = songs.compactMap { $0.duration }.reduce(0, +)
        return DurationFormatter.albumDuration(total)
    }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            if viewModel.isLoading {
                loadingView
            } else if let genreDetail = viewModel.genreDetail {
                contentView(genreDetail: genreDetail)
            } else if viewModel.errorMessage != nil {
                errorView
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                }
                .buttonStyle(.plain)
            }
            ToolbarItem(placement: .principal) {
                HStack(spacing: 8) {

                    Text(title.capitalized)
                        .font(.custom("Jura-SemiBold", size: 14))
                        .foregroundColor(.white.opacity(showNavPlayButton ? 1 : 0))
                        .padding(.trailing, 4)
                    
                    Button(action: {
                        Task {
                            if isCurrentGenrePlaying {
                                playerVM.togglePlayPause()
                            } else {
                                if let songs = viewModel.genreDetail?.songs,
                                   let first = songs.first {
                                    await playerVM.play(song: first, queue: songs)
                                }
                            }
                        }
                    }) {
                        ZStack {
                            Circle()
                                .fill(Color(red: 0.25, green: 0.55, blue: 1.0))
                                .frame(width: 48, height: 48)

                            Image(systemName: isCurrentGenrePlaying ? "pause.fill" : "play.fill")
                                .foregroundColor(.white)
                                .font(.system(size: 12, weight: .semibold))
                        }
                    }
                    .scaleEffect(showNavPlayButton ? 1 : 0.6)
                    .opacity(showNavPlayButton ? 1 : 0)
                    .offset(x: showNavPlayButton ? 0 : 30)
                    .animation(.spring(response: 0.4, dampingFraction: 0.7), value: showNavPlayButton)
                }
            }
        }
        .toolbarBackground(.hidden, for: .navigationBar)
        .task { await viewModel.load(slug: slug) }
    }

    // MARK: - Content

    private func contentView(genreDetail: GenreDetailResponse) -> some View {
        ScrollView(.vertical, showsIndicators: false) {

            GeometryReader { geo in
                Color.clear
                    .onChange(of: geo.frame(in: .global).minY) { _, value in
                        scrollOffset = -value
                    }
            }
            .frame(height: 0)

            VStack(alignment: .leading, spacing: 0) {
                heroSection(genreDetail: genreDetail)
                infoSection(genreDetail: genreDetail)
                
                if genreDetail.songs.isEmpty {
                    comingSoonSection()
                } else {
                    songsSection(songs: genreDetail.songs)
                }
            }
            .padding(.bottom, 100)
        }
        .ignoresSafeArea(edges: .top)
    }
    
    // MARK: - Hero

    private func heroSection(genreDetail: GenreDetailResponse) -> some View {
        ZStack(alignment: .bottomLeading) {
            // Use local asset since API doesn't return cover image
            Image("genre-\(slug)")
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity)
                .frame(height: 320)
                .clipped()

            LinearGradient(
                colors: [.clear, .black],
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: 320)

            VStack(alignment: .leading, spacing: 6) {
                Text("GENRE")
                    .font(.custom("Jura-Regular", size: 11))
                    .foregroundColor(.white.opacity(0.5))
                    .tracking(2)

                Text(genreDetail.genre.capitalized)
                    .font(.custom("Jura-Bold", size: 34))
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 24)
        }
        .frame(height: 320)
    }

    // MARK: - Info

    private func infoSection(genreDetail: GenreDetailResponse) -> some View {
        HStack(alignment: .center) {

            // LEFT → Stats with Duration
            HStack(spacing: 20) {
                statItem(value: "\(genreDetail.total)", label: "Tracks")
                statItem(value: totalDuration, label: "Duration")
            }

            Spacer()

            // RIGHT → Play Button (hides when scrolled)
            Button(action: {
                Task {
                    if isCurrentGenrePlaying {
                        playerVM.togglePlayPause()
                    } else {
                        if let songs = viewModel.genreDetail?.songs,
                           let first = songs.first {
                            await playerVM.play(song: first, queue: songs)
                        }
                    }
                }
            }) {
                ZStack {
                    Circle()
                        .fill(Color(red: 0.25, green: 0.55, blue: 1.0))
                        .frame(width: 48, height: 48)

                    Image(systemName: isCurrentGenrePlaying && playerVM.isPlaying ? "pause.fill" : "play.fill")
                        .foregroundColor(.white)
                        .font(.system(size: 16, weight: .semibold))
                }
            }
            .opacity(showNavPlayButton ? 0 : 1) // ✅ Hide when nav button shows
            .animation(.easeInOut(duration: 0.25), value: showNavPlayButton)
        }
        .padding(.horizontal, 20)
        .padding(.top, 24)
        .padding(.bottom, 8)
    }
    
    private func statItem(value: String, label: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(value)
                .font(.custom("Jura-Bold", size: 20))
                .foregroundColor(.white)
            Text(label)
                .font(.custom("Jura-Regular", size: 12))
                .foregroundColor(.white.opacity(0.4))
        }
    }

    // MARK: - Songs Section

    private func songsSection(songs: [Song]) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Tracks")
                .font(.custom("Jura-Bold", size: 22))
                .foregroundColor(.white)
                .padding(.horizontal, 20)
                .padding(.top, 32)
                .padding(.bottom, 16)

            ForEach(songs) { song in
                TrackRow(
                    song: song,
                    isCurrentTrack: playerVM.currentTrack?.songId == song.id,
                    isPlaying: playerVM.currentTrack?.songId == song.id && playerVM.isPlaying,
                    onPlay: {
                        Task {
                            await playerVM.play(song: song, queue: songs)
                        }
                    }
                )
                .onAppear {
                    Task {
                        await viewModel.loadMoreIfNeeded(currentItem: song)
                    }
                }
            }

            if viewModel.isLoading && !songs.isEmpty {
                HStack {
                    Spacer()
                    ProgressView()
                        .tint(.white)
                    Spacer()
                }
                .padding(.vertical, 20)
            }
        }
    }

    // MARK: - Coming Soon

    private func comingSoonSection() -> some View {
        VStack(alignment: .center, spacing: 8) {
            Text("Tracks")
                .font(.custom("Jura-Bold", size: 22))
                .foregroundColor(.white)

            Text("Coming Soon")
                .font(.custom("Jura-Regular", size: 14))
                .foregroundColor(.white.opacity(0.5))
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 40)
    }
    
    // MARK: - Loading

    private var loadingView: some View {
        VStack {
            Spacer()
            ProgressView().tint(.white)
            Spacer()
        }
    }

    // MARK: - Error

    private var errorView: some View {
        VStack(spacing: 12) {
            Spacer()
            Image(systemName: "exclamationmark.circle")
                .font(.system(size: 32))
                .foregroundColor(.white.opacity(0.3))
            Text("Couldn't load genre")
                .font(.custom("Jura-Regular", size: 15))
                .foregroundColor(.white.opacity(0.4))
            Spacer()
        }
    }
}

#Preview {
    NavigationStack {
        GenreDetailView(slug: "electronic", title: "electronic")
            .environmentObject(PlayerViewModel())
    }
}
