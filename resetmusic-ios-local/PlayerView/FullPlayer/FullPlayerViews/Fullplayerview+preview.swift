//
//  Fullplayerview+preview.swift
//  resetmusic-ios-local
//
//  Created by resetstudio01  on 27/04/26.
//

import SwiftUI

// ─────────────────────────────────────────────
// MARK: - Preview
// ─────────────────────────────────────────────

#Preview {
    FullPlayerView(isPresented: .constant(true))
        .environmentObject({
            let vm = PlayerViewModel()
            vm.currentTrack = PlayerTrack(
                title: "Shifting Layers",
                artistName: "Nariel",
                artistId: "69676ee89768e0cb8a7907c3",
                coverImage: "https://d3tp8cbw5vz2ok.cloudfront.net/covers/11de53a6-975f-45b7-b713-0675b34f6375.jpg",
                artist: FeaturedArtist(
                    id: "69676ee89768e0cb8a7907c3",
                    name: "Nariel",
                    slug: "nariel-dvr1ug",
                    bio: "shifting through the layers of consciousness.",
                    location: "Naples",
                    country: "IT",
                    profileImage: "https://d3tp8cbw5vz2ok.cloudfront.net/artist/e00ad410-a4a9-4095-a9c0-8a44d87f19c9.jpg",
                    coverImage: "https://d3tp8cbw5vz2ok.cloudfront.net/covers/11de53a6-975f-45b7-b713-0675b34f6375.jpg",
                    subscriptionPlans: [],
                    isMonetizationComplete: true,
                    songCount: 16, albumCount: 3,
                    createdAt: "", updatedAt: ""
                )
            )
            vm.isPlaying = true
            vm.progress = 0.35
            return vm
        }())
}
