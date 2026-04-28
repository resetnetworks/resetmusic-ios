//
//  Pagination.swift
//  resetmusic-ios-local
//
//  Created by Naushad Ali Khan on 04/03/26.
//

import Foundation
struct Pagination: Codable {
    let total: Int
    let page: Int
    let limit: Int
    let totalPages: Int
}
