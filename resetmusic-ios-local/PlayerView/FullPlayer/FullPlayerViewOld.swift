//
//  FullPlayerView.swift
//  resetmusic-ios-local
//
//  Created by Naushad Ali Khan on 13/03/26.
//


//import SwiftUI
//import Kingfisher
//
//struct ClearBackgroundView: UIViewRepresentable {
//    func makeUIView(context: Context) -> UIView {
//        let view = UIView()
//        Task { @MainActor in
//            view.superview?.superview?.backgroundColor = .clear
//        }
//        return view
//    }
//    func updateUIView(_ uiView: UIView, context: Context) {}
//}
//
//struct FullPlayerView: View {
//    @Binding var isPresented: Bool
//    @EnvironmentObject var playerVM: PlayerViewModel
//    var onNavigateToArtist: ((FeaturedArtist) -> Void)? = nil
//    
//    @State private var dragOffset: CGFloat = 0
//    @State private var isDragging: Bool = false
//    @State private var appeared: Bool = false
//    @State private var forceRefresh: Bool = false
//
//    @State private var showUpgradeSheet: Bool = false
//    @State private var showQueueSheet: Bool = false
//    @State private var showMoreSheet = false
//    @State private var showShareSheet = false
//
//    var displayDuration: Double {
//        playerVM.currentTrack?.isPreview == true ? 30.0 : playerVM.duration
//    }
//
//    var currentTime: String {
//        let seconds = Int(playerVM.progress * displayDuration)
//        return String(format: "%d:%02d", seconds / 60, seconds % 60)
//    }
//
//    var endTime: String {
//        let seconds = Int(displayDuration)
//        return String(format: "%d:%02d", seconds / 60, seconds % 60)
//    }
//
//    private var dragProgress: CGFloat {
//        min(dragOffset / 300, 1.0)
//    }
//
//    private var artworkScale: CGFloat {
//        let dragScale = 1.0 - (dragProgress * 0.3)
//        let appearScale = appeared ? 1.0 : 0.6
//        return dragScale * appearScale
//    }
//
//    private var repeatButton: some View {
//        VStack(spacing: 3) {
//            Image(systemName: "repeat")
//                .font(.system(size: 20))
//                .foregroundColor(
//                    playerVM.repeatMode == .off
//                    ? .white.opacity(0.4)
//                    : Color(red: 0.3, green: 0.7, blue: 1.0)
//                )
//
//            Circle()
//                .fill(
//                    playerVM.repeatMode == .song
//                    ? Color(red: 0.3, green: 0.7, blue: 1.0)
//                    : Color.clear
//                )
//                .frame(width: 4, height: 4)
//        }
//        .contentShape(Rectangle())
//        .gesture(
//            ExclusiveGesture(
//                TapGesture(count: 2),
//                TapGesture(count: 1)
//            )
//            .onEnded { value in
//                triggerHaptic()
//                switch value {
//                case .first:
//                    playerVM.enableSongRepeat()
//                case .second:
//                    playerVM.toggleQueueRepeat()
//                }
//            }
//        )
//    }
//
//    private var artistNavigationTarget: FeaturedArtist? {
//        if let artist = playerVM.currentTrack?.artist {
//            return artist
//        }
//
//        guard let track = playerVM.currentTrack, !track.artistId.isEmpty else { return nil }
//
//        return FeaturedArtist(
//            id: track.artistId,
//            name: track.artistName,
//            slug: "",
//            bio: nil,
//            location: nil,
//            country: nil,
//            profileImage: nil,
//            coverImage: nil,
//            subscriptionPlans: [],
//            isMonetizationComplete: false,
//            songCount: 0,
//            albumCount: 0,
//            createdAt: "",
//            updatedAt: ""
//        )
//    }
//
//    var body: some View {
//        ZStack {
//            Color.clear
//                .appBackground()
//                .ignoresSafeArea(.all)
//
//            LinearGradient(
//                colors: [
//                    Color(red: 0.08, green: 0.14, blue: 0.40).opacity(0.5),
//                    Color.clear
//                ],
//                startPoint: .top,
//                endPoint: .center
//            )
//            .ignoresSafeArea()
//
//            VStack(spacing: 0) {
//
//                // MARK: - Handle + Dismiss
//                VStack(spacing: 16) {
//                    RoundedRectangle(cornerRadius: 3)
//                        .fill(Color.white.opacity(0.2))
//                        .frame(width: 44, height: 4)
//                        .padding(.top, 4)
//
//                    HStack {
//                        Button(action: {
//                            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
//                                isPresented = false
//                            }
//                        }) {
//                            Image(systemName: "chevron.down")
//                                .font(.system(size: 18, weight: .semibold))
//                                .foregroundColor(.white.opacity(0.7))
//                                .frame(width: 40, height: 40)
//                        }
//                        .buttonStyle(.plain)
//
//                        Spacer()
//
//                        Text("Now Playing")
//                            .font(.custom("Jura-SemiBold", size: 14))
//                            .foregroundColor(.white.opacity(0.5))
//
//                        Spacer()
//                        Button {
//                            triggerHaptic()
//                            showMoreSheet = true
//                        } label: {
//                            Image(systemName: "ellipsis")
//                                .font(.system(size: 18, weight: .semibold))
//                                .rotationEffect(.degrees(90))
//                                .foregroundColor(.white.opacity(0.7))
//                                .frame(width: 44, height: 44) // Apple's recommended minimum tap target
//                                .contentShape(Rectangle())
//
////                                .padding(10) // Increases tap area by 12pt on all sides
//                        }
//                        .buttonStyle(.plain)
//                    }
//                    .padding(.horizontal, 20)
//                }
//
//                // MARK: - Album Art
//                FullPlayerArtwork(
//                    url: playerVM.currentTrack?.coverImage ?? "",
//                    isPlaying: playerVM.isPlaying,
//                    isPreview: playerVM.currentTrack?.isPreview ?? false
//                )
//                .scaleEffect(artworkScale)
//                .animation(
//                    isDragging ? .interactiveSpring() : .spring(response: 0.5, dampingFraction: 0.7),
//                    value: artworkScale
//                )
//                .padding(.top, 32)
//                .onAppear {
//                    withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
//                        appeared = true
//                    }
//                }
//                .onDisappear {
//                    appeared = false
//                }
//
//                // MARK: - Track Info with Actions
//                HStack(alignment: .center, spacing: 12) {
//
//                    // MARK: - Track Info
//                    VStack(alignment: .leading, spacing: 2) {
//                        
//                        ScrollingTrackTitle(
//                            text: playerVM.currentTrack?.title ?? "No track",
//                            isPlaying: playerVM.isPlaying
//                        )
//                        .id("track_title_\(playerVM.currentTrack?.songId ?? UUID().uuidString)")
//
//                        Button {
//                            guard let artist = artistNavigationTarget else { return }
//                            triggerHaptic()
//                            isPresented = false
//                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
//                                onNavigateToArtist?(artist)
//                            }
//                        } label: {
//                            Text(playerVM.currentTrack?.artistName ?? "")
//                                .font(.custom("Jura-Regular", size: 14))
//                                .foregroundColor(.white.opacity(0.6))
//                                .lineLimit(1)
//                        }
//                        .buttonStyle(.plain)
//                        .disabled(artistNavigationTarget == nil)
//                    }
//                    .layoutPriority(1) // 🔥 Important: prevents compression
//                    .frame(maxWidth: .infinity, alignment: .leading)
//
//                    // MARK: - Actions
//                    HStack(spacing: 12) {
//
//                        Button {
//                            triggerHaptic()
//                        } label: {
//                            Image(systemName: "plus")
//                                .font(.system(size: 16, weight: .semibold))
//                                .foregroundColor(.white.opacity(0.85))
//                                .frame(width: 40, height: 40)
//                                .background(
//                                    Circle().fill(Color.white.opacity(0.08))
//                                )
//                                .overlay(
//                                    Circle().stroke(Color.white.opacity(0.12), lineWidth: 1)
//                                )
//                        }
//
//                        Button(action: {
//                            triggerHaptic()
//                            showShareSheet = true  // or add @State private var showShareSheet = false
//                    }) {
//                            Image(systemName: "arrowshape.turn.up.right")
//                                .font(.system(size: 14, weight: .semibold))
//                                .foregroundColor(.white.opacity(0.85))
//                                .frame(width: 40, height: 40)
//                                .background(
//                                    Circle().fill(Color.white.opacity(0.08))
//                                )
//                                .overlay(
//                                    Circle().stroke(Color.white.opacity(0.12), lineWidth: 1)
//                                )
//                        }
//                    }
//                }
////                .padding(.horizontal)
//                .padding(.top, 28)
//                .padding(.horizontal, 28)
//
//                // MARK: - Progress Bar
//                VStack(spacing: 6) {
//                    GeometryReader { geo in
//                        ZStack(alignment: .leading) {
//                            Capsule()
//                                .fill(Color.white.opacity(0.1))
//                                .frame(height: 4)
//
//                            Capsule()
//                                .fill(Color(red: 0.25, green: 0.55, blue: 1.0))
//                                .frame(width: geo.size.width * playerVM.progress, height: 4)
//                                .animation(.linear(duration: 0.1), value: playerVM.progress)
//
//                            Circle()
//                                .fill(.white)
//                                .frame(width: 12, height: 12)
//                                .offset(x: geo.size.width * playerVM.progress - 6)
//                                .animation(.linear(duration: 0.1), value: playerVM.progress)
//                        }
//                        .gesture(
//                            DragGesture(minimumDistance: 0)
//                                .onChanged { value in
//                                    playerVM.seek(to: min(max(value.location.x / geo.size.width, 0), 1))
//                                }
//                        )
//                    }
//                    .frame(height: 12)
//
//                    HStack {
//                        Text(currentTime)
//                        Spacer()
//                        Text(endTime)
//                    }
//                    .font(.custom("Jura-Regular", size: 12))
//                    .foregroundColor(.white.opacity(0.4))
//                }
//                .padding(.horizontal, 28)
//                .padding(.top, 24)
//
//                // MARK: - Preview Subscribe Banner
//                if playerVM.currentTrack?.isPreview == true {
//                    VStack(spacing: 6) {
//                        Text("You're listening to a 30s preview")
//                            .font(.custom("Jura-Regular", size: 13))
//                            .foregroundColor(.white.opacity(0.5))
//                        Button(action: { showUpgradeSheet = true }) {
//                            Text("Unlock full experience")
//                                .font(.custom("Jura-SemiBold", size: 14))
//                                .foregroundColor(.white)
//                                .frame(maxWidth: .infinity)
//                                .padding(.vertical, 12)
////                                .background(Color(red: 0.2, green: 0.5, blue: 1.0))
//                            .background(
//                            RoundedRectangle(cornerRadius: 14)
//                                .fill(
//                                    LinearGradient(
//                                        colors: [
//                                            Color(hex: "0F3272"),
//                                            Color(hex: "1A5DB4"),
//                                            Color(hex: "3B82F6")
//                                        ],
//                                        startPoint: .leading,
//                                        endPoint: .trailing
//                                    )
//                                )
//    //                            .shadow(
//    //                                color: Color(hex: "3B82F6").opacity(0.35),
//    //                                radius: 10,
//    //                                y: 4
//    //                            )
//                        )
//                                .clipShape(RoundedRectangle(cornerRadius: 12))
//                        }
//                        .buttonStyle(.plain)
//                        .padding(.horizontal, 28)
//                    }
//                    .padding(.top, 16)
//                }
//
//                // MARK: - Controls
//                HStack(spacing: 0) {
//                    Button(action: {
//                        triggerHaptic()
//                        playerVM.toggleShuffle()
//                    }) {
//                        Image(systemName: "shuffle")
//                            .font(.system(size: 20))
//                            .foregroundColor(playerVM.isShuffleEnabled ? Color(red: 0.3, green: 0.7, blue: 1.0) : .white.opacity(0.4))
//                            .frame(maxWidth: .infinity)
//                    }
//                    .buttonStyle(.plain)
//
//                    Button(action: playerVM.skipPrevious) {
//                        Image(systemName: "backward.end.fill")
//                            .font(.system(size: 22))
//                            .foregroundColor(.white)
//                            .frame(maxWidth: .infinity)
//                    }
//                    .buttonStyle(.plain)
//
//                    Button(action: {
//                        playerVM.togglePlayPause()
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
//                            forceRefresh.toggle()
//                        }
//                    }) {
//                        ZStack {
//                            Circle()
//                                .fill(Color(red: 0.25, green: 0.55, blue: 1.0))
//                                .frame(width: 64, height: 64)
//                                .shadow(color: Color(red: 0.2, green: 0.5, blue: 1.0).opacity(0.4), radius: 12)
//                            
//
//                            Image(systemName: playerVM.isPlaying ? "pause.fill" : "play.fill")
//                                .font(.system(size: 24, weight: .semibold))
//                                .foregroundColor(.white)
//                                .offset(x: playerVM.isPlaying ? 0 : 0.5)
//                                .contentTransition(.symbolEffect(.replace))
//                        }
//                        .frame(maxWidth: .infinity)
//                    }
//                    .buttonStyle(.plain)
//                    .id("playPause_\(playerVM.isPlaying)_\(forceRefresh)")
//
//                    Button(action: playerVM.skipNext) {
//                        Image(systemName: "forward.end.fill")
//                            .font(.system(size: 22))
//                            .foregroundColor(.white)
//                            .frame(maxWidth: .infinity)
//                    }
//                    .buttonStyle(.plain)
//
//                    repeatButton
//                        .frame(maxWidth: .infinity)
//                }
//                .padding(.horizontal, 4)
//                .padding(.top, 36)
//
//                Spacer()
//                
//              
//                    
//                
//                Spacer()
//
//                // MARK: - Bottom Actions Row (Queue + Artist)
//                HStack(spacing: 16) {
//                    // Queue Button (left)
//                    Button {
//                        triggerHaptic()
//                        showQueueSheet = true
//                    } label: {
//                        HStack(spacing: 8) {
//                            Image(systemName: "list.bullet")
//                                .font(.system(size: 14, weight: .semibold))
//                            Text("Queue")
//                                .font(.custom("Jura-SemiBold", size: 14))
//                        }
//                        .foregroundColor(.white)
//                        .padding(.horizontal, 18)
//                        .padding(.vertical, 12)
//                        .background(
//                            ZStack {
//                                RoundedRectangle(cornerRadius: 14)
//                                    .fill(Color.blue.opacity(0.2))
//                                RoundedRectangle(cornerRadius: 14)
//                                    .fill(.ultraThinMaterial)
//                                RoundedRectangle(cornerRadius: 14)
//                                    .stroke(
//                                        LinearGradient(
//                                            colors: [Color.blue.opacity(0.6), Color.white.opacity(0.15)],
//                                            startPoint: .topLeading,
//                                            endPoint: .bottomTrailing
//                                        ),
//                                        lineWidth: 1
//                                    )
//                            }
//                        )
//                        .shadow(color: Color.blue.opacity(0.25), radius: 8, y: 4)
//                    }
//                    .buttonStyle(.plain)
//                    
//                    
//                    
//                    
//                    Spacer()
//                    
//                    // AirPlay (center-right)
//                   
//                        
//                        AirPlayView()
//                            .frame(width: 32, height: 32)
//                    
//                    Spacer()
//                    
//                    // Artist Icon (right)
//                    Button {
//                        guard let artist = artistNavigationTarget else { return }
//                        triggerHaptic()
//                        isPresented = false
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
//                            onNavigateToArtist?(artist)
//                        }
//                    } label: {
//                        HStack(spacing: 8) {
//                            Image(systemName: "person.fill")
//                                .font(.system(size: 14, weight: .semibold))
//
//                            Text("Artist")
//                                .font(.custom("Jura-SemiBold", size: 14))
//                        }
//                        .foregroundColor(
//                            artistNavigationTarget != nil
//                            ? .white
//                            : .white.opacity(0.3)
//                        )
//                        .padding(.horizontal, 18)
//                        .padding(.vertical, 12)
//                        .background(
//                            ZStack {
//                                RoundedRectangle(cornerRadius: 14)
//                                    .fill(Color.blue.opacity(0.2))
//
//                                RoundedRectangle(cornerRadius: 14)
//                                    .fill(.ultraThinMaterial)
//
//                                RoundedRectangle(cornerRadius: 14)
//                                    .stroke(
//                                        LinearGradient(
//                                            colors: [
//                                                Color.blue.opacity(0.6),
//                                                Color.white.opacity(0.15)
//                                            ],
//                                            startPoint: .topLeading,
//                                            endPoint: .bottomTrailing
//                                        ),
//                                        lineWidth: 1
//                                    )
//                            }
//                        )
//                        .shadow(color: Color.blue.opacity(0.25), radius: 8, y: 4)
//                    }
//                    .buttonStyle(.plain)
//                    .disabled(artistNavigationTarget == nil)
//                }
//                .padding(.horizontal, 28)
//                .padding(.bottom, 20)
//            }
//        }
//        .presentationBackground(.clear)
//        .background(ClearBackgroundView())
//        .sheet(isPresented: $showUpgradeSheet) {
//            UpgradeSheetView()
//                .environmentObject(playerVM)
//                .presentationDetents([.height(320)])
//                .presentationDragIndicator(.visible)
//        }
//        .sheet(isPresented: $showShareSheet) {
//            ShareSheetView()
//                .environmentObject(playerVM)
//                .presentationDetents([.height(300)])
//                .presentationDragIndicator(.visible)
//                .presentationBackground(.clear)
//        }
//        
//        .sheet(isPresented: $showQueueSheet) {
//            QueueSheetView()
//                .environmentObject(playerVM)
//                .presentationDetents(
//                    playerVM.queue.count > 1
//                    ? [.medium, .large]
//                    : [.height(180)]
//                )
//                .presentationDragIndicator(.visible)
//        }
//        .sheet(isPresented: $showMoreSheet) {
//            PlayerMoreSheetView()
//                .environmentObject(playerVM)
//                .presentationDetents([.medium, .large])
//                .presentationDragIndicator(.visible)
//                .presentationBackground(.ultraThinMaterial)
//        }
//        .offset(y: dragOffset)
//        .gesture(
//            DragGesture()
//                .onChanged { value in
//                    if value.translation.height > 0 {
//                        dragOffset = value.translation.height
//                        isDragging = true
//                    }
//                }
//                .onEnded { value in
//                    if value.translation.height > 120 || value.predictedEndTranslation.height > 200 {
//                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
//                            isPresented = false
//                        }
//                    } else {
//                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
//                            dragOffset = 0
//                        }
//                    }
//                    isDragging = false
//                }
//        )
//        .animation(isDragging ? nil : .spring(response: 0.3, dampingFraction: 0.7), value: dragOffset)
//        .onDisappear { dragOffset = 0 }
//        .onReceive(playerVM.$isPlaying) { _ in forceRefresh.toggle() }
//        .onReceive(playerVM.$currentTrack) { _ in forceRefresh.toggle() }
//    }
//}
//
//func triggerHaptic() {
//    let impact = UIImpactFeedbackGenerator(style: .medium)
//    impact.impactOccurred()
//}
//
//private struct ScrollingTrackTitle: View {
//    let text: String
//    let isPlaying: Bool
//
//    @State private var textWidth: CGFloat = 0
//    @State private var containerWidth: CGFloat = 0
//    @State private var offset: CGFloat = 0
//    @State private var animationID = UUID()
//
//    private let spacing: CGFloat = 36
//    private let startPause: Double = 2
//
//    private var shouldScroll: Bool {
//        isPlaying && textWidth > containerWidth && containerWidth > 0
//    }
//
//    private var scrollDistance: CGFloat {
//        max(textWidth - containerWidth + spacing, 0)
//    }
//
//    private var scrollDuration: Double {
//        max(Double(scrollDistance / 22), 6)
//    }
//
//    var body: some View {
//        GeometryReader { proxy in
//            ZStack(alignment: .leading) {
//                if shouldScroll {
//                    HStack(spacing: spacing) {
//                        titleText
//                        titleText
//                    }
//                    .offset(x: offset)
//                } else {
//                    titleText
//                        .frame(maxWidth: .infinity, alignment: .leading)
//                }
//            }
//            .task(id: animationID) {
//                await runMarqueeLoop()
//            }
//            .onAppear {
//                containerWidth = proxy.size.width
//                restartMarquee()
//            }
//            .onChange(of: proxy.size.width) { _, newValue in
//                containerWidth = newValue
//                restartMarquee()
//            }
//            .onChange(of: text) { _, _ in
//                restartMarquee()
//            }
//            .onChange(of: isPlaying) { _, _ in
//                restartMarquee()
//            }
//            .onChange(of: textWidth) { _, _ in
//                restartMarquee()
//            }
//            .frame(width: proxy.size.width, alignment: .leading)
//            .clipped()
//            .mask(
//                LinearGradient(
//                    stops: [
//                        .init(color: .clear, location: 0.0),
//                        .init(color: .white, location: 0.02),
//                        .init(color: .white, location: 0.84),
//                        .init(color: .clear, location: 1.0)
//                    ],
//                    startPoint: .leading,
//                    endPoint: .trailing
//                )
//            )
//        }
//        .frame(height: 36)
//    }
//
//    private var titleText: some View {
//        Text(text)
//            .font(.custom("Jura-Bold", size: 26))
//            .foregroundColor(.white)
//            .lineLimit(1)
//            .fixedSize(horizontal: true, vertical: false)
//            .background(
//                GeometryReader { proxy in
//                    Color.clear
//                        .onAppear {
//                            textWidth = proxy.size.width
//                        }
//                        .onChange(of: proxy.size.width) { _, newValue in
//                            textWidth = newValue
//                        }
//                }
//            )
//    }
//
//    @MainActor
//    private func runMarqueeLoop() async {
//        offset = 0
//
//        guard shouldScroll else { return }
//
//        while !Task.isCancelled && shouldScroll {
//            try? await Task.sleep(nanoseconds: UInt64(startPause * 1_000_000_000))
//            guard !Task.isCancelled, shouldScroll else { return }
//
//            withAnimation(.linear(duration: scrollDuration)) {
//                offset = -scrollDistance
//            }
//
//            try? await Task.sleep(nanoseconds: UInt64(scrollDuration * 1_000_000_000))
//            guard !Task.isCancelled else { return }
//            offset = 0
//        }
//    }
//
//    private func restartMarquee() {
//        offset = 0
//        animationID = UUID()
//    }
//}
//// MARK: - Preview
//
//#Preview {
//    FullPlayerView(isPresented: .constant(true))
//        .environmentObject({
//            let vm = PlayerViewModel()
//            vm.currentTrack = PlayerTrack(
//                title: "Shifting Layers",
//                artistName: "Nariel",
//                artistId: "69676ee89768e0cb8a7907c3",
//                coverImage: "https://d3tp8cbw5vz2ok.cloudfront.net/covers/11de53a6-975f-45b7-b713-0675b34f6375.jpg", artist: FeaturedArtist(
//                    id: "69676ee89768e0cb8a7907c3",
//                    name: "Nariel",
//                    slug: "nariel-dvr1ug",
//                    bio: "shifting through the layers of consciousness.",
//                    location: "Naples",
//                    country: "IT",
//                    profileImage: "https://d3tp8cbw5vz2ok.cloudfront.net/artist/e00ad410-a4a9-4095-a9c0-8a44d87f19c9.jpg",
//                    coverImage: "https://d3tp8cbw5vz2ok.cloudfront.net/covers/11de53a6-975f-45b7-b713-0675b34f6375.jpg",
//                    subscriptionPlans: [],
//                    isMonetizationComplete: true,
//                    songCount: 16, albumCount: 3,
//                    createdAt: "", updatedAt: ""
//                )
//            )
//            vm.isPlaying = true
//            vm.progress = 0.35
//            return vm
//        }())
//}
