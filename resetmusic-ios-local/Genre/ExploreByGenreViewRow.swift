//
//  ExploreByGenreViewRow.swift
//  trial
//
//  Created by Naushad Ali Khan on 25/02/26.
//
import SwiftUI

struct ExploreByGenreViewRow: View {

    // ✅ Callback for ViewAll button
    var onViewAll: (() -> Void)?
    @State private var showAllGenres = false
    
    private let groups: [[String]] = [
        ["electronic", "ambient", "idm"],
        ["downtempo", "experimental", "industrial"],
        ["noise", "soundtrack", "avantegarde"],
    ]

    // ✅ Single initializer
    init(onViewAll: (() -> Void)? = nil) {
        self.onViewAll = onViewAll
    }

    var body: some View {
        GeometryReader { geo in
            let bigW   = geo.size.width * 0.65
            let smallW = geo.size.width * 0.65
            let bigH   = geo.size.height * 0.85
            let smallH = (bigH - 24) / 2
            let pageW  = bigW + 24 + smallW + 32

            VStack(alignment: .leading, spacing: 12) {

                // ✅ HEADER
                HStack(alignment: .center) {
                    SectionBanner(title: "explore by Genre", horizontalPadding: 0)

                    Spacer()

                    ViewAllButton {
                        if let onViewAll {
                            onViewAll()   // 👉 parent handles navigation
                        } else {
                            showAllGenres = true // 👉 fallback
                        }
                    }
                }
                .padding(.horizontal, 10)
                .padding(.bottom, 12)

                // ✅ SCROLL
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: .top, spacing: 0) {
                        ForEach(Array(groups.enumerated()), id: \.offset) { index, group in
                            HStack(alignment: .top, spacing: 24) {

                                // BIG CARD
                                NavigationLink {
                                    GenreDetailView(
                                        slug: group[0],
                                        title: group[0].capitalized
                                    )
                                } label: {
                                    GenreCardView(title: group[0])
                                        .contentShape(Rectangle())
                                }
                                .buttonStyle(.plain)
                                .frame(width: bigW, height: bigH)

                                // SMALL CARDS
                                VStack(spacing: 24) {

                                    NavigationLink {
                                        GenreDetailView(
                                            slug: group[1],
                                            title: group[1].capitalized
                                        )
                                    } label: {
                                        GenreCardView(title: group[1])
                                            .contentShape(Rectangle())
                                    }
                                    .buttonStyle(.plain)
                                    .frame(width: smallW, height: smallH)

                                    NavigationLink {
                                        GenreDetailView(
                                            slug: group[2],
                                            title: group[2].capitalized
                                        )
                                    } label: {
                                        GenreCardView(title: group[2])
                                            .contentShape(Rectangle())
                                    }
                                    .buttonStyle(.plain)
                                    .frame(width: smallW, height: smallH)
                                }
                            }
                            .padding(.leading, 16)
                            .frame(width: pageW, alignment: .leading)
                            .id(index)
                        }
                    }
                    .scrollTargetLayout()
                }
                .scrollTargetBehavior(.viewAligned)
            }
        }
        .frame(height: 320)

        // ✅ FALLBACK NAVIGATION - Opens AllGenreView
        .navigationDestination(isPresented: $showAllGenres) {
            AllGenreView()
        }
    }
}

#Preview {
    NavigationStack {
        ZStack {
            Color(red: 0.05, green: 0.05, blue: 0.15)
                .ignoresSafeArea()

            ScrollView {
                ExploreByGenreViewRow()
            }
        }
    }
}
