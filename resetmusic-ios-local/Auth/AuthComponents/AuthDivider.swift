//
//  AuthDivider.swift
//  resetmusic-ios-local
//
//  Created by Naushad Ali Khan on 12/03/26.
//


import SwiftUI

struct AuthDivider: View {
    let label: String

    var body: some View {
        HStack(spacing: 12) {
            Rectangle()
                .fill(Color.white.opacity(0.12))
                .frame(height: 1)
            Text(label)
                .font(.custom("Jura-Regular", size: 12))
                .foregroundColor(.white.opacity(0.4))
                .fixedSize()
            Rectangle()
                .fill(Color.white.opacity(0.12))
                .frame(height: 1)
        }
    }
}