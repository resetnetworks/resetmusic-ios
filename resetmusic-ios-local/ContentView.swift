//
//  ContentView.swift
//  resetmusic-ios-local
//
//  Created by Naushad Ali Khan on 04/03/26.
//

import SwiftUI

struct ContentView: View {

    @State private var showWelcome = true

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            if showWelcome {
                WelcomeView(
                    onLoginSignUp: {
                        // TODO: wire to LoginView when ready
                    },
                    onBrowseFirst: {
                        withAnimation(.easeInOut(duration: 0.6)) {
                            showWelcome = false
                        }
                    }
                )
                .transition(.opacity)
            } else {
                RootView()
                    .transition(.opacity)
            }
        }
    }
}

#Preview {
    ContentView()
}
