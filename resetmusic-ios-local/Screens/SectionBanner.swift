//
//  SectionBanner.swift
//  trial
//
//  Created by Naushad Ali Khan on 25/02/26.
//

import SwiftUI
struct SectionBanner: View {
    var title: String
    var horizontalPadding: CGFloat = 16

    var body: some View {
        Text(title)
            .font(.custom("Jura-Bold", size: 24))
            .foregroundColor(.white)
            .padding(.horizontal, horizontalPadding)
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        SectionBanner(title: "new albums for you")
    }
}
