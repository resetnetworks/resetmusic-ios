//
//  MoreActionRow.swift
//  resetmusic-ios-local
//
//  Created by Naushad Ali Khan on 13/04/26.
//

import SwiftUI
struct MoreActionRow: View {
    let icon: String
    let title: String
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {

                Image(systemName: icon)
                    .font(.system(size: 20))
                    .frame(width: 28)
                    .foregroundColor(.white.opacity(0.8))

                Text(title)
                    .font(.custom("Jura-Medium", size: 16))
                    .foregroundColor(.white)

                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
        .buttonStyle(.plain)
    }
}
