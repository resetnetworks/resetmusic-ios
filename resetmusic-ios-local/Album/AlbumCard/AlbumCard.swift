//
//  AlbumCard.swift
//  resetmusic-ios-local
//
//  Created by Naushad Ali Khan on 07/03/26.
//

import SwiftUI

struct AlbumCard: View {

    let album: Album

    private enum Layout {
        static let width: CGFloat = 172
        static let imageHeight: CGFloat = 160
        static let cornerRadius: CGFloat = 8
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            coverSection
            infoSection
        }
        .frame(width: Layout.width)
        .background(Color(red: 0.047, green: 0.090, blue: 0.153))
      
        .cornerRadius(Layout.cornerRadius)
        .clipped()
    }

    // MARK: - Cover Section

    private var coverSection: some View {
        ZStack(alignment: .bottom) {
            AlbumCoverImage(
                urlString: album.coverImage,
                width: Layout.width,
                height: Layout.imageHeight
            )
            overlayGradient
            Text(album.title)
                .font(.custom("Jura-Bold", size: 14))
                .foregroundColor(.white)
                .lineLimit(1)
                .truncationMode(.tail)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.horizontal, 8)
                .padding(.bottom, 10)
        }
        .frame(width: Layout.width, height: Layout.imageHeight)
    }

    // MARK: - Info Section

    private var infoSection: some View {
        HStack(spacing: 4) {
            Text("by artist")
                .font(.custom("Jura-Regular", size: 12))
                .foregroundColor(.white.opacity(0.7))
                .lineLimit(1)
            Spacer()
            Text(album.artist.name)
                .font(.custom("Jura-SemiBold", size: 13))
                .foregroundColor(.white.opacity(0.9))
                .lineLimit(1)
                .truncationMode(.tail)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
    }

    // MARK: - Gradient

    private var overlayGradient: some View {
        LinearGradient(
            stops: [
                .init(color: .clear, location: 0.0),
                .init(color: Color(red: 0.06, green: 0.08, blue: 0.24).opacity(0.65), location: 0.60),
                .init(color: Color(red: 0.06, green: 0.26, blue: 0.79).opacity(0.95), location: 1.0)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }
}

// MARK: - Preview

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        ScrollView(.horizontal) {
            HStack(spacing: 12) {
                AlbumCard(album: Album(
                    id: "1",
                    title: "healing sound project",
                    slug: "healing-sound-project",
                    coverImage: "https://picsum.photos/seed/album1/187/162",
                    description: "A healing journey through sound",
                    releaseDate: "2024-01-15",
                    genre: ["Ambient", "Healing"],
                    accessType: "purchased",
                    basePrice: nil,
                    convertedPrices: [],
                    artist: Artist(id: "artist-1", name: "SD Naja", slug: "sd-naja"),
                    createdAt: "2024-01-01T00:00:00Z",
                    updatedAt: "2024-01-01T00:00:00Z"
                ))
                AlbumCard(album: Album(
                    id: "2",
                    title: "carbon waves",
                    slug: "carbon-waves",
                    coverImage: "https://picsum.photos/seed/album2/187/162",
                    description: nil,
                    releaseDate: nil,
                    genre: ["Electronic"],
                    accessType: "free",
                    basePrice: nil,
                    convertedPrices: [],
                    artist: Artist(id: "artist-2", name: "Giadar", slug: "giadar"),
                    createdAt: "2024-03-01T00:00:00Z",
                    updatedAt: "2024-03-01T00:00:00Z"
                ))
            }
            .padding(.horizontal, 16)
        }
    }
}

