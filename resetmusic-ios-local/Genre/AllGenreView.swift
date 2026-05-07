//
//  AllGenreView.swift
//  resetmusic-ios-local
//
//  Created by resetstudio01  on 22/04/26.
//


import SwiftUI

struct AllGenreView: View {

    @State private var showNavTitle = false
    @Environment(\.dismiss) private var dismiss

    private let genres: [String] = [
        "electronic", "ambient", "idm",
        "downtempo", "experimental", "industrial",
        "noise", "soundtrack", "avantegarde"
    ]

    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {

                // 🔥 Scroll detection
                GeometryReader { geo in
                    Color.clear
                        .onChange(of: geo.frame(in: .global).minY) { _, value in
                            withAnimation(.easeInOut(duration: 0.2)) {
                                showNavTitle = value < 80
                            }
                        }
                }
                .frame(height: 0)

                headerView

                // 🔥 Grid
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(genres, id: \.self) { genre in
                        NavigationLink {
                            GenreDetailView(
                                slug: genre,
                                title: genre.capitalized
                            )
                        } label: {
                            GenreCardView(title: genre)
                                .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 10)
                .padding(.bottom, 60)
            }
        }
        .scrollIndicators(.hidden)
        .appBackground() // ✅ Applied here
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        
        // 🔥 Custom Toolbar
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: 44, height: 44)  // explicit HIG minimum
                }
                .buttonStyle(.plain)
                .tint(.clear)
                .contentShape(Rectangle())
            }

            ToolbarItem(placement: .principal) {
                Text("Genres")
                    .font(.custom("Jura-Bold", size: 18))
                    .foregroundColor(.white)
                    .opacity(showNavTitle ? 1 : 0)
                    .animation(.easeInOut(duration: 0.2), value: showNavTitle)
            }
        }
        .toolbarBackground(.hidden, for: .navigationBar) // ✅ Changed to .hidden
    }

    // MARK: - Header

    private var headerView: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Genres")
                .font(.custom("Jura-Bold", size: 28))
                .foregroundColor(.white)

            Text("Explore music by vibe and category")
                .font(.custom("Jura-Medium", size: 14))
                .foregroundColor(.white.opacity(0.5)) // ✅ Better contrast
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
        .padding(.bottom, 12)
        .opacity(showNavTitle ? 0 : 1)
        .offset(y: showNavTitle ? -10 : 0)
        .animation(.easeInOut(duration: 0.2), value: showNavTitle)
    }
}

#Preview {
    NavigationStack {
        AllGenreView()
            .preferredColorScheme(.dark)
    }
}
//#Preview {
//    NavigationStack {
//        AllGenreView()
//            .preferredColorScheme(.dark)
//            .environmentObject(PlayerViewModel()) 
//    }
//}
