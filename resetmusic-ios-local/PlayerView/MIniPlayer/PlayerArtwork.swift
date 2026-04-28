//
//  PlayerArtwork.swift
//  resetmusic-ios-local
//
//  Created by Naushad Ali Khan on 13/03/26.
//


// MARK: - PlayerArtwork.swift
import SwiftUI
import Kingfisher

struct PlayerArtwork: View {
    let url: String
    var isPreview: Bool = false
    var size: CGFloat = 44

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            KFImage(URL(string: url))
                .placeholder {
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(Color(red: 0.1, green: 0.14, blue: 0.25))
                        .overlay(
                            Image(systemName: "music.note")
                                .font(.system(size: size * 0.3))
                                .foregroundColor(.white.opacity(0.3))
                        )
                }
                .resizable()
                .scaledToFill()
                .frame(width: size, height: size)
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                .saturation(0.9)
                .shadow(color: Color(red: 0.3, green: 0.6, blue: 1.0).opacity(0.35), radius: 10, x: 0, y: 0)

            if isPreview {
                Text("PREVIEW")
                    .font(.system(size: 6, weight: .semibold))
                    .tracking(0.8)
                    .foregroundColor(Color(red: 0.45, green: 0.75, blue: 1.0))  // glowy bright blue
                    .shadow(color: Color(red: 0.25, green: 0.55, blue: 1.0).opacity(0.9), radius: 4, x: 0, y: 0)
                    .padding(.horizontal, 5)
                    .padding(.vertical, 3)
                    .background(Color.black.opacity(0.8))
                    .overlay(
                        VStack {
                            Rectangle()
                                .fill(Color(red: 0.45, green: 0.75, blue: 1.0).opacity(0.9))
                                .frame(height: 0.8)
                            Spacer()
                            Rectangle()
                                .fill(Color(red: 0.45, green: 0.75, blue: 1.0).opacity(0.9))
                                .frame(height: 0.8)
                        }
                    )
                    .offset(x: 0, y: 2)
            }
        }
        .frame(width: size, height: size)
    }

    private var cornerRadius: CGFloat { size == 44 ? 8 : 12 }
}

#Preview {
    VStack(spacing: 20) {
        HStack(spacing: 16) {
            PlayerArtwork(url: "https://d3tp8cbw5vz2ok.cloudfront.net/covers/11de53a6-975f-45b7-b713-0675b34f6375.jpg")
            PlayerArtwork(url: "", isPreview: true)
            PlayerArtwork(
                url: "https://d3tp8cbw5vz2ok.cloudfront.net/covers/11de53a6-975f-45b7-b713-0675b34f6375.jpg",
                isPreview: true
            )
        }
    }
    .padding(24)
    .background(Color(red: 0.04, green: 0.07, blue: 0.18))
}
