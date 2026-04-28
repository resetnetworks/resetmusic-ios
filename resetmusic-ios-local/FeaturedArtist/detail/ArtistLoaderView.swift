//
//  ArtistLoaderView.swift
//  resetmusic-ios-local
//
//  Created by Naushad Ali Khan on 14/04/26.
//


import SwiftUI

struct ArtistLoaderView: View {
    let artistId: String
    let artistName: String

    @StateObject private var vm = ArtistDetailViewModel()
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        Group {
            if let artist = vm.artist {
                ArtistDetailView(artist: artist)
            } else if vm.isLoading {
                VStack {
                    Spacer()
                    ProgressView()
                        .tint(.white)
                    Spacer()
                }
                .appBackground()
                .navigationBarBackButtonHidden(true)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: { dismiss() }) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                        }
                        .buttonStyle(.plain)
                    }
                    ToolbarItem(placement: .principal) {
                        Text(artistName)
                            .font(.custom("Jura-SemiBold", size: 16))
                            .foregroundColor(.white)
                    }
                }
                .toolbarBackground(.hidden, for: .navigationBar)
            } else {
                // failed to load
                VStack(spacing: 12) {
                    Spacer()
                    Image(systemName: "exclamationmark.circle")
                        .font(.system(size: 32))
                        .foregroundColor(.white.opacity(0.4))
                    Text("Couldn't load artist")
                        .font(.custom("Jura-Regular", size: 15))
                        .foregroundColor(.white.opacity(0.5))
                    Spacer()
                }
                .appBackground()
            }
        }
        .task { await vm.load(artistId: artistId) }
    }
}
