//
//  CreatePlaylistRow.swift
//  resetmusic-ios-local
//
//  Created by Naushad Ali Khan on 13/04/26.
//


import SwiftUI

struct CreatePlaylistRow: View {
    var action: () -> Void = {}

    @State private var isPressed = false

    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {

                dashedTile

                Text("Create New Playlist")
                    .font(.custom("Jura-SemiBold", size: 15))
                    .foregroundColor(Color(hex: "3B82F6"))

                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(hex: "3B82F6").opacity(0.05))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(
                                Color.white.opacity(0.25), // 👈 softer border
                                style: StrokeStyle(lineWidth: 1.2, dash: [6, 4])
                            )
                    )
            )
            .scaleEffect(isPressed ? 0.97 : 1.0) // 👈 press feedback
            .animation(.easeOut(duration: 0.15), value: isPressed)
        }
        .buttonStyle(.plain)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true }
                .onEnded { _ in isPressed = false }
        )
    }

    // MARK: - Left Dashed Tile

    private var dashedTile: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .stroke(
                    Color.white.opacity(0.25), // 👈 softer
                    style: StrokeStyle(lineWidth: 1.2, dash: [6, 4])
                )
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white.opacity(0.02)) // 👈 subtle fill
                )
                .frame(width: 52, height: 52)

            Image(systemName: "plus")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(Color.white.opacity(0.9))
        }
    }
}
