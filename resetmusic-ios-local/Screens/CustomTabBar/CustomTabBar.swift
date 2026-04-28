//
//  CustomTabBar.swift
//  resetmusic-ios-local
//
//  Created by Naushad Ali Khan on 09/03/26.
//
import SwiftUI

enum AppTab: Int, CaseIterable {

case home     = 0
case artists  = 1
case search   = 2
//case store    = 3
// case library  = 3

var icon: String {

switch self {

case .home:    return "house.fill"
case .artists: return "person.2.fill"
case .search:  return "magnifyingglass"
//case .store:   return "bag.fill"
// case .library: return "music.note.list"

}

}

var label: String {

switch self {

case .home:    return "Home"
case .artists: return "Artists"
case .search:  return "Search"
//case .store:   return "Store"
// case .library: return "Library"

}

}

}

struct CustomTabBar: View {

@Binding var selectedTab: AppTab

var body: some View {

VStack(spacing: 0) {

// ✅ Animated capsule indicator at top

GeometryReader { geo in

let tabWidth = geo.size.width / CGFloat(AppTab.allCases.count)
let capsuleW = tabWidth - 32

Capsule()
.fill(Color(red: 0.25, green: 0.55, blue: 1.0))
.frame(width: capsuleW, height: 3)
.shadow(color: Color(red: 0.25, green: 0.55, blue: 1.0).opacity(0.6), radius: 6, x: 0, y: 0)
.offset(x: CGFloat(selectedTab.rawValue) * tabWidth + 16)
.animation(.spring(response: 0.3, dampingFraction: 0.7), value: selectedTab)

}

.frame(height: 3)

HStack(spacing: 0) {

ForEach(AppTab.allCases, id: \.rawValue) { tab in

CustomTabButton(
icon: tab.icon,
label: tab.label,
isSelected: selectedTab == tab
) {

withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {

selectedTab = tab

}

}

}

}

.padding(.horizontal, 8)
.padding(.top, 12)
.padding(.bottom, 28)

}

.background(

ZStack {

Rectangle()
.fill(.ultraThinMaterial)
.environment(\.colorScheme, .dark)

    LinearGradient(
        stops: [
            .init(color: Color(hex: "011639").opacity(0.85), location: 0.0),
            .init(color: Color(hex: "0e131f").opacity(0.75), location: 1.0)
        ],
        startPoint: .top,
        endPoint: .bottom
    )

}

)

.ignoresSafeArea(edges: .bottom)

}

}

#Preview {

ZStack {

Color(red: 0.02, green: 0.05, blue: 0.15).ignoresSafeArea()

VStack {

Spacer()

CustomTabBar(selectedTab: .constant(.home))

}

}

}



