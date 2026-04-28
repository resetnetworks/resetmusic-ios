//
//  AlbumCardSkeleton.swift
//  resetmusic-ios-local
//
//  Created by resetstudio01  on 23/04/26.
//


import SwiftUI

struct AlbumCardSkeleton: View {
    
    @State private var isAnimating = false
    
    private enum Layout {
        static let width: CGFloat = 172
        static let imageHeight: CGFloat = 160
        static let cornerRadius: CGFloat = 8
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Cover skeleton
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.06),
                            Color.white.opacity(0.12),
                            Color.white.opacity(0.06)
                        ],
                        startPoint: isAnimating ? .leading : .trailing,
                        endPoint: isAnimating ? .trailing : .leading
                    )
                )
                .frame(width: Layout.width, height: Layout.imageHeight)
            
            // Info skeleton
            HStack(spacing: 4) {
                // "by artist" skeleton
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.white.opacity(0.06))
                    .frame(width: 50, height: 12)
                
                Spacer()
                
                // Artist name skeleton
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.white.opacity(0.08))
                    .frame(width: 80, height: 13)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
        }
        .frame(width: Layout.width)
        .background(Color(red: 0.047, green: 0.090, blue: 0.153))
        .cornerRadius(Layout.cornerRadius)
        .clipped()
        .onAppear {
            withAnimation(
                .linear(duration: 1.5)
                .repeatForever(autoreverses: true)
            ) {
                isAnimating = true
            }
        }
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        AlbumCardSkeleton()
    }
}
