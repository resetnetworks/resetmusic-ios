//
//  PlayerProgressBar.swift
//  resetmusic-ios-local
//
//  Created by Naushad Ali Khan on 13/03/26.
//


// MARK: - PlayerProgressBar.swift
import SwiftUI
struct PlayerProgressBar: View {
    var progress: CGFloat

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(Color.white.opacity(0.12))
                    .frame(height: 2)
                Rectangle()
                    .fill(Color(red: 0.25, green: 0.55, blue: 1.0))
                    .frame(width: geo.size.width * progress, height: 2)
                    .animation(.linear(duration: 0.3), value: progress)
            }
        }
        .frame(height: 2)
    }
}
#Preview {
    VStack(spacing: 20) {
        // Empty
        PlayerProgressBar(progress: 0.0)
        // Mid
        PlayerProgressBar(progress: 0.45)
        // Almost done
        PlayerProgressBar(progress: 0.9)
    }
    .padding()
    .background(Color(red: 0.04, green: 0.07, blue: 0.18))
}
