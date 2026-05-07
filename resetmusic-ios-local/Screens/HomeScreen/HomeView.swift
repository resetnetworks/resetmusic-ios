//
//  HomeView.swift
//  resetmusic-ios-local
//
//  Created by Naushad Ali Khan on 06/03/26.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var playerVM: PlayerViewModel
    var onProfileTap: () -> Void = {}

    var body: some View {
        VStack(spacing: 0) {
            AppTopBar(mode: .home(userName: "Guest"), onProfileTap: onProfileTap)

            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 32) {
                    // ✅ Don't pass onViewAll - let them handle it internally
                    AlbumCardRow()
                    FeaturedArtistRow()
                    ExploreByGenreViewRow()
                }
                .padding(.vertical, 24)
                .padding(.bottom, 100)
            }
        }
        .appBackground()
    }
}

#Preview {
    NavigationStack { HomeView() }
        .environmentObject({
            let vm = PlayerViewModel()
            vm.currentTrack = PlayerTrack(
                title: "Shifting Layers",
                artistName: "Nariel",
                artistId: "nariel-id",
                coverImage: "https://d3tp8cbw5vz2ok.cloudfront.net/covers/11de53a6-975f-45b7-b713-0675b34f6375.jpg"
            )
            vm.isPlaying = true
            return vm
        }())
}

#Preview("Empty Player") {
    NavigationStack { HomeView() }
        .environmentObject(PlayerViewModel())
}
