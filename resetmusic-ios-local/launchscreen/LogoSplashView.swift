//
//  LogoSplashView.swift
//  resetmusic-ios-local
//
//  Created by Naushad Ali Khan on 13/03/26.
//


import SwiftUI

struct LogoSplashView: View {

    @State private var progress: CGFloat = 0.0

    var body: some View {

        ZStack {
            Color.black.ignoresSafeArea()

            ZStack {

                // Circle arc: gap at top where line sits (~300° arc)
                // trim(from: 0.08, to: 0.92) leaves ~16% gap at top = ~58° gap
                // rotationEffect(-90°) puts 0 at top, so gap is centered at top
                Circle()
                    .trim(from: 0.08, to: 0.08 + progress)
                    .stroke(
                        LinearGradient(
                            colors: [Color(red: 0.1, green: 0.3, blue: 0.9), Color(red: 0.2, green: 0.7, blue: 1.0)],
                            startPoint: .bottom,
                            endPoint: .top
                        ),
                        style: StrokeStyle(lineWidth: 7, lineCap: .round)
                    )
                    .frame(width: 112, height: 110)
                    .rotationEffect(.degrees(-90 + (0.08 * 360))) // start just right of top-left gap

                // Vertical line — sits in the gap at the top center
                Capsule()
                    .fill(
                        LinearGradient(
                            colors: [Color(red: 0.2, green: 0.7, blue: 1.0), Color(red: 0.1, green: 0.3, blue: 0.9)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: 7, height: 100)
                    .offset(y: -38)
                    .offset(x: 26)
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.5)) {
                progress = 0.88
            }
        }
    }
}

#Preview {
    LogoSplashView()
}
