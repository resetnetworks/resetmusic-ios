//
//  AlbumUpgradeSheetView.swift
//  resetmusic-ios-local
//
//  Created by Naushad Ali Khan on 24/03/26.
//


import SwiftUI
import Kingfisher

struct AlbumUpgradeSheetView: View {
    let album: Album
    @Environment(\.dismiss) var dismiss
    @State private var appeared: Bool = false

    var body: some View {
        ZStack {
            LinearGradient(
                stops: [
                    .init(color: Color(hex: "000000"), location: 0.0),
                    .init(color: Color(hex: "011639"), location: 1.0)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .overlay(
                LinearGradient(
                    colors: [
                        Color(red: 0.2, green: 0.5, blue: 1.0).opacity(0.25),
                        Color.clear
                    ],
                    startPoint: .top,
                    endPoint: .center
                )
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {

                Spacer()

                // MARK: - Album Art
                ZStack {
                    KFImage(URL(string: album.coverImage ?? ""))
                        .resizable()
                        .scaledToFill()
                        .frame(width: 80, height: 80)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(Color.white.opacity(0.15), lineWidth: 1)
                        )
                        // ← removed blur, reduced saturation slightly
                        .saturation(0.85)

                    // Small lock badge bottom right
                    ZStack {
                        Circle()
                            .fill(Color(red: 0.2, green: 0.5, blue: 1.0))
                            .frame(width: 24, height: 24)
                        Image(systemName: "lock.fill")
                            .font(.system(size: 10, weight: .semibold))
                            .foregroundColor(.white)
                    }
                    .offset(x: 30, y: 30)
                }
                .opacity(appeared ? 1 : 0)
                .scaleEffect(appeared ? 1 : 0.85)
                .padding(.bottom, 20)

                // MARK: - Title + Artist
                VStack(spacing: 6) {
                    Text("This album is for subscribers")
                        .font(.custom("Jura-Bold", size: 20))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)

                    Text("\(album.title)  ·  \(album.artist.name)")
                        .font(.custom("Jura-Regular", size: 13))
                        .foregroundColor(Color(red: 0.3, green: 0.7, blue: 1.0))
                        .lineLimit(1)
                        .truncationMode(.middle)
                }
                .padding(.horizontal, 24)
                .opacity(appeared ? 1 : 0)
                .offset(y: appeared ? 0 : 10)
                .padding(.bottom, 20)

                // MARK: - Feature List
                VStack(spacing: 10) {
                    featureRow(icon: "infinity", text: "Full songs — not just 30 seconds")
                    featureRow(icon: "music.note.list", text: "Complete album access")
                    featureRow(icon: "arrow.forward.circle", text: "Skip freely through any track")
                    featureRow(icon: "person.crop.circle.badge.checkmark", text: "Support the artist directly")
                }
                .padding(.horizontal, 28)
                .opacity(appeared ? 1 : 0)
                .offset(y: appeared ? 0 : 10)
                .padding(.bottom, 24)

                // MARK: - Apple-safe note
                Text("Full access is available outside the app through your Reset account.")
                    .font(.custom("Jura-Regular", size: 12))
                    .foregroundColor(.white.opacity(0.45))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 28)
                    .opacity(appeared ? 1 : 0)
                    .padding(.bottom, 20)

                // MARK: - CTA
                Button(action: {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    dismiss()
                }) {
                    Text("Got it")
                        .font(.custom("Jura-SemiBold", size: 14))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            Color(hex: "0F3272"),
                                            Color(hex: "1A5DB4"),
                                            Color(hex: "3B82F6")
                                        ],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .buttonStyle(.plain)
                .padding(.horizontal, 28)
                .opacity(appeared ? 1 : 0)
                .offset(y: appeared ? 0 : 10)

                Spacer()
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.75)) {
                appeared = true
            }
        }
        .onDisappear {
            appeared = false
        }
    }

    // MARK: - Feature Row Helper
    private func featureRow(icon: String, text: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(Color(red: 0.3, green: 0.7, blue: 1.0))
                .frame(width: 20)
            Text(text)
                .font(.custom("Jura-Regular", size: 14))
                .foregroundColor(.white.opacity(0.8))
            Spacer()
        }
    }
}

#Preview {
    AlbumUpgradeSheetView(album: Album(
        id: "69b32f69b3217bda23d4dfc5",
        title: "Live at Ramsess Art Garden, Pt. 2",
        slug: "",
        coverImage: "https://d3tp8cbw5vz2ok.cloudfront.net/covers/ed0aebc2-e58b-49cc-ab9c-546dad8343e9.webp",
        description: nil,
        releaseDate: nil,
        genre: [],
        accessType: "subscription",
        basePrice: nil,
        convertedPrices: [],
        artist: Artist(id: "", name: "Akira Film Script", slug: ""),
        createdAt: "",
        updatedAt: ""
    ))
    .presentationDetents([.height(480)])
    .presentationDragIndicator(.visible)
}
