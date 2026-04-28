//
//  ArtistSubscribeSheetView.swift
//  resetmusic-ios-local
//
//  Created by Naushad Ali Khan on 10/04/26.
//


import SwiftUI
import Kingfisher

// ─────────────────────────────────────────────
// MARK: - Artist Subscribe Sheet
// ─────────────────────────────────────────────
//
// Bottom sheet shown when tapping "Subscribe" on ArtistDetailView.
// Shows artist identity, subscription perks, plan details, and CTA.
//
// Usage:
//   .sheet(isPresented: $showSubscribeSheet) {
//       ArtistSubscribeSheetView(artist: artist)
//           .presentationDetents([.height(560)])
//           .presentationDragIndicator(.visible)
//   }

struct ArtistSubscribeSheetView: View {

    let artist: FeaturedArtist
    @Environment(\.dismiss) var dismiss
    @State private var appeared = false

    var body: some View {
        ZStack {
            // ── Background — same as AlbumUpgradeSheetView ──
            LinearGradient(
                stops: [
                    .init(color: Color(hex: "000000"), location: 0.0),
                    .init(color: Color(hex: "011639"), location: 1.0)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .overlay(
                LinearGradient(
                    colors: [
                        Color(red: 0.2, green: 0.5, blue: 1.0).opacity(0.2),
                        Color.clear
                    ],
                    startPoint: .top,
                    endPoint: .center
                )
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()

                // ── Artist avatar + name ──────────────────────
                artistIdentity
                    .opacity(appeared ? 1 : 0)
                    .scaleEffect(appeared ? 1 : 0.88)
                    .padding(.bottom, 20)

                // ── Plan pill ─────────────────────────────────
                planPill
                    .opacity(appeared ? 1 : 0)
                    .offset(y: appeared ? 0 : 8)
                    .padding(.bottom, 22)

                // ── Perks list ────────────────────────────────
                perksSection
                    .opacity(appeared ? 1 : 0)
                    .offset(y: appeared ? 0 : 10)
                    .padding(.bottom, 20)

                // ── Apple-safe note ───────────────────────────
                Text("Subscriptions are managed through your Reset account on the web.")
                    .font(.custom("Jura-Regular", size: 12))
                    .foregroundColor(.white.opacity(0.35))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 28)
                    .opacity(appeared ? 1 : 0)
                    .padding(.bottom, 20)

                // ── CTA button ────────────────────────────────
                ctaButton
                    .opacity(appeared ? 1 : 0)
                    .offset(y: appeared ? 0 : 10)

                Spacer()
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.75)) {
                appeared = true
            }
        }
        .onDisappear { appeared = false }
    }

    // ── Artist identity ──────────────────────────────────────

    private var artistIdentity: some View {
        VStack(spacing: 12) {
            ZStack(alignment: .bottomTrailing) {
                // Profile image
                KFImage(URL(string: artist.profileImage ?? ""))
                    .placeholder {
                        Circle()
                            .fill(Color(hex: "0d1f35"))
                    }
                    .resizable()
                    .scaledToFill()
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(
                                LinearGradient(
                                    colors: [Color(hex: "3B82F6"), Color(hex: "0F3272")],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 2
                            )
                    )
                    .shadow(color: Color(hex: "3B82F6").opacity(0.35), radius: 10)

                // Star badge — subscriber indicator
                ZStack {
                    Circle()
                        .fill(Color(hex: "3B82F6"))
                        .frame(width: 24, height: 24)
                    Image(systemName: "star.fill")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundColor(.white)
                }
                .overlay(Circle().stroke(Color.black, lineWidth: 2))
                .offset(x: 2, y: 2)
            }

            VStack(spacing: 4) {
                Text("Subscribe to \(artist.name)")
                    .font(.custom("Jura-Bold", size: 20))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)

                if let location = artist.location {
                    HStack(spacing: 4) {
                        Image(systemName: "mappin")
                            .font(.system(size: 11))
                        Text(location)
                            .font(.custom("Jura-Regular", size: 13))
                    }
                    .foregroundColor(Color(red: 0.3, green: 0.7, blue: 1.0))
                }
            }
        }
        .padding(.horizontal, 24)
    }

    // ── Plan pill ────────────────────────────────────────────

    private var planPill: some View {
        HStack(spacing: 8) {
            Image(systemName: "calendar")
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(Color(hex: "3B82F6"))

            Text(planDescription)
                .font(.custom("Jura-SemiBold", size: 14))
                .foregroundColor(.white)

            Text("·")
                .foregroundColor(.white.opacity(0.3))

            Text("Cancel anytime")
                .font(.custom("Jura-Regular", size: 13))
                .foregroundColor(.white.opacity(0.45))
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 10)
        .background(
            Capsule()
                .fill(Color(hex: "3B82F6").opacity(0.12))
                .overlay(
                    Capsule()
                        .stroke(Color(hex: "3B82F6").opacity(0.3), lineWidth: 1)
                )
        )
    }

    // ── Perks ────────────────────────────────────────────────

    private var perksSection: some View {
        VStack(spacing: 10) {
            perkRow(icon: "crown.fill",
                    text: "Exclusive tracks not available anywhere else")
            perkRow(icon: "bolt.fill",
                    text: "Early access to new releases before anyone")
            perkRow(icon: "tag.fill",
                    text: "Subscriber-only discounts on future drops")
            perkRow(icon: "person.crop.circle.badge.checkmark",
                    text: "Directly fund \(artist.name)'s next project")
            perkRow(icon: "bell.badge",
                    text: "First to know — release & event alerts")
        }
        .padding(.horizontal, 28)
    }

    private func perkRow(icon: String, text: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(Color(red: 0.3, green: 0.7, blue: 1.0))
                .frame(width: 16, alignment: .center)
                .padding(.top, 2)
            Text(text)
                .font(.custom("Jura-Regular", size: 14))
                .foregroundColor(.white.opacity(0.8))
                .fixedSize(horizontal: false, vertical: true)
            Spacer()
        }
    }

    // ── CTA ──────────────────────────────────────────────────

    private var ctaButton: some View {
        VStack(spacing: 12) {

            Button(action: {
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                dismiss()
            }) {
                Text("Keep exploring artists")
                    .font(.custom("Jura-Bold", size: 15))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color(hex: "0F3272"),
                                        Color(hex: "1A5DB4"),
                                        Color(hex: "3B82F6")
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
//                            .shadow(
//                                color: Color(hex: "3B82F6").opacity(0.35),
//                                radius: 10,
//                                y: 4
//                            )
                    )
            }
            .buttonStyle(.plain)
            .padding(.horizontal, 28)
        }
    }
    // ── Helpers ──────────────────────────────────────────────

    /// Human-readable plan string, e.g. "$2.99 / 3 months"
    private var planDescription: String {
        guard let plan = artist.subscriptionPlans.first else {
            return artist.displayPrice
        }
        let amount = plan.basePrice?.amount
        let cycle: String
        switch plan.cycle {
        case "1m":  cycle = "month"
        case "3m":  cycle = "3 months"
        case "6m":  cycle = "6 months"
        case "12m": cycle = "year"
        default:    cycle = plan.cycle
        }
        let priceStr = amount.map { String(format: "$%.2f", $0) } ?? artist.displayPrice
        return "\(priceStr) / \(cycle)"
    }
}

// ─────────────────────────────────────────────
// MARK: - Preview
// ─────────────────────────────────────────────

#Preview("Nariel") {
    Color.black.ignoresSafeArea()
        .sheet(isPresented: .constant(true)) {
            ArtistSubscribeSheetView(artist: FeaturedArtist(
                id: "69676ee89768e0cb8a7907c3",
                name: "Nariel",
                slug: "nariel-dvr1ug",
                bio: nil,
                location: "Naples",
                country: "IT",
                profileImage: "https://d3tp8cbw5vz2ok.cloudfront.net/artist/e00ad410-a4a9-4095-a9c0-8a44d87f19c9.jpg",
                coverImage: nil,
                subscriptionPlans: [ArtistSubscriptionPlan(cycle: "3m", basePrice: Price(currency: "USD", amount: 2.99), convertedPrices: [])],
                isMonetizationComplete: true,
                songCount: 16, albumCount: 3,
                createdAt: "", updatedAt: ""
            ))
            .presentationDetents([.height(560)])
            .presentationDragIndicator(.visible)
        }
}

#Preview("Akira Film Script") {
    Color.black.ignoresSafeArea()
        .sheet(isPresented: .constant(true)) {
            ArtistSubscribeSheetView(artist: FeaturedArtist(
                id: "698615f0a5238e31d0a1e659",
                name: "Akira Film Script",
                slug: "akira-film-script",
                bio: nil,
                location: "San Francisco, CA",
                country: "US",
                profileImage: "https://d3tp8cbw5vz2ok.cloudfront.net/artist/56ced079-fede-4a1f-b309-82011918b69e.webp",
                coverImage: nil,
                subscriptionPlans: [ArtistSubscriptionPlan(cycle: "3m", basePrice: Price(currency: "USD", amount: 9.99), convertedPrices: [])],
                isMonetizationComplete: true,
                songCount: 0, albumCount: 0,
                createdAt: "", updatedAt: ""
            ))
            .presentationDetents([.height(560)])
            .presentationDragIndicator(.visible)
        }
}
