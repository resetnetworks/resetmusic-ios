//
//  AllAlbumsView.swift
//  resetmusic-ios-local
//
//  Created by resetstudio01  on 20/04/26.
//


import SwiftUI

struct AllAlbumsView: View {

    @StateObject var viewModel: AlbumViewModel
    @State private var selectedAlbum: Album? = nil
    @State private var showNavTitle = false
    @Environment(\.dismiss) private var dismiss

    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {

                // ✅ Scroll tracker
                GeometryReader { geo in
                    Color.clear
                        .onChange(of: geo.frame(in: .global).minY) { _, value in
                            withAnimation(.easeInOut(duration: 0.2)) {
                                showNavTitle = value < 80
                            }
                        }
                }
                .frame(height: 0)

                // ✅ Header
                headerView

                // ✅ Grid with skeleton support
                LazyVGrid(columns: columns, spacing: 16) {
                    if viewModel.isLoading && viewModel.albums.isEmpty {
                        // Show 6 skeleton cards
                        ForEach(0..<6, id: \.self) { _ in
                            AlbumCardSkeleton()
                        }
                    } else {
                        // Show real albums
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
                }
                .padding(.horizontal, 16)
                .padding(.top, 10)
                .padding(.bottom, 80)
            }
        }
        .scrollIndicators(.hidden)
        .appBackground()
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)

        // ✅ Custom Toolbar
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: 44, height: 44)  // explicit HIG minimum
                }
                .buttonStyle(.plain)
                .tint(.clear)
                .contentShape(Rectangle())
            }
            ToolbarItem(placement: .principal) {
                Text("All Albums")
                    .font(.custom("Jura-Bold", size: 18))
                    .foregroundColor(.white)
                    .opacity(showNavTitle ? 1 : 0)
                    .animation(.easeInOut(duration: 0.2), value: showNavTitle)
            }
        }
        .toolbarBackground(.hidden, for: .navigationBar)

        // ✅ Data loading
        .task {
            if viewModel.albums.isEmpty {
                await viewModel.loadAlbums()
            }
        }

        // ✅ Navigation
        .navigationDestination(item: $selectedAlbum) { album in
            AlbumDetailView(album: album)
        }
    }

    // MARK: - Header
    private var headerView: some View {
        VStack(alignment: .leading, spacing: 6) {

            Text("All Albums")
                .font(.custom("Jura-Bold", size: 28))
                .foregroundColor(.white)

            Text("Discover new sound")
                .font(.custom("Jura-Medium", size: 14))
                .foregroundColor(.white.opacity(0.5))
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
        .padding(.bottom, 12)

        // ✅ Hide when nav title appears
        .opacity(showNavTitle ? 0 : 1)
        .offset(y: showNavTitle ? -10 : 0)
        .animation(.easeInOut(duration: 0.2), value: showNavTitle)
    }
}
