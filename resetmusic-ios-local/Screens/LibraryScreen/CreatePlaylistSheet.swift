//
//  CreatePlaylistSheet.swift
//  resetmusic-ios-local
//
//  Created by Naushad Ali Khan on 06/04/26.
//

import SwiftUI

struct CreatePlaylistSheet: View {
    @Binding var isPresented: Bool
    @State private var playlistName: String = ""
    @FocusState private var isTextFieldFocused: Bool
    @State private var appeared: Bool = false
    var onCreate: (String) -> Void = { _ in }

    var body: some View {
        ZStack {
            // Background
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
                        Color(red: 0.2, green: 0.5, blue: 1.0).opacity(0.15),
                        Color.clear
                    ],
                    startPoint: .top,
                    endPoint: .center
                )
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Title
                Text("Create New Playlist")
                    .font(.custom("Jura-Bold", size: 24))
                    .foregroundColor(.white)
                    .padding(.top, 20)
                    .padding(.bottom, 24)
                    .opacity(appeared ? 1 : 0)
                    .offset(y: appeared ? 0 : 10)

                // Name input field
                VStack(alignment: .leading, spacing: 8) {
                    Text("PLAYLIST NAME")
                        .font(.custom("Jura-Regular", size: 12))
                        .foregroundColor(Color.white.opacity(0.8))
                        .kerning(1.5)

                    TextField("", text: $playlistName, prompt:
                        Text("My Awesome Playlist")
                            .font(.custom("Jura-Regular", size: 16))
                            .foregroundColor(Color.white.opacity(0.35))
                    )
                    .font(.custom("Jura-Regular", size: 16))
                    .foregroundColor(.white)
                    .tint(Color(red: 0.2, green: 0.5, blue: 1.0))
                    .focused($isTextFieldFocused)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 14)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white.opacity(0.08))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(
                                        isTextFieldFocused ? Color(red: 0.2, green: 0.5, blue: 1.0).opacity(0.6) : Color.white.opacity(0.15),
                                        lineWidth: 1
                                    )
                            )
                    )
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 20)
                .opacity(appeared ? 1 : 0)
                .offset(y: appeared ? 0 : 10)

                // Info text
                HStack(spacing: 8) {
                    Image(systemName: "info.circle")
                        .font(.system(size: 12))
                        .foregroundColor(Color.white.opacity(0.5))
                    
                    Text("Playlist cover will be generated automatically from your songs")
                        .font(.custom("Jura-Regular", size: 11))
                        .foregroundColor(Color.white.opacity(0.5))
                        .multilineTextAlignment(.center)
                }
                .padding(.bottom, 24)
                .opacity(appeared ? 1 : 0)
                .offset(y: appeared ? 0 : 10)

                // Create button
                Button(action: {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    let name = playlistName.trimmingCharacters(in: .whitespacesAndNewlines)
                    guard !name.isEmpty else { return }
                    onCreate(name)
                    isPresented = false
                }) {
                    Text("Create Playlist")
                        .font(.custom("Jura-SemiBold", size: 15))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(
                            playlistName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                                ? Color(red: 0.2, green: 0.5, blue: 1.0).opacity(0.3)
                                : Color(red: 0.2, green: 0.5, blue: 1.0)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }
                .buttonStyle(.plain)
                .disabled(playlistName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                .padding(.horizontal, 24)
                .padding(.bottom, 12)
                .opacity(appeared ? 1 : 0)
                .offset(y: appeared ? 0 : 10)

                // Cancel button
                Button(action: {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    isTextFieldFocused = false
                    isPresented = false
                }) {
                    Text("Cancel")
                        .font(.custom("Jura-Regular", size: 14))
                        .foregroundColor(Color.white.opacity(0.6))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                }
                .buttonStyle(.plain)
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
                .opacity(appeared ? 1 : 0)
                .offset(y: appeared ? 0 : 10)
            }
        }
        .presentationDetents([.height(380)])
        .presentationBackground(Color.clear)
        .presentationDragIndicator(.visible)
        .interactiveDismissDisabled(false)
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.75)) {
                appeared = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                isTextFieldFocused = true
            }
        }
        .onDisappear {
            appeared = false
        }
    }
}

// MARK: - Preview

#Preview {
    Color.black.ignoresSafeArea()
        .sheet(isPresented: .constant(true)) {
            CreatePlaylistSheet(isPresented: .constant(true))
        }
}
