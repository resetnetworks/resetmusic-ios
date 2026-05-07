//
//  GuestModeDrawerView.swift
//  resetmusic-ios-local
//
//  Created by Codex on 24/04/26.
//

import SwiftUI

struct GuestModeDrawerView: View {
    let displayName: String
    var onClose: () -> Void
    var onLogout: () async -> Void
    @State private var isLoggingOut = false

    init(
        displayName: String,
        onClose: @escaping () -> Void,
        onLogout: @escaping () async -> Void
    ) {
        self.displayName = displayName
        self.onClose = onClose
        self.onLogout = onLogout
    }

    private let items: [GuestDrawerItem] = [
        GuestDrawerItem(
            title: "Privacy policy",
            subtitle: "How Reset Music handles your data",
            systemImage: "hand.raised.circle",
            urlString: "https://musicreset.com/privacy-policy"
        ),
        GuestDrawerItem(
            title: "Terms and conditions",
            subtitle: "Rules, usage terms, and legal details",
            systemImage: "doc.text",
            urlString: "https://musicreset.com/terms-and-conditions"
        ),
        GuestDrawerItem(
            title: "Help and support",
            subtitle: "Contact the Reset Music team",
            systemImage: "questionmark.circle",
            urlString: "https://musicreset.com/contact-us"
        )
    ]

    var body: some View {
        ZStack(alignment: .topLeading) {
            LinearGradient(
                stops: [
                    .init(color: Color(hex: "07111F"), location: 0.0),
                    .init(color: Color(hex: "030914"), location: 0.6),
                    .init(color: .black, location: 1.0)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            GuestDrawerPatternOverlay()
                .opacity(0.26)

            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 22) {
                    header

                    VStack(alignment: .leading, spacing: 10) {
                        Text("Account")
                            .font(.custom("Jura-SemiBold", size: 13))
                            .foregroundColor(.white.opacity(0.55))
                            .padding(.horizontal, 4)

                        VStack(spacing: 0) {
                            ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                                guestRow(item)

                                if index < items.count - 1 {
                                    Divider()
                                        .overlay(Color.white.opacity(0.08))
                                        .padding(.leading, 56)
                                }
                            }
                        }
                        .background(Color.white.opacity(0.04))
                        .clipShape(RoundedRectangle(cornerRadius: 22))
                        .overlay(
                            RoundedRectangle(cornerRadius: 22)
                                .stroke(Color.white.opacity(0.08), lineWidth: 1)
                        )
                    }

                    Button(action: {
                        guard !isLoggingOut else { return }
                        Task {
                            isLoggingOut = true
                            await onLogout()
                            isLoggingOut = false
                        }
                    }) {
                        HStack(spacing: 12) {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(Color(red: 0.25, green: 0.55, blue: 1.0))
                                .frame(width: 26)

                            Text(isLoggingOut ? "Logging out..." : "Logout")
                                .font(.custom("Jura-SemiBold", size: 15))
                                .foregroundColor(.white)

                            Spacer()
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 16)
                        .background(Color.white.opacity(0.04))
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                        .overlay(
                            RoundedRectangle(cornerRadius: 18)
                                .stroke(Color.white.opacity(0.08), lineWidth: 1)
                        )
                    }
                    .buttonStyle(.plain)
                    .disabled(isLoggingOut)
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
                .padding(.bottom, 42)
            }
        }
        .toolbar(.hidden, for: .navigationBar)
    }
}

private extension GuestModeDrawerView {
    var header: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack {
                Button(action: onClose) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: 40, height: 40)
                        .background(Color.white.opacity(0.08))
                        .clipShape(Circle())
                }
                .buttonStyle(.plain)

                Spacer()

                Text("Menu")
                    .font(.custom("Jura-Bold", size: 18))
                    .foregroundColor(.white)

                Spacer()

                Color.clear
                    .frame(width: 40, height: 40)
            }

            VStack(alignment: .leading, spacing: 10) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color(red: 0.25, green: 0.55, blue: 1.0),
                                    Color(red: 0.15, green: 0.25, blue: 0.65)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 84, height: 84)

                    Image(systemName: "person.fill")
                        .font(.system(size: 30, weight: .medium))
                        .foregroundColor(.white)
                }

                Text(displayName)
                    .font(.custom("Jura-Bold", size: 30))
                    .foregroundColor(.white)

                Text("Enjoy streaming your favorite tracks anytime.")
                    .font(.custom("Jura-Regular", size: 14))
                    .foregroundColor(.white.opacity(0.56))

                Text("More features like personalization and saved preferences will be available soon.")
                    .font(.custom("Jura-Regular", size: 13))
                    .foregroundColor(.white.opacity(0.4))            }
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                LinearGradient(
                    colors: [
                        Color(red: 0.09, green: 0.18, blue: 0.32).opacity(0.95),
                        Color.white.opacity(0.05)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
            )
        }
    }

    func guestRow(_ item: GuestDrawerItem) -> some View {
        Group {
            if let url = item.url {
                Link(destination: url) {
                    rowLabel(for: item)
                }
            } else {
                Button(action: {}) {
                    rowLabel(for: item)
                }
                .disabled(true)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .contentShape(Rectangle())
        .buttonStyle(.plain)
    }

    func rowLabel(for item: GuestDrawerItem) -> some View {
        HStack(spacing: 14) {
            Image(systemName: item.systemImage)
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(Color(red: 0.25, green: 0.55, blue: 1.0))
                .frame(width: 26)

            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .font(.custom("Jura-SemiBold", size: 15))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Text(item.subtitle)
                    .font(.custom("Jura-Regular", size: 12))
                    .foregroundColor(.white.opacity(0.5))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            Image(systemName: "square.and.arrow.up.right")
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.white.opacity(0.3))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .contentShape(Rectangle())
    }
}

private struct GuestDrawerItem: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let systemImage: String
    let urlString: String

    var url: URL? {
        URL(string: urlString)
    }
}

private struct GuestDrawerPatternOverlay: View {
    var body: some View {
        GeometryReader { _ in
            Canvas { context, size in
                let spacing: CGFloat = 34
                var column = 0

                while CGFloat(column) * spacing < size.width + spacing {
                    var row = 0

                    while CGFloat(row) * spacing < size.height + spacing {
                        let rect = CGRect(
                            x: CGFloat(column) * spacing,
                            y: CGFloat(row) * spacing,
                            width: 1.5,
                            height: 1.5
                        )
                        context.fill(Path(ellipseIn: rect), with: .color(.white.opacity(0.05)))
                        row += 1
                    }

                    column += 1
                }
            }
        }
        .allowsHitTesting(false)
    }
}

#Preview {
    GuestModeDrawerView(displayName: "Test Me", onClose: {}, onLogout: {})
}
