//
//  FullPlayerArtwork.swift
//  resetmusic-ios-local
//
//  Created by Naushad Ali Khan on 13/03/26.
//


// MARK: - FullPlayerArtwork.swift

import SwiftUI
import Kingfisher

struct FullPlayerArtwork: View {
    let url: String
    var isPlaying: Bool = false
    var isPreview: Bool = false

    var body: some View {
        ZStack(alignment: .topTrailing) {
            KFImage(URL(string: url))
                .placeholder {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(red: 0.1, green: 0.14, blue: 0.25))
                        .overlay(
                            Image(systemName: "music.note")
                                .font(.system(size: 40))
                                .foregroundColor(.white.opacity(0.3))
                        )
                }
                .resizable()
                .scaledToFill()
                .frame(width: 280, height: 280)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.white.opacity(0.08), lineWidth: 1)
                )
                .shadow(color: Color(red: 0.1, green: 0.3, blue: 0.8).opacity(0.3), radius: 20)

            if isPreview {
                Text("P R E V I E W")
                    .font(.system(size: 8, weight: .semibold))
                    .tracking(1)
                    .foregroundColor(Color(red: 0.45, green: 0.75, blue: 1.0))
                    .shadow(color: Color(red: 0.25, green: 0.55, blue: 1.0).opacity(0.9), radius: 6, x: 0, y: 0)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Color.black.opacity(0.8))
                    .overlay(
                        VStack {
                            Rectangle()
                                .fill(Color(red: 0.45, green: 0.75, blue: 1.0).opacity(0.9))
                                .frame(height: 1)
                            Spacer()
                            Rectangle()
                                .fill(Color(red: 0.45, green: 0.75, blue: 1.0).opacity(0.9))
                                .frame(height: 1)
                        }
                    )
                    .padding(.trailing, 12)
                    .padding(.top, 12)
            }
        }
        .frame(width: 280, height: 280)
    }
}

#Preview {
    ZStack {
        Color(red: 0.01, green: 0.05, blue: 0.15).ignoresSafeArea()
        VStack(spacing: 32) {
            FullPlayerArtwork(
                url: "https://d3tp8cbw5vz2ok.cloudfront.net/covers/11de53a6-975f-45b7-b713-0675b34f6375.jpg",
                isPlaying: true,
                isPreview: false
            )
            FullPlayerArtwork(
                url: "https://d3tp8cbw5vz2ok.cloudfront.net/covers/11de53a6-975f-45b7-b713-0675b34f6375.jpg",
                isPlaying: true,
                isPreview: true
            )
        }
    }
}
