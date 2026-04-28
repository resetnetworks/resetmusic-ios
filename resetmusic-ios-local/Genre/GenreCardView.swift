//
//  GenreCardView.swift
//  trial
//
//  Created by Naushad Ali Khan on 25/02/26.
//

import SwiftUI

import SwiftUI

struct GenreCardView: View {
    var title: String

    private var imageName: String { "genre-\(title.lowercased())" }

    var body: some View {
        ZStack(alignment: .bottom) {
            Image(imageName)
                .resizable()
                .scaledToFill()
                .frame(minWidth: 0, minHeight: 0)
                .clipped()

            LinearGradient(
                colors: [.clear, .blue.opacity(0.8)],
                startPoint: .center,
                endPoint: .bottom
            )

            Text(title)
                .font(.custom("Jura-Bold", size: 12))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(12)
        }
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
#Preview {
    HStack(spacing: 12) {
        GenreCardView(title: "electronic").frame(width: 200, height: 248)
        VStack(spacing: 12) {
            GenreCardView(title: "ambient").frame(width: 200, height: 112)
            GenreCardView(title: "idm").frame(width: 200, height: 112)
        }
    }
    .padding()
    .background(Color(red: 0.05, green: 0.05, blue: 0.15))
}
