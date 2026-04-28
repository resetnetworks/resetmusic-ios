//
//  FeaturedArtistCard.swift
//  trial
//
//  Created by Naushad Ali Khan on 25/02/26.
//


import SwiftUI
import Kingfisher

struct FeaturedArtistCard: View {

    let artist: FeaturedArtist
    var showsBookmarkBadge: Bool = false
    @State private var isFavourited = false

    private enum UI {
        static let imageSize: CGFloat = 140
        static let borderWidth: CGFloat = 2
        static let spacing: CGFloat = 10
    }

    var body: some View {
        VStack(spacing: UI.spacing) {
            artistImage
            Text(artist.name)
                .font(.custom("Jura-SemiBold", size: 14))
                .foregroundStyle(.white)
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .frame(width: UI.imageSize)
        }
    }
}

private extension FeaturedArtistCard {

    var artistImage: some View {
        ZStack(alignment: .bottomTrailing) {
            KFImage(URL(string: artist.profileImage ?? ""))
                .downsampling(size: CGSize(width: 160, height: 160))
                .placeholder {
                    Circle().fill(Color.gray.opacity(0.25))
                }
                .resizable()
                .scaledToFill()
                .saturation(0)
                .frame(width: UI.imageSize, height: UI.imageSize)
                .clipShape(Circle())
                .overlay(glowBorder)
                .shadow(color: glowColor.opacity(0.4), radius: 8)

            if showsBookmarkBadge {
                ArtistBookmarkBadge(isFavourited: $isFavourited)
                    .offset(x: 4, y: 4)
            }
        }
    }

    var glowBorder: some View {
        Circle()
            .stroke(
                LinearGradient(
                    colors: [
                        Color(red: 0.2, green: 0.7, blue: 1.0),
                        Color(red: 0.0, green: 0.45, blue: 0.9),
                        Color(red: 0.0, green: 0.3, blue: 0.75).opacity(0.3)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ),
                lineWidth: UI.borderWidth
            )
    }

    var glowColor: Color { Color(red: 0.0, green: 0.45, blue: 0.95) }
}

// MARK: - Preview

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        ScrollView(.horizontal) {
            HStack(spacing: 16) {
                FeaturedArtistCard(artist: FeaturedArtist(
                    id: "1", name: "Giadar", slug: "giadar",
                    bio: nil, location: "Rome", country: "IT",
                    profileImage: "https://d3tp8cbw5vz2ok.cloudfront.net/artist/3c4548f3-6a98-4fcc-bb47-1803d9ffe454.webp",
                    coverImage: nil, subscriptionPlans: [],
                    isMonetizationComplete: true,
                    songCount: 17, albumCount: 2,
                    createdAt: "", updatedAt: ""
                ))
                FeaturedArtistCard(artist: FeaturedArtist(
                    id: "2", name: "Akira Film Script", slug: "akira-film-script",
                    bio: nil, location: "San Francisco", country: "US",
                    profileImage: "https://d3tp8cbw5vz2ok.cloudfront.net/artist/56ced079-fede-4a1f-b309-82011918b69e.webp",
                    coverImage: nil, subscriptionPlans: [],
                    isMonetizationComplete: true,
                    songCount: 0, albumCount: 0,
                    createdAt: "", updatedAt: ""
                ))
                FeaturedArtistCard(artist: FeaturedArtist(
                    id: "3", name: "Nariel", slug: "nariel",
                    bio: nil, location: "Naples", country: "IT",
                    profileImage: "https://d3tp8cbw5vz2ok.cloudfront.net/artist/e00ad410-a4a9-4095-a9c0-8a44d87f19c9.jpg",
                    coverImage: nil, subscriptionPlans: [],
                    isMonetizationComplete: true,
                    songCount: 17, albumCount: 3,
                    createdAt: "", updatedAt: ""
                ))
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
        }
    }
}
