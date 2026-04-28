//
//  RightTileLikeCardCoverImage.swift
//  resetmusic-ios-local
//
//  Created by Naushad Ali Khan on 11/04/26.
//

import SwiftUI

struct RightTileLikeCardCoverImage: View {
    let urlString: String?
    var height: CGFloat = 160
    var cornerRadius: CGFloat = 16

    var body: some View {
        ZStack {
            // Background Image
            AsyncImage(url: URL(string: urlString ?? "")) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit() // 👈 prevents zoom/cropping
                        .frame(maxWidth: .infinity)
                        .background(
                            image
                                .resizable()
                                .scaledToFill()
                                .blur(radius: 20)
                                .opacity(0.3)
                        )

                case .failure(_):
                    placeholder

                case .empty:
                    placeholder

                @unknown default:
                    placeholder
                }
            }

            // Gradient Overlay (softer than before)
            LinearGradient(
                stops: [
                    .init(color: .clear, location: 0.0),
                    .init(color: Color.black.opacity(0.15), location: 0.6),
                    .init(color: Color.black.opacity(0.35), location: 1.0)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        }
        .frame(height: height)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        .shadow(color: .black.opacity(0.15), radius: 8, y: 4)
    }

    private var placeholder: some View {
        ZStack {
            Color.gray.opacity(0.2)

            Image("yashuka")
                .font(.system(size: 24))
                .foregroundColor(.gray)
        }
    }
}
