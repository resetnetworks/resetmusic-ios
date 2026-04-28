//
//  AlbumCardRow.swift
//  resetmusic-ios-local
//
//  Created by Naushad Ali Khan on 07/03/26.
//

import SwiftUI

struct AlbumCardRow: View {

    @StateObject private var viewModel: AlbumViewModel
    @State private var selectedAlbum: Album? = nil
    @State private var showAllAlbums = false

    var onViewAll: () -> Void = {}

    init(onViewAll: @escaping () -> Void = {}) {
        self.onViewAll = onViewAll
        _viewModel = StateObject(wrappedValue: AlbumViewModel())
    }

    init(viewModel: AlbumViewModel, onViewAll: @escaping () -> Void = {}) {
        self.onViewAll = onViewAll
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            header
            
            if viewModel.isLoading && viewModel.albums.isEmpty {
                skeletonScroll
            } else {
                albumScroll
            }
        }
        .task {
            await viewModel.loadAlbums()
        }
        .navigationDestination(isPresented: $showAllAlbums) {
            AllAlbumsView(viewModel: viewModel)
        }
    }

    // MARK: - Header

    private var header: some View {
        HStack(alignment: .center) {
            SectionBanner(title: "new albums for you", horizontalPadding: 0)
            Spacer()
            ViewAllButton {
                showAllAlbums = true
            }
        }
        .padding(.horizontal, 10)
        .padding(.bottom, 12)
    }
    
    // MARK: - Skeleton Scroll Section
    
    private var skeletonScroll: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 12) {
                ForEach(0..<3, id: \.self) { _ in
                    AlbumCardSkeleton()
                }
            }
            .padding(.horizontal, 10)
            .fixedSize(horizontal: false, vertical: true)
        }
        .disabled(true) // Prevent interaction during loading
    }

    // MARK: - Album Scroll Section

    private var albumScroll: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 12) {
                ForEach(viewModel.albums) { album in
                    Button {
                        selectedAlbum = album
                    } label: {
                        AlbumCard(album: album)
                    }
                    .buttonStyle(.plain)
                    .onAppear {
                        Task {
                            await viewModel.loadMoreIfNeeded(currentItem: album)
                        }
                    }
                }
            }
            .padding(.horizontal, 10)
            .fixedSize(horizontal: false, vertical: true)
        }
        .navigationDestination(item: $selectedAlbum) { album in
            AlbumDetailView(album: album)
        }
    }
}

// MARK: - Preview

#Preview("With Data") {
    let vm = AlbumViewModel()
    vm.albums = [
        Album(id: "1", title: "enigmata", slug: "enigmata",
              coverImage: "https://d3tp8cbw5vz2ok.cloudfront.net/covers/a92f6222-a716-4067-aab3-38b8fdb9a2d1.webp",
              description: nil, releaseDate: nil, genre: [], accessType: "subscription",
              basePrice: nil, convertedPrices: [],
              artist: Artist(id: "1", name: "Nariel", slug: "nariel"),
              createdAt: "", updatedAt: ""),
        Album(id: "2", title: "carbon FM", slug: "carbon-fm",
              coverImage: "https://d3tp8cbw5vz2ok.cloudfront.net/covers/a6fb247b-2399-4ad6-814c-1bfd3167ddcb.webp",
              description: nil, releaseDate: nil, genre: [], accessType: "subscription",
              basePrice: nil, convertedPrices: [],
              artist: Artist(id: "1", name: "Nariel", slug: "nariel"),
              createdAt: "", updatedAt: "")
    ]
    vm.isLoading = false
    
    return NavigationStack {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack { AlbumCardRow(viewModel: vm); Spacer() }.padding(.top, 40)
        }
    }
}

#Preview("Loading") {
    let vm = AlbumViewModel()
    vm.isLoading = true
    vm.albums = []
    
    return NavigationStack {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack { AlbumCardRow(viewModel: vm); Spacer() }.padding(.top, 40)
        }
    }
}
