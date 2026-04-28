//
//  AppFont.swift
//  resetmusic-ios-local
//
//  Created by Naushad Ali Khan on 06/03/26.
//

import Foundation
import SwiftUI

struct AppFont {
    
    // MARK: - Album / Card Titles
    static func albumTitle() -> Font {
        .custom("Jura-Bold", size: 15)
    }

    // MARK: - Artist Names
    static func artistName() -> Font {
        .custom("Jura-SemiBold", size: 13)
    }

    // MARK: - Metadata (labels like "by artist")
    static func metadata() -> Font {
        .custom("Jura-Regular", size: 12)
    }

    // MARK: - Section Titles
    static func sectionTitle() -> Font {
        .custom("Jura-Bold", size: 20)
    }

    // MARK: - Player Title
    static func playerTitle() -> Font {
        .custom("Jura-Bold", size: 22)
    }

    // MARK: - Small UI text
    static func caption() -> Font {
        .custom("Jura-Regular", size: 11)
    }
}
