//
//  GreetingHelper.swift
//  resetmusic-ios-local
//
//  Created by Naushad Ali Khan on 11/03/26.
//


import Foundation

struct GreetingHelper {

    /// Returns a real-time greeting based on current hour
    static var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12:  return "Good Morning"
        case 12..<17: return "Good Afternoon"
        default:      return "Good Evening"
        }
    }
}
