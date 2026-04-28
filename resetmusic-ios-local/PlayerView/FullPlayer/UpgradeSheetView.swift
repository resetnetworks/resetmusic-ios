//
//  UpgradeSheetView.swift
//  resetmusic-ios-local
//
//  Created by Naushad Ali Khan on 24/03/26.
//

import SwiftUI

struct UpgradeSheetView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var playerVM: PlayerViewModel  // ← ADD
    @State private var appeared: Bool = false

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
                    colors: [
                        Color(red: 0.2, green: 0.5, blue: 1.0).opacity(0.25),
                        Color.clear
                    ],
                    startPoint: .top,
                    endPoint: .center
                )
            )
            .ignoresSafeArea()

            VStack {

                Spacer()

                VStack(spacing: 18) {

                    Image("logo-icon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 44, height: 44)
                        .opacity(appeared ? 1 : 0)
                        .scaleEffect(appeared ? 1 : 0.85)

                    Text("Don't stop at 30 seconds")
                        .font(.custom("Jura-Bold", size: 20))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                        .opacity(appeared ? 1 : 0)
                        .offset(y: appeared ? 0 : 10)

                    VStack(spacing: 6) {
                        Text("Let the music play — uninterrupted, unlimited.")
                            .font(.custom("Jura-Medium", size: 15))
                            .foregroundColor(.white.opacity(0.8))
                            .multilineTextAlignment(.center)

                        Text("The full experience is available through your account outside the app.")
                            .font(.custom("Jura-Regular", size: 13))
                            .foregroundColor(.white.opacity(0.45))
                            .multilineTextAlignment(.center)
                    }
                    .padding(.horizontal, 28)
                    .opacity(appeared ? 1 : 0)
                    .offset(y: appeared ? 0 : 10)

                    Button(action: {
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        // Resume playback when user taps Keep playing
                        if !playerVM.isPlaying {
                            playerVM.togglePlayPause()
                        }
                        dismiss()
                    }) {
                        Text("Keep playing")
                            .font(.custom("Jura-SemiBold", size: 14))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
//                            .background(Color(red: 0.2, green: 0.5, blue: 1.0))
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
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .buttonStyle(.plain)
                    .padding(.horizontal, 28)
                    .padding(.top, 10)
                    .opacity(appeared ? 1 : 0)
                    .offset(y: appeared ? 0 : 10)
                }

                Spacer()
            }
        }
        .onAppear {
            // Pause when preview expires and sheet shows
            if playerVM.isPlaying {
                playerVM.togglePlayPause()
            }
            withAnimation(.spring(response: 0.5, dampingFraction: 0.75)) {
                appeared = true
            }
        }        .onDisappear {
            appeared = false
        }
    }
}

#Preview {
    UpgradeSheetView()
        .presentationDetents([.height(320)])
        .presentationDragIndicator(.visible)
        .background(Color.black)
        .environmentObject(PlayerViewModel())
}
