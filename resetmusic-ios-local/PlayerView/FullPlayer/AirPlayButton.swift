//
//  AirPlayButton.swift
//  resetmusic-ios-local
//
//  Created by Naushad Ali Khan on 25/03/26.
//


import SwiftUI
import AVKit
import AVFoundation
import Combine
// MARK: - AirPlay Button + Device Name

struct AirPlayView: View {
    @StateObject private var airPlayMonitor = AirPlayMonitor()
    
    var body: some View {
        VStack(spacing: 4) {
            AirPlayButton(monitor: airPlayMonitor)
                .frame(width: 44, height: 44)
            
            // Device name fades in when connected
            if let deviceName = airPlayMonitor.deviceName {
                Text(deviceName)
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(Color(red: 0.3, green: 0.7, blue: 1.0))
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .transition(.opacity.combined(with: .scale(scale: 0.85)))
            }
        }
        .animation(.easeInOut(duration: 0.25), value: airPlayMonitor.deviceName)
    }
}

// MARK: - Observable Monitor

class AirPlayMonitor: ObservableObject {
    @Published var isActive: Bool = false
    @Published var deviceName: String? = nil
    
    init() {
        updateRoute()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(routeChanged),
            name: AVAudioSession.routeChangeNotification,
            object: nil
        )
    }
    
    @objc private func routeChanged(_ notification: Notification) {
        DispatchQueue.main.async { self.updateRoute() }
    }
    
    private func updateRoute() {
        let airPlayOutput = AVAudioSession.sharedInstance()
            .currentRoute.outputs
            .first(where: { $0.portType == .airPlay })
        
        isActive = airPlayOutput != nil
        deviceName = airPlayOutput?.portName  // e.g. "Living Room TV"
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - UIViewRepresentable Button

struct AirPlayButton: UIViewRepresentable {
    @ObservedObject var monitor: AirPlayMonitor
    
    func makeUIView(context: Context) -> AVRoutePickerView {
        let picker = AVRoutePickerView()
        picker.backgroundColor = .clear
        return picker
    }
    
    func updateUIView(_ uiView: AVRoutePickerView, context: Context) {
        if monitor.isActive {
            uiView.tintColor       = UIColor(red: 0.3, green: 0.7, blue: 1.0, alpha: 1.0)
            uiView.activeTintColor = UIColor(red: 0.3, green: 0.7, blue: 1.0, alpha: 1.0)
        } else {
            uiView.tintColor       = UIColor.white.withAlphaComponent(0.4)
            uiView.activeTintColor = UIColor(red: 0.3, green: 0.7, blue: 1.0, alpha: 1.0)
        }
    }
}
