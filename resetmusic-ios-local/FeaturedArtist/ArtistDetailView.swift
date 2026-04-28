//
//  ArtistDetailView.swift
//  resetmusic-ios-local
//
//  Created by Naushad Ali Khan on 11/03/26.
//

import SwiftUI
import Kingfisher

struct ArtistDetailView: View {

    let artist: FeaturedArtist

    @StateObject private var albumViewModel = ArtistAlbumViewModel()
    @Environment(\.dismiss) private var dismiss
    @State private var selectedAlbum: Album? = nil
    @State private var showSubscribeSheet = false  // ← added
//    @State private var isFavourited: Bool = false  // Hidden for App Store first release

    private let coverHeight: CGFloat = 420

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 0) {
                heroSection
                infoSection
                albumsSection
                aboutSection
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.bottom, 100)
        }
        .ignoresSafeArea(edges: .top)
        .appBackground()
        .navigationBarBackButtonHidden(true)
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
                Text(artist.name)
                    .font(.custom("Jura-SemiBold", size: 16))
                    .foregroundColor(.white)
            }
        }
        .toolbarBackground(.hidden, for: .navigationBar)
        .task { await albumViewModel.loadAlbums(for: artist.id) }
        .sheet(isPresented: $showSubscribeSheet) {           // ← added
            ArtistSubscribeSheetView(artist: artist)
                .presentationDetents([.height(560)])
                .presentationDragIndicator(.visible)
        }
    }

    // MARK: - Hero Section

    private var heroSection: some View {
        ZStack(alignment: .bottomLeading) {
            Rectangle()
                .fill(Color(red: 0.06, green: 0.08, blue: 0.15))
                .frame(maxWidth: .infinity)
                .frame(height: coverHeight)
                .layoutPriority(1)

            KFImage(URL(string: artist.coverImage ?? artist.profileImage ?? ""))
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity)
                .frame(height: coverHeight)
                .clipped()
                .saturation(0)

            LinearGradient(
                stops: [
                    .init(color: .clear, location: 0.0),
                    .init(color: Color(red: 0.01, green: 0.09, blue: 0.24).opacity(0.6), location: 0.5),
                    .init(color: Color(red: 0.01, green: 0.05, blue: 0.15), location: 1.0)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(maxWidth: .infinity)
            .frame(height: coverHeight)

            HStack(alignment: .bottom) {

                // 🔹 LEFT: Artist Info
                VStack(alignment: .leading, spacing: 6) {
                    Text("ARTIST")
                        .font(.custom("Jura-Regular", size: 12))
                        .foregroundColor(.white.opacity(0.7))
                        .tracking(1.5)

                    Text(artist.name)
                        .font(.custom("Jura-Bold", size: 32))
                        .foregroundColor(.white)

                    HStack(spacing: 12) {
                        if let location = artist.location {
                            HStack(spacing: 4) {
                                Image(systemName: "mappin")
                                    .font(.system(size: 11))
                                Text(location)
                                    .font(.custom("Jura-Regular", size: 13))
                            }
                            .foregroundColor(.white.opacity(0.7))
                        }

                        HStack(spacing: 4) {
                            Image(systemName: "person.2.fill")
                                .font(.system(size: 11))
                            Text("0 subscribers")
                                .font(.custom("Jura-Regular", size: 13))
                        }
                        .foregroundColor(.white.opacity(0.7))
                    }
                }

                Spacer()

//                // 🔥 RIGHT: Bookmark Button
//                Button(action: {
//                    isFavourited.toggle()
//                }) {
//                    ZStack {
//                        Circle()
//                            .fill(isFavourited
//                                  ? Color.blue.opacity(0.15)
//                                  : Color.white.opacity(0.06))
//                            .frame(width: 44, height: 44)
//
//                        Image(systemName: isFavourited ? "bookmark.fill" : "bookmark")
//                            .font(.system(size: 16, weight: .medium))
//                            .foregroundColor(
//                                isFavourited
//                                ? Color.blue
//                                : Color.white.opacity(0.8)
//                            )
//                    }
//                }
//                .buttonStyle(.plain)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 24)        }
        .frame(maxWidth: .infinity)
        .frame(height: coverHeight)
    }

    // MARK: - Info Section

    private var infoSection: some View {
        HStack(spacing: 16) {
            Text(artist.displayPrice)
                .font(.custom("Jura-SemiBold", size: 16))
                .foregroundColor(Color(red: 0.25, green: 0.55, blue: 1.0))
            Spacer()
            Button(action: { showSubscribeSheet = true }) {  // ← wired
                Text("Subscribe")
                    .font(.custom("Jura-SemiBold", size: 15))
                    .foregroundColor(.white)
                    .padding(.horizontal, 28)
                    .padding(.vertical, 12)
                    .background(Color(red: 0.2, green: 0.5, blue: 1.0))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 20)
    }

    // MARK: - Albums Section

    private var albumsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Albums")
                .font(.custom("Jura-Bold", size: 22))
                .foregroundColor(.white)
                .padding(.horizontal, 20)

            if albumViewModel.isLoading {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(0..<3, id: \.self) { _ in
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.white.opacity(0.06))
                                .frame(width: 172, height: 220)
                        }
                    }
                    .padding(.horizontal, 20)
                }
            } else if albumViewModel.albums.isEmpty {
                VStack(spacing: 10) {
                    Image(systemName: "music.note.list")
                        .font(.system(size: 32))
                        .foregroundColor(Color(red: 0.25, green: 0.55, blue: 1.0).opacity(0.4))
                    Text("No Albums Yet")
                        .font(.custom("Jura-SemiBold", size: 15))
                        .foregroundColor(.white.opacity(0.5))
                    Text("This artist hasn't released any albums yet.")
                        .font(.custom("Jura-Regular", size: 13))
                        .foregroundColor(.white.opacity(0.3))
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 140)
                .padding(.horizontal, 20)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(albumViewModel.albums) { album in
                            Button { selectedAlbum = album } label: { AlbumCard(album: album) }
                                .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 20)
                }
            }
        }
        .navigationDestination(item: $selectedAlbum) { AlbumDetailView(album: $0) }
        .padding(.bottom, 32)
    }

    // MARK: - About Section

    private var aboutSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack(spacing: 8) {
                Text("about")
                    .font(.custom("Jura-Bold", size: 22))
                    .foregroundColor(Color(red: 0.25, green: 0.55, blue: 1.0))
                Text(artist.name)
                    .font(.custom("Jura-Bold", size: 22))
                    .foregroundColor(.white)
            }

            if let location = artist.location {
                HStack(spacing: 8) {
                    Image(systemName: "mappin.circle")
                        .font(.system(size: 15))
                        .foregroundColor(.white.opacity(0.5))
                    Text(location)
                        .font(.custom("Jura-Regular", size: 15))
                        .foregroundColor(.white.opacity(0.6))
                }
            }

            if let bio = artist.bio {
                Text(bio)
                    .font(.custom("Jura-Regular", size: 15))
                    .foregroundColor(.white.opacity(0.8))
                    .lineSpacing(7)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Divider().overlay(Color.white.opacity(0.1))

            HStack(alignment: .top, spacing: 16) {
                VStack(alignment: .leading, spacing: 5) {
                    Text("Subscription Details")
                        .font(.custom("Jura-SemiBold", size: 16))
                        .foregroundColor(Color(red: 0.25, green: 0.55, blue: 1.0))
                    Text("Subscribe for exclusive content")
                        .font(.custom("Jura-Regular", size: 14))
                        .foregroundColor(.white.opacity(0.7))
                    Text("\(artist.displayPrice) · Cancel anytime")
                        .font(.custom("Jura-Regular", size: 12))
                        .foregroundColor(.white.opacity(0.4))
                }
                Spacer()
                Button(action: { showSubscribeSheet = true }) {  // ← wired
                    Text("Subscribe Now")
                        .font(.custom("Jura-SemiBold", size: 14))
                        .foregroundColor(.white)
                        .lineLimit(1)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 14)
                        .background(Color(red: 0.2, green: 0.5, blue: 1.0))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                .buttonStyle(.plain)
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(red: 0.06, green: 0.08, blue: 0.14))
        .cornerRadius(16)
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.white.opacity(0.07), lineWidth: 1))
        .padding(.horizontal, 20)
        .padding(.top, 8)
    }
}

// MARK: - Preview

#Preview("Nariel") {
    NavigationStack {
        ArtistDetailView(artist: FeaturedArtist(
            id: "69676ee89768e0cb8a7907c3",
            name: "Nariel",
            slug: "nariel-dvr1ug",
            bio: "shifting through the layers of consciousness NARIEL brings new realms within the infinite possibilities of rhythmic sculpture. a synaptic blast with a torrent of industrial shockwaves and fragments of micro neurological information, enveloped in a dreamy ambience.",
            location: "Naples",
            country: "IT",
            profileImage: "https://d3tp8cbw5vz2ok.cloudfront.net/artist/e00ad410-a4a9-4095-a9c0-8a44d87f19c9.jpg",
            coverImage: "https://d3tp8cbw5vz2ok.cloudfront.net/covers/11de53a6-975f-45b7-b713-0675b34f6375.jpg",
            subscriptionPlans: [ArtistSubscriptionPlan(cycle: "3m", basePrice: Price(currency: "USD", amount: 2.99), convertedPrices: [])],
            isMonetizationComplete: true,
            songCount: 16, albumCount: 3,
            createdAt: "", updatedAt: ""
        ))
    }
}

#Preview("Akira Film Script") {
    NavigationStack {
        ArtistDetailView(artist: FeaturedArtist(
            id: "698615f0a5238e31d0a1e659",
            name: "Akira Film Script",
            slug: "akira-film-script-qdxvfx",
            bio: "Akira Film Script is the wide-reaching electronic music output from electronic musician and Cyclical Magazine Best of 2025-nominated producer Ryan Watts. With sonic scopes ranging from blissful ambient and melodic techno, to post-everything noisecore, nothing is off limits for Ryan's musical expression and sound exploration under the Akira Film Script banner.",
            location: "San Francisco, CA",
            country: "US",
            profileImage: "https://d3tp8cbw5vz2ok.cloudfront.net/artist/56ced079-fede-4a1f-b309-82011918b69e.webp",
            coverImage: "https://d3tp8cbw5vz2ok.cloudfront.net/covers/f6399be6-a11f-49fc-a256-0f091f6f17f9",
            subscriptionPlans: [ArtistSubscriptionPlan(cycle: "3m", basePrice: Price(currency: "USD", amount: 9.99), convertedPrices: [])],
            isMonetizationComplete: true,
            songCount: 0, albumCount: 0,
            createdAt: "", updatedAt: ""
        ))
    }
}
