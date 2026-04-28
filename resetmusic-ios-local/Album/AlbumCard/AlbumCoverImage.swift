//
//  AlbumCoverImage.swift
//  resetmusic-ios-local
//
//  Created by Naushad Ali Khan on 06/03/26.
//
//
import SwiftUI
import Kingfisher

struct AlbumCoverImage: View {

    let urlString: String?

    // ✅ Size injected from parent — no hardcoded values
    var width: CGFloat = 172
    var height: CGFloat = 160

    var body: some View {
        if let urlString, let url = URL(string: urlString) {
            KFImage(url)
                .placeholder { placeholder }
                .onFailure { _ in }
                .resizable()
                .scaledToFill()
//                .scaledToFit()
                .frame(width: width, height: height)
                .clipped()
                .saturation(0)
                .drawingGroup()
        } else {
            placeholder
        }
    }

    private var placeholder: some View {
        Image("yashuka")
            .resizable()
            .scaledToFill()
            .frame(width: width, height: height)
            .clipped()
            .saturation(0)
            .drawingGroup()
    }
}
