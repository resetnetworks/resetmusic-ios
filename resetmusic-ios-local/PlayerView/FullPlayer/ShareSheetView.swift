//
//  ShareSheetView.swift
//  resetmusic-ios-local
//
//  Created by resetstudio01  on 20/04/26.
//


import SwiftUI
import UIKit

struct ShareSheetView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var playerVM: PlayerViewModel
    @State private var appeared: Bool = false
    @State private var showCopied: Bool = false

    private let shareApps: [(name: String, imageName: String, urlScheme: String)] = [
        ("WhatsApp",  "whatsapp-logo",  "whatsapp://send?text="),
        ("Instagram", "instagram-logo", "instagram://"),
        ("X",         "twitter-logo",   "https://twitter.com/intent/tweet?text="),
        ("Telegram",  "telegram-logo",  "tg://msg?text="),
    ]
    var trackURL: String {
        let slug = playerVM.currentTrack?.title
            .lowercased()
            .replacingOccurrences(of: " ", with: "-") ?? "track"
        return "https://reset.fm/track/\(slug)"
    }
    
    var shareText: String {
        guard let track = playerVM.currentTrack else { return trackURL }
        return "🎵 \(track.title) by \(track.artistName)\n\nListen on reset.fm:\n\(trackURL)"
    }

    var body: some View {
        ZStack {
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
                    colors: [Color(red: 0.2, green: 0.5, blue: 1.0).opacity(0.2), Color.clear],
                    startPoint: .top, endPoint: .center
                )
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                // MARK: - Track Info
                HStack(spacing: 14) {
                    AsyncImage(url: URL(string: playerVM.currentTrack?.coverImage ?? "")) { img in
                        img.resizable().scaledToFill()
                    } placeholder: {
                        Color(red: 0.05, green: 0.12, blue: 0.23)
                    }
                    .frame(width: 52, height: 52)
                    .clipShape(RoundedRectangle(cornerRadius: 10))

                    VStack(alignment: .leading, spacing: 3) {
                        Text(playerVM.currentTrack?.title ?? "")
                            .font(.custom("Jura-SemiBold", size: 15))
                            .foregroundColor(.white)
                            .lineLimit(1)
                        Text(playerVM.currentTrack?.artistName ?? "")
                            .font(.custom("Jura-Regular", size: 13))
                            .foregroundColor(.white.opacity(0.45))
                    }
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
                .opacity(appeared ? 1 : 0)
                .offset(y: appeared ? 0 : 8)

                // MARK: - Share Apps Row
                sectionLabel("Share via")

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        ForEach(shareApps, id: \.name) { app in
                            shareAppButton(app)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 6)
                }
                .padding(.bottom, 6)
                .opacity(appeared ? 1 : 0)
                .offset(y: appeared ? 0 : 8)

                // MARK: - Copy Link Option
                sectionLabel("Copy")

                Button(action: copyLink) {
                    HStack(spacing: 14) {
                        Image(systemName: "link")
                            .font(.system(size: 14))
                            .foregroundColor(Color(red: 0.3, green: 0.7, blue: 1.0))
                            .frame(width: 32, height: 32)
                            .background(Color(red: 0.2, green: 0.45, blue: 1.0).opacity(0.15))
                            .clipShape(RoundedRectangle(cornerRadius: 8))

                        VStack(alignment: .leading, spacing: 2) {
                            Text("Copy link")
                                .font(.custom("Jura-SemiBold", size: 14))
                                .foregroundColor(.white.opacity(0.9))
                            Text(trackURL)
                                .font(.custom("Jura-Regular", size: 12))
                                .foregroundColor(.white.opacity(0.3))
                                .lineLimit(1)
                        }
                        Spacer()
                        Image(systemName: "doc.on.doc")
                            .font(.system(size: 11))
                            .foregroundColor(.white.opacity(0.2))
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 13)
                    .background(Color.white.opacity(0.04))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.white.opacity(0.06), lineWidth: 0.5))
                }
                .buttonStyle(.plain)
                .padding(.horizontal, 20)
                .opacity(appeared ? 1 : 0)
                .offset(y: appeared ? 0 : 8)

            }
            .padding(.vertical, 16)

            // MARK: - Improved Copied Toast
            if showCopied {
                VStack {
                    HStack(spacing: 8) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 14))
                            .foregroundColor(Color(red: 0.3, green: 0.8, blue: 0.5))
                        Text("Link copied to clipboard")
                            .font(.custom("Jura-Medium", size: 13))
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 18)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 30)
                            .fill(.ultraThinMaterial)
                            .overlay(
                                RoundedRectangle(cornerRadius: 30)
                                    .stroke(Color.white.opacity(0.15), lineWidth: 0.5)
                            )
                    )
                    .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5)
                    .transition(.asymmetric(
                        insertion: .opacity.combined(with: .scale(scale: 0.8, anchor: .top)),
                        removal: .opacity.combined(with: .scale(scale: 0.8, anchor: .top))
                    ))
                    Spacer()
                }
                .padding(.top, 60)
                .zIndex(1)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.75)) {
                appeared = true
            }
        }
        .onDisappear { appeared = false }
    }

    // MARK: - Actions
    
    private func copyLink() {
        UIPasteboard.general.string = trackURL
        triggerHaptic()
        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
            showCopied = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            withAnimation(.easeOut(duration: 0.2)) {
                showCopied = false
            }
        }
    }
    
    private func shareToApp(_ app: (name: String, imageName: String, urlScheme: String)) {
        triggerHaptic()
        let encodedText = shareText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""

        switch app.name {
        case "WhatsApp":
            let urlString = "whatsapp://send?text=\(encodedText)"
            if let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            } else { openFallbackShare() }

        case "Instagram":
            openFallbackShare()

        case "X":
            let urlString = "https://twitter.com/intent/tweet?text=\(encodedText)"
            if let url = URL(string: urlString) {
                UIApplication.shared.open(url)
            }

        case "Telegram":
            let urlString = "https://t.me/share/url?url=\(trackURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")&text=\(encodedText)"
            if let url = URL(string: urlString) {
                UIApplication.shared.open(url)
            }

        default:
            openFallbackShare()
        }
    }
    private func openFallbackShare() {
        let activityVC = UIActivityViewController(
            activityItems: [shareText],
            applicationActivities: nil
        )
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = windowScene.windows.first?.rootViewController {
            rootVC.present(activityVC, animated: true)
        }
    }

    // MARK: - Helpers

    @ViewBuilder
    private func sectionLabel(_ text: String) -> some View {
        Text(text.uppercased())
            .font(.custom("Jura-Regular", size: 10))
            .foregroundColor(Color(red: 0.43, green: 0.7, blue: 1.0).opacity(0.6))
            .tracking(2)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 20)
            .padding(.bottom, 6)
    }

    @ViewBuilder
    private func shareAppButton(_ app: (name: String, imageName: String, urlScheme: String)) -> some View {
        Button(action: { shareToApp(app) }) {
            VStack(spacing: 8) {
                Image(app.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .frame(width: 52, height: 52)
                    .background(Color.white.opacity(0.06))
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(Color.white.opacity(0.08), lineWidth: 0.5)
                    )
                Text(app.name)
                    .font(.custom("Jura-Regular", size: 11))
                    .foregroundColor(.white.opacity(0.45))
            }
        }
        .buttonStyle(.plain)
    }
    
    private func triggerHaptic() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
}



#Preview {
    ShareSheetView()
        .environmentObject({
            let vm = PlayerViewModel()
            vm.currentTrack = PlayerTrack(
                title: "Shifting Layers",
                artistName: "Nariel",
                artistId: "69676ee89768e0cb8a7907c3",
                coverImage: "https://d3tp8cbw5vz2ok.cloudfront.net/covers/11de53a6-975f-45b7-b713-0675b34f6375.jpg"
            )
            return vm
        }())
}
