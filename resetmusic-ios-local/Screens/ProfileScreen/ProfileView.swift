//
//  ProfileView.swift
//  resetmusic-ios-local
//
//  Created by Codex on 24/04/26.
//

import SwiftUI

struct ProfileView: View {
    @Environment(\.dismiss) private var dismiss
    var onClose: (() -> Void)? = nil

    private let profile = UserProfile(
        name: "Naushad",
        handle: "@naushad.reset",
        email: "naushad@resetmusic.app",
        planName: "Premium Listener",
        accentColor: Color(red: 0.18, green: 0.63, blue: 0.98),
        stats: [
            ProfileStat(title: "Playlists", value: "12"),
            ProfileStat(title: "Following", value: "38"),
            ProfileStat(title: "Hours", value: "248")
        ]
    )

    private let quickActions: [ProfileQuickAction] = [
        ProfileQuickAction(title: "Music", subtitle: "Liked songs, playlists, artists", systemImage: "music.note.list"),
        ProfileQuickAction(title: "Notifications", subtitle: "Release alerts and activity", systemImage: "bell.badge"),
        ProfileQuickAction(title: "Downloads", subtitle: "Offline listening preferences", systemImage: "arrow.down.circle")
    ]

    private let sections: [ProfileSection] = [
        ProfileSection(
            title: "Account",
            items: [
                ProfileItem(title: "View account", subtitle: "Profile details, email, sign in", systemImage: "person.crop.circle"),
                ProfileItem(title: "Subscription", subtitle: "Manage your plan and billing", systemImage: "creditcard"),
                ProfileItem(title: "Connected devices", subtitle: "Speakers, AirPlay, and sessions", systemImage: "hifispeaker")
            ]
        ),
        ProfileSection(
            title: "Preferences",
            items: [
                ProfileItem(title: "Playback", subtitle: "Crossfade, explicit content, autoplay", systemImage: "waveform"),
                ProfileItem(title: "Content and privacy", subtitle: "Listening activity and data controls", systemImage: "lock.shield"),
                ProfileItem(title: "Appearance", subtitle: "Theme and interface behavior", systemImage: "paintpalette")
            ]
        ),
        ProfileSection(
            title: "Support",
            items: [
                ProfileItem(title: "Help and support", subtitle: "FAQ and troubleshooting", systemImage: "questionmark.circle"),
                ProfileItem(title: "About Reset Music", subtitle: "Version, legal, and licenses", systemImage: "info.circle")
            ]
        )
    ]

    var body: some View {
        ZStack(alignment: .topLeading) {
            LinearGradient(
                stops: [
                    .init(color: Color(hex: "07111F"), location: 0.0),
                    .init(color: Color(hex: "030914"), location: 0.55),
                    .init(color: Color.black, location: 1.0)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            ProfileDotPatternOverlay()
                .opacity(0.28)

            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 22) {
                    topBar
                    header
                    planCard
                    quickActionStrip

                    ForEach(sections) { section in
                        profileSection(section)
                    }

                    Button(action: {}) {
                        Text("Log Out")
                            .font(.custom("Jura-SemiBold", size: 15))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.white.opacity(0.06))
                            .clipShape(RoundedRectangle(cornerRadius: 18))
                            .overlay(
                                RoundedRectangle(cornerRadius: 18)
                                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
                            )
                    }
                    .buttonStyle(.plain)
                    .padding(.top, 8)
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
                .padding(.bottom, 42)
            }
        }
        .toolbar(.hidden, for: .navigationBar)
    }
}

private extension ProfileView {
    var topBar: some View {
        HStack {
            Button(action: close) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 40, height: 40)
                    .background(Color.white.opacity(0.08))
                    .clipShape(Circle())
            }
            .buttonStyle(.plain)

            Spacer()

            Text("Profile")
                .font(.custom("Jura-Bold", size: 18))
                .foregroundColor(.white)

            Spacer()

            Button(action: {}) {
                Image(systemName: "gearshape")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 40, height: 40)
                    .background(Color.white.opacity(0.08))
                    .clipShape(Circle())
            }
            .buttonStyle(.plain)
        }
        .padding(.bottom, 8)
    }

    var header: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack(alignment: .top, spacing: 16) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    profile.accentColor,
                                    profile.accentColor.opacity(0.45)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 92, height: 92)

                    Text(String(profile.name.prefix(1)).uppercased())
                        .font(.system(size: 34, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                }
                .overlay(
                    Circle()
                        .stroke(Color.white.opacity(0.14), lineWidth: 1)
                )

                VStack(alignment: .leading, spacing: 8) {
                    Text(profile.name)
                        .font(.custom("Jura-Bold", size: 28))
                        .foregroundColor(.white)

                    Text(profile.handle)
                        .font(.custom("Jura-Regular", size: 14))
                        .foregroundColor(.white.opacity(0.56))

                    Text(profile.email)
                        .font(.custom("Jura-Regular", size: 13))
                        .foregroundColor(.white.opacity(0.4))
                }
                .padding(.top, 8)

                Spacer()
            }

            HStack(spacing: 10) {
                ForEach(profile.stats) { stat in
                    VStack(spacing: 4) {
                        Text(stat.value)
                            .font(.custom("Jura-Bold", size: 18))
                            .foregroundColor(.white)

                        Text(stat.title)
                            .font(.custom("Jura-Regular", size: 11))
                            .foregroundColor(.white.opacity(0.5))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Color.white.opacity(0.04))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }
            }
        }
        .padding(.top, 10)
    }

    var planCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Your Plan")
                .font(.custom("Jura-Regular", size: 12))
                .foregroundColor(.white.opacity(0.55))

            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text(profile.planName)
                        .font(.custom("Jura-Bold", size: 20))
                        .foregroundColor(.white)

                    Text("Ad-free listening, artist exclusives, and early access drops.")
                        .font(.custom("Jura-Regular", size: 13))
                        .foregroundColor(.white.opacity(0.58))
                }

                Spacer()

                Text("Active")
                    .font(.custom("Jura-SemiBold", size: 12))
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(profile.accentColor.opacity(0.22))
                    .clipShape(Capsule())
            }
        }
        .padding(18)
        .background(
            LinearGradient(
                colors: [
                    profile.accentColor.opacity(0.28),
                    Color.white.opacity(0.05)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 22))
        .overlay(
            RoundedRectangle(cornerRadius: 22)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
    }

    var quickActionStrip: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(quickActions) { action in
                    VStack(alignment: .leading, spacing: 14) {
                        Image(systemName: action.systemImage)
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(profile.accentColor)
                            .frame(width: 42, height: 42)
                            .background(Color.white.opacity(0.06))
                            .clipShape(RoundedRectangle(cornerRadius: 14))

                        VStack(alignment: .leading, spacing: 6) {
                            Text(action.title)
                                .font(.custom("Jura-SemiBold", size: 15))
                                .foregroundColor(.white)

                            Text(action.subtitle)
                                .font(.custom("Jura-Regular", size: 12))
                                .foregroundColor(.white.opacity(0.52))
                                .lineLimit(2)
                        }
                    }
                    .frame(width: 168, alignment: .leading)
                    .padding(16)
                    .background(Color.white.opacity(0.04))
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.white.opacity(0.08), lineWidth: 1)
                    )
                }
            }
        }
    }

    func profileSection(_ section: ProfileSection) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(section.title)
                .font(.custom("Jura-SemiBold", size: 13))
                .foregroundColor(.white.opacity(0.55))
                .padding(.horizontal, 4)

            VStack(spacing: 0) {
                ForEach(Array(section.items.enumerated()), id: \.element.id) { index, item in
                    profileRow(item)

                    if index < section.items.count - 1 {
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
    }

    func profileRow(_ item: ProfileItem) -> some View {
        Button(action: {}) {
            HStack(spacing: 14) {
                Image(systemName: item.systemImage)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(profile.accentColor)
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

                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.white.opacity(0.3))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
        }
        .buttonStyle(.plain)
    }

    func close() {
        if let onClose {
            onClose()
        } else {
            dismiss()
        }
    }
}

private struct UserProfile {
    let name: String
    let handle: String
    let email: String
    let planName: String
    let accentColor: Color
    let stats: [ProfileStat]
}

private struct ProfileStat: Identifiable {
    let id = UUID()
    let title: String
    let value: String
}

private struct ProfileQuickAction: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let systemImage: String
}

private struct ProfileSection: Identifiable {
    let id = UUID()
    let title: String
    let items: [ProfileItem]
}

private struct ProfileItem: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let systemImage: String
}

private struct ProfileDotPatternOverlay: View {
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
    NavigationStack {
        ProfileView()
    }
}
