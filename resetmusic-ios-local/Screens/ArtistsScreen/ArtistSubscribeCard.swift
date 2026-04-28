//
//  ArtistSubscribeCard.swift
//  resetmusic-ios-local
//
//  Created by Naushad Ali Khan on 09/03/26.
//


import SwiftUI
import Kingfisher

struct ArtistSubscribeCard: View {
    var name: String
    var imageName: String?
    var imageURL: String?
    var onTap: () -> Void = {}

//    @State private var isFavourited = false // Hidden for now

    private var size: CGFloat {
        (UIScreen.main.bounds.width - 32 - 30) / 3
    }

    var body: some View {
        VStack(spacing: 8) {

            ZStack(alignment: .bottomTrailing) {

                // 🔹 Image
                Group {
                    if let url = imageURL, !url.isEmpty {
                        KFImage(URL(string: url))
                            .resizable()
                            .scaledToFill()
                    } else {
                        Image(imageName ?? "yashuka")
                            .resizable()
                            .scaledToFill()
                    }
                }
                .frame(width: size, height: size)
                .clipShape(Circle())

                // 🔥 Glow Border
                Circle()
                    .stroke(
                        LinearGradient(
                            colors: [
                                Color.blue.opacity(0.7),
                                Color.blue.opacity(0.3),
                                Color.blue.opacity(0.1)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1.2
                    )
                    .frame(width: size, height: size)
                    .blur(radius: 0.3)

                // 🔥 Soft outer glow
                Circle()
                    .stroke(Color.blue.opacity(0.25), lineWidth: 2)
                    .frame(width: size, height: size)
                    .blur(radius: 6)

//                // 🔹 Badge
//                ArtistBookmarkBadge(isFavourited: $isFavourited)
//                    .scaleEffect(0.8)
//                    .offset(x: 2, y: 2)
            }
            .frame(width: size, height: size)
            .contentShape(Circle())

            // 🔹 Name
            Text(name)
                .font(.custom("Jura-SemiBold", size: 12))
                .foregroundColor(.white)
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .frame(width: size)
        }
        .onTapGesture {
            onTap()
        }
    }
}// MARK: - Preview

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        HStack(spacing: 12) {
            ArtistSubscribeCard(
                name: "Akira Film Script",
                imageURL: "https://d3tp8cbw5vz2ok.cloudfront.net/artist/56ced079-fede-4a1f-b309-82011918b69e.webp"
            )
            ArtistSubscribeCard(
                name: "Nariel",
                imageURL: "https://d3tp8cbw5vz2ok.cloudfront.net/artist/e00ad410-a4a9-4095-a9c0-8a44d87f19c9.jpg"
            )
        }
        .padding(.horizontal, 16)
    }
}
