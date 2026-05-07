//
//  AllArtistsView.swift
//  resetmusic-ios-local
//
//  Created by resetstudio01  on 21/04/26.
//


import SwiftUI
import Kingfisher

struct AllArtistsView: View {
    
    @StateObject var viewModel: ArtistViewModel
    @State private var selectedArtist: FeaturedArtist? = nil
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
                
                headerView
                
                // ✅ Grid
                LazyVGrid(columns: columns, spacing: 24) {
                    ForEach(viewModel.artists) { artist in
                        Button {
                            selectedArtist = artist
                        } label: {
                            artistCard(artist: artist)
                        }
                        .buttonStyle(.plain)
                        .onAppear {
                            Task {
                                await viewModel.loadMoreIfNeeded(currentItem: artist)
                            }
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 10)
                .padding(.bottom, 60)
            }
        }
        .scrollIndicators(.hidden)
        .appBackground() // ✅ Applied here
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
                Text("Artists")
                    .font(.custom("Jura-Bold", size: 18))
                    .foregroundColor(.white)
                    .opacity(showNavTitle ? 1 : 0)
                    .animation(.easeInOut(duration: 0.2), value: showNavTitle)
            }
        }
        .toolbarBackground(.hidden, for: .navigationBar) // ✅ Changed to .hidden
        
        // ✅ Data loading
        .task {
            if viewModel.artists.isEmpty {
                await viewModel.loadArtists()
            }
        }
        
        // ✅ Navigation
        .navigationDestination(item: $selectedArtist) { artist in
            ArtistDetailView(artist: artist)
        }
    }
    
    // MARK: - Header
    
    private var headerView: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Artists")
                .font(.custom("Jura-Bold", size: 28))
                .foregroundColor(.white)
            
            Text("Discover independent artists")
                .font(.custom("Jura-Medium", size: 14))
                .foregroundColor(.white.opacity(0.5)) // ✅ Better contrast
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
        .padding(.bottom, 12)
        .opacity(showNavTitle ? 0 : 1)
        .offset(y: showNavTitle ? -10 : 0)
        .animation(.easeInOut(duration: 0.2), value: showNavTitle)
    }
    
    // MARK: - Artist Card
    
    @ViewBuilder
    private func artistCard(artist: FeaturedArtist) -> some View {
        VStack(spacing: 10) {
            KFImage(URL(string: artist.profileImage ?? ""))
                .placeholder {
                    Circle()
                        .fill(Color(red: 0.1, green: 0.1, blue: 0.2))
                }
                .resizable()
                .scaledToFill()
                .frame(width: 160, height: 160)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(
                            LinearGradient(
                                colors: [
                                    Color(red: 0.3, green: 0.6, blue: 1.0).opacity(0.8),
                                    Color(red: 0.1, green: 0.3, blue: 0.7).opacity(0.4)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 2
                        )
                )
            
            VStack(spacing: 4) {
                Text(artist.name)
                    .font(.custom("Jura-SemiBold", size: 14))
                    .foregroundColor(.white)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                
                if let location = artist.location {
                    Text(location)
                        .font(.custom("Jura-Regular", size: 11))
                        .foregroundColor(.white.opacity(0.5)) // ✅ Better contrast
                        .lineLimit(1)
                }
            }
            .frame(maxWidth: .infinity)
        }
    }
}
// End of struct

#Preview {
    NavigationStack {
        AllArtistsView(viewModel: {
            let vm = ArtistViewModel()
            return vm
        }())
    }
}

