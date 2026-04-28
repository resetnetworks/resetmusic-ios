//
//  LikeButton.swift
//  resetmusic-ios-local
//
//  Created by Naushad Ali Khan on 13/04/26.
//


import SwiftUI

struct LikeButton: View {
    @Binding var isLiked: Bool

    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                isLiked.toggle()
            }
        }) {
            Image(systemName: isLiked ? "heart.fill" : "heart")
                .font(.system(size: 18))
                .foregroundColor(isLiked ? Color(hex: "3B82F6") : Color.white.opacity(0.3))
                .scaleEffect(isLiked ? 1.15 : 1.0)
        }
        .buttonStyle(.plain)
    }
}