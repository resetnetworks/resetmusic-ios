//
//  HomeIcon.swift
//  resetmusic-ios-local
//
//  Created by Naushad Ali Khan on 09/03/26.
//


import SwiftUI

/// Sleek custom house icon — one unified path, no chimney, no seam
struct HomeIcon: View {
    var size: CGFloat = 22
    var color: Color = .white

    var body: some View {
        Canvas { context, canvasSize in
            let w = canvasSize.width
            let h = canvasSize.height

            // ✅ Single unified path — roof flows directly into walls
            var house = Path()

            // Peak of roof
            house.move(to: CGPoint(x: w * 0.50, y: h * 0.02))
            // Right slope down to right wall top
            house.addLine(to: CGPoint(x: w * 0.96, y: h * 0.46))
            // Right wall down to bottom-right
            house.addLine(to: CGPoint(x: w * 0.96, y: h * 0.98))
            // Bottom-right to bottom of door right
            house.addLine(to: CGPoint(x: w * 0.65, y: h * 0.98))
            // Door right side up
            house.addLine(to: CGPoint(x: w * 0.65, y: h * 0.62))
            // Door top (slightly rounded feel via two lines)
            house.addLine(to: CGPoint(x: w * 0.35, y: h * 0.62))
            // Door left side down
            house.addLine(to: CGPoint(x: w * 0.35, y: h * 0.98))
            // Bottom-left corner
            house.addLine(to: CGPoint(x: w * 0.04, y: h * 0.98))
            // Left wall up to left slope
            house.addLine(to: CGPoint(x: w * 0.04, y: h * 0.46))
            // Left slope back to peak
            house.addLine(to: CGPoint(x: w * 0.50, y: h * 0.02))
            house.closeSubpath()

            context.fill(house, with: .color(color))
        }
        .frame(width: size, height: size)
    }
}

#Preview {
    ZStack {
        Color(red: 0.07, green: 0.09, blue: 0.14).ignoresSafeArea()
        VStack(spacing: 24) {
            HomeIcon(size: 28, color: Color(red: 0.25, green: 0.55, blue: 1.0))
            HomeIcon(size: 28, color: .white.opacity(0.4))
        }
    }
}
