//
//  SearchField.swift
//  resetmusic-ios-local
//
//  Created by Naushad Ali Khan on 09/03/26.
//


import SwiftUI

struct SearchField: View {
    @Binding var text: String
    var placeholderText: String = "Search"

    @FocusState private var isFocused: Bool

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.gray)
                .padding(.leading, 16)

            TextField("", text: $text)
                .placeholder(when: text.isEmpty) {
                    Text(placeholderText)
                        .font(.custom("Jura-Regular", size: 16))
                        .foregroundColor(.gray.opacity(0.7))
                }
                .font(.custom("Jura-Regular", size: 16))
                .foregroundColor(.white)
                .padding(.vertical, 14)
                .focused($isFocused)

//            Button(action: {}) {
//                Image(systemName: "mic.fill")
//                    .font(.system(size: 16))
//                    .foregroundColor(.gray)
//                    .padding(.trailing, 16)
//            }
//            .buttonStyle(.plain)
        }
        .frame(maxWidth: .infinity)
        .background(Color(red: 0.18, green: 0.2, blue: 0.24))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(
                    isFocused
                        ? Color.white.opacity(0.6) // ✅ full border
                        : Color.clear,
                    lineWidth: 1.2
                )
                .animation(.easeInOut(duration: 0.2), value: isFocused)
        )
        .cornerRadius(10)
        .onTapGesture {
            isFocused = true
        }
    }

    func dismissFocus() {
        isFocused = false
    }
}
extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        @ViewBuilder placeholder: () -> Content
    ) -> some View {
        ZStack(alignment: .leading) {
            if shouldShow { placeholder() }
            self
        }
    }
}

#Preview {
    ZStack {
        Color(red: 0.08, green: 0.1, blue: 0.14).ignoresSafeArea()
        SearchField(text: .constant(""))
            .padding(.horizontal, 16)
    }
}
