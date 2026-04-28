//
//  FeaturedArtistRow.swift
//  trial
//
//  Created by Naushad Ali Khan on 25/02/26.
//

import SwiftUI

struct FeaturedArtistRow: View {

    var onViewAll: () -> Void = {}

    @StateObject private var viewModel: ArtistViewModel
    @State private var selectedArtist: FeaturedArtist? = nil
    @State private var showAllArtists: Bool = false

    init(onViewAll: @escaping () -> Void = {}) {
        self.onViewAll = onViewAll
        _viewModel = StateObject(wrappedValue: ArtistViewModel())
    }

    init(viewModel: ArtistViewModel, onViewAll: @escaping () -> Void = {}) {
        self.onViewAll = onViewAll
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            header
            artistScroll
        }
        .task {
            await viewModel.loadArtists()
        }
        .navigationDestination(item: $selectedArtist) { artist in
            ArtistDetailView(artist: artist)
        }
        .navigationDestination(isPresented: $showAllArtists) {
            AllArtistsView(viewModel: viewModel)
        }
    }

    // MARK: - Header

    private var header: some View {
        HStack(alignment: .center) {
            SectionBanner(title: "featured Artists", horizontalPadding: 0)
            Spacer()
            ViewAllButton {
                showAllArtists = true
            }
        }
        .padding(.horizontal, 10)
        .padding(.bottom, 12)
    }

    // MARK: - Scroll

    private var artistScroll: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 18) {
                if viewModel.isLoading {
                    loadingPlaceholders
                } else {
                    ForEach(viewModel.artists) { artist in
                        Button {
                            selectedArtist = artist
                        } label: {
                            FeaturedArtistCard(artist: artist)
                        }
                        .buttonStyle(.plain)
                        .onAppear {
                            Task { await viewModel.loadMoreIfNeeded(currentItem: artist) }
                        }
                    }
                }
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
        }
    }

    // MARK: - Loading Placeholders

    private var loadingPlaceholders: some View {
        ForEach(0..<3, id: \.self) { _ in
            Circle()
                .fill(Color(red: 0.1, green: 0.1, blue: 0.2))
                .frame(width: 160, height: 160)
                .overlay(Circle().stroke(Color(red: 0.20, green: 0.22, blue: 0.45), lineWidth: 1.5))
                .opacity(0.5)
        }
    }
}
// MARK: - Preview

#Preview {
    NavigationStack {
        ZStack {
            Color.black.ignoresSafeArea()
            FeaturedArtistRow()
        }
    }
}
