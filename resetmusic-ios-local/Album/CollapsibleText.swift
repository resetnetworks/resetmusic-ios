//
//  CollapsibleText.swift
//  resetmusic-ios-local
//
//  Created by Naushad Ali Khan on 14/03/26.
//


import SwiftUI

struct CollapsibleText: View {
    let text: String
    var lineLimit: Int = 4

    @State private var isExpanded: Bool = false
    @State private var isTruncated: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(text)
                .font(.custom("Jura-Regular", size: 14))
                .foregroundColor(.white.opacity(0.6))
                .lineSpacing(4)
                .lineLimit(isExpanded ? nil : lineLimit)
                .background(
                    // Detect truncation by comparing full height vs limited height
                    GeometryReader { geo in
                        Color.clear.onAppear {
                            let fullHeight = measureFullHeight(text: text, width: geo.size.width)
                            isTruncated = fullHeight > geo.size.height + 1
                        }
                    }
                )

            if isTruncated || isExpanded {
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.25)) {
                        isExpanded.toggle()
                    }
                }) {
                    Text(isExpanded ? "show less" : "show more...")
                        .font(.custom("Jura-SemiBold", size: 13))
                        .foregroundColor(Color(red: 0.25, green: 0.55, blue: 1.0))
                }
                .buttonStyle(.plain)
            }
        }
    }

    private func measureFullHeight(text: String, width: CGFloat) -> CGFloat {
        let font = UIFont(name: "Jura-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14)
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = (text as NSString).boundingRect(
            with: constraintRect,
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: [.font: font],
            context: nil
        )
        return boundingBox.height
    }
}
