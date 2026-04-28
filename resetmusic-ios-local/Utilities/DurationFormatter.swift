//
//  DurationFormatter.swift
//  resetmusic-ios-local
//
//  Created by Naushad Ali Khan on 10/03/26.
//


import Foundation

/// Utility for converting seconds to readable duration strings
enum DurationFormatter {

    /// "6:39" — for track rows
    static func trackTime(_ seconds: Double) -> String {
        let total = Int(seconds)
        let m = total / 60
        let s = total % 60
        return String(format: "%d:%02d", m, s)
    }

    /// "43:21" or "1h 23m" — for total album duration
    static func albumDuration(_ seconds: Double) -> String {
        let total = Int(seconds)
        let hours = total / 3600
        let minutes = (total % 3600) / 60
        let secs = total % 60

        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return String(format: "%d:%02d", minutes, secs)
        }
    }

    /// "24 Feb 2024" — for ISO8601 date strings
    static func releaseDate(_ dateString: String) -> String {
        let iso = ISO8601DateFormatter()
        iso.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        if let date = iso.date(from: dateString) {
            return formatted(date)
        }
        iso.formatOptions = [.withInternetDateTime]
        if let date = iso.date(from: dateString) {
            return formatted(date)
        }
        return dateString
    }

    private static func formatted(_ date: Date) -> String {
        let f = DateFormatter()
        f.dateFormat = "d MMM yyyy"  // MMM = "Feb", "Mar" etc.
        return f.string(from: date)
    }
}
