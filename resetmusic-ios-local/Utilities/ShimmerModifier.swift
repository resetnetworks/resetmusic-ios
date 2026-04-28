//
//  ShimmerModifier.swift
//  resetmusic-ios-local
//
//  Created by resetstudio01  on 23/04/26.
//

import SwiftUI

struct ShimmerModifier: ViewModifier {
    @State private var phase: CGFloat = -0.8

    func body(content: Content) -> some View {
        content
            .overlay(
                LinearGradient(
                    colors: [
                        .clear,
                        .white.opacity(0.25),
                        .clear
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .rotationEffect(.degrees(30))
                .offset(x: phase * 300)
            )
            .mask(content)
            .onAppear {
                withAnimation(.linear(duration: 1.2).repeatForever(autoreverses: false)) {
                    phase = 0.8
                }
            }
    }
}

extension View {
    func shimmer() -> some View {
        modifier(ShimmerModifier())
    }
}
