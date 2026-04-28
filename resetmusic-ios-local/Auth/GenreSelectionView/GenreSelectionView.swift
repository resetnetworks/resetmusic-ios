//
//  GenreSelectionView.swift
//  resetmusic-ios-local
//
//  Created by Naushad Ali Khan on 12/03/26.
//

import SwiftUI

// MARK: - Genre Selection View

struct GenreSelectionView: View {

    let minimumSelection = 3
    var onContinue: ([Genre]) -> Void = { _ in }

    @State private var selectedGenres: Set<Genre> = []
    @State private var searchText: String = ""
    @FocusState private var isSearchFocused: Bool

    private let genres: [Genre] = [
        Genre(id: "electronic", name: "Electronic", slug: "electronic", description: nil, coverImage: "genre-electronic", songCount: nil, albumCount: nil),
        Genre(id: "idm", name: "IDM", slug: "idm", description: nil, coverImage: "genre-idm", songCount: nil, albumCount: nil),
        Genre(id: "ambient", name: "Ambient", slug: "ambient", description: nil, coverImage: "genre-ambient", songCount: nil, albumCount: nil),
        Genre(id: "experimental", name: "Experimental", slug: "experimental", description: nil, coverImage: "genre-experimental", songCount: nil, albumCount: nil),
        Genre(id: "avant-garde", name: "Avant Garde", slug: "avant-garde", description: nil, coverImage: "genre-avantegarde", songCount: nil, albumCount: nil),
        Genre(id: "noise", name: "Noise", slug: "noise", description: nil, coverImage: "genre-noise", songCount: nil, albumCount: nil),
        Genre(id: "downtempo", name: "Downtempo", slug: "downtempo", description: nil, coverImage: "genre-downtempo", songCount: nil, albumCount: nil),
        Genre(id: "soundtrack", name: "Soundtrack", slug: "soundtrack", description: nil, coverImage: "genre-soundtrack", songCount: nil, albumCount: nil),
        Genre(id: "industrial", name: "Industrial", slug: "industrial", description: nil, coverImage: "genre-industrial", songCount: nil, albumCount: nil),
        Genre(id: "dance", name: "Dance", slug: "dance", description: nil, coverImage: "genre-dance", songCount: nil, albumCount: nil),
        Genre(id: "electronica", name: "Electronica", slug: "electronica", description: nil, coverImage: "genre-electronica", songCount: nil, albumCount: nil),
        Genre(id: "sound-art", name: "Sound Art", slug: "sound-art", description: nil, coverImage: "genre-soundart", songCount: nil, albumCount: nil),
        Genre(id: "jazz", name: "Jazz", slug: "jazz", description: nil, coverImage: "genre-jazz", songCount: nil, albumCount: nil),
        Genre(id: "classical", name: "Classical", slug: "classical", description: nil, coverImage: "genre-classical", songCount: nil, albumCount: nil),
        Genre(id: "soundscapes", name: "Soundscapes", slug: "soundscapes", description: nil, coverImage: "genre-soundscapes", songCount: nil, albumCount: nil),
        Genre(id: "field-recordings", name: "Field Recordings", slug: "field-recordings", description: nil, coverImage: "genre-fieldrecordings", songCount: nil, albumCount: nil),
    ]

    private var filteredGenres: [Genre] {
        if searchText.isEmpty { return genres }
        return genres.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }

    private var isSelectionValid: Bool {
        selectedGenres.count >= minimumSelection
    }

    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16),
    ]

    var body: some View {
        VStack(spacing: 0) {

            // Logo
            Image("logo-icon")
                .resizable()
                .scaledToFit()
                .frame(width: 42, height: 42)
                .padding(.top, 32)
                .padding(.bottom, 24)

            // Title
            VStack(spacing: 6) {
                            HStack(spacing: 6) {
                                Text("Choose")
                                    .font(.custom("Jura-Bold", size: 22))
                                    .foregroundColor(Color(red: 0.25, green: 0.55, blue: 1.0))
                                Text("favourite genres")
                                    .font(.custom("Jura-Bold", size: 22))
                                    .foregroundColor(.white)
                            }
             
                            Text("\(selectedGenres.count) / \(minimumSelection) selected")
                                .font(.custom("Jura-Regular", size: 13))
                                .foregroundColor(isSelectionValid
                                    ? Color(red: 0.2, green: 0.85, blue: 0.5)
                                    : .white.opacity(0.4))
                                .animation(.easeInOut, value: isSelectionValid)
                        }

            .padding(.bottom, 20)

            // Search bar
            HStack(spacing: 10) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 14))
                    .foregroundColor(isSearchFocused
                        ? Color(red: 0.25, green: 0.55, blue: 1.0)
                        : .white.opacity(0.4))
                    .animation(.easeInOut(duration: 0.2), value: isSearchFocused)

                ZStack(alignment: .leading) {
                    if searchText.isEmpty {
                        Text("Search genres...")
                            .font(.custom("Jura-Regular", size: 14))
                            .foregroundColor(.white.opacity(0.3))
                    }
                    TextField("", text: $searchText)
                        .font(.custom("Jura-Regular", size: 14))
                        .foregroundColor(.white)
                        .tint(Color(red: 0.25, green: 0.55, blue: 1.0))
                        .focused($isSearchFocused)
                }

                if !searchText.isEmpty {
                    Button(action: { searchText = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 14))
                            .foregroundColor(.white.opacity(0.3))
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color(red: 0.08, green: 0.10, blue: 0.18))
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(
                        isSearchFocused
                            ? Color(red: 0.25, green: 0.55, blue: 1.0)
                            : Color.white.opacity(0.1),
                        lineWidth: isSearchFocused ? 1.5 : 1
                    )
                    .animation(.easeInOut(duration: 0.2), value: isSearchFocused)
            )
            .padding(.horizontal, 20)
            .padding(.bottom, 48)

            // Genre grid
            ScrollView(.vertical, showsIndicators: false) {
                LazyVGrid(columns: columns, spacing: 24) {
                    ForEach(filteredGenres) { genre in
                        GenreSelectionCell(
                            genre: genre,
                            isSelected: selectedGenres.contains(genre)
                        ) {
                            toggleGenre(genre)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 100)
            }
        }
//        .onTapGesture { isSearchFocused = false }
        .overlay(alignment: .bottom) {
            // Continue button
            VStack(spacing: 0) {
                LinearGradient(
                    colors: [Color(red: 0.01, green: 0.06, blue: 0.15).opacity(0), Color(red: 0.01, green: 0.06, blue: 0.15)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 32)

                AuthPrimaryButton(title: "Continue") {
                    onContinue(Array(selectedGenres))
                }
                .opacity(isSelectionValid ? 1 : 0.4)
                .disabled(!isSelectionValid)
                .padding(.horizontal, 20)
                .padding(.bottom, 36)
                .background(Color(red: 0.01, green: 0.06, blue: 0.15))
            }
        }
        .onTapGesture { UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil) }
        .appBackground()
    }

    private func toggleGenre(_ genre: Genre) {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            if selectedGenres.contains(genre) {
                selectedGenres.remove(genre)
            } else {
                selectedGenres.insert(genre)
            }
        }
    }
}

// MARK: - Genre Cell

struct GenreSelectionCell: View {
    let genre: Genre
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 10) {
                ZStack {
                    if let coverImage = genre.coverImage {
                        Image(coverImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 110, height: 110)
                            .clipShape(Circle())
                            .saturation(isSelected ? 1.0 : 0.7)
                            .overlay(
                                Circle()
                                    .stroke(
                                        isSelected
                                            ? Color(red: 0.25, green: 0.55, blue: 1.0)
                                            : Color.clear,
                                        lineWidth: 2.5
                                    )
                            )
                    } else {
                        Circle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 110, height: 110)
                    }

                    // Checkmark overlay
                    if isSelected {
                        Circle()
                            .fill(Color(red: 0.2, green: 0.5, blue: 1.0))
                            .frame(width: 26, height: 26)
                            .overlay(
                                Image(systemName: "checkmark")
                                    .font(.system(size: 11, weight: .bold))
                                    .foregroundColor(.white)
                            )
                            .offset(x: 32, y: 32)
                            .transition(.scale.combined(with: .opacity))
                    }
                }
                .scaleEffect(isSelected ? 1.05 : 1.0)
                .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)

                Text("#\(genre.name)")
                    .font(.custom("Jura-Regular", size: 13))
                    .foregroundColor(isSelected ? .white : .white.opacity(0.6))
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview

#Preview {
    GenreSelectionView()
}
