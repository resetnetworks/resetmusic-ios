//
//  AlbumCardSkeleton.swift
//  resetmusic-ios-local
//
//  Created by resetstudio01  on 23/04/26.
//


import SwiftUI

struct AlbumCardSkeleton: View {
    
    @State private var isPulsing = false
    
    private enum Layout {
        static let width: CGFloat = 172
        static let imageHeight: CGFloat = 160
        static let cornerRadius: CGFloat = 8
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            // Cover
            RoundedRectangle(cornerRadius: 6)
                .fill(Color.white.opacity(0.06))
                .frame(width: Layout.width, height: Layout.imageHeight)
            
            // Info
            HStack(spacing: 6) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.white.opacity(0.05))
                    .frame(width: 50, height: 10)
                
                Spacer()
                
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.white.opacity(0.08))
                    .frame(width: 80, height: 12)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
        }
        .frame(width: Layout.width)
        .background(Color(red: 0.047, green: 0.090, blue: 0.153))
        .cornerRadius(Layout.cornerRadius)
        .opacity(isPulsing ? 0.85 : 1.0)
        .onAppear {
            withAnimation(
                .easeInOut(duration: 1.2)
                .repeatForever(autoreverses: true)
            ) {
                isPulsing = true
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
