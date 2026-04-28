//
//  APIEndpoint.swift
//  resetmusic-ios-local
//
//  Created by Naushad Ali Khan on 04/03/26.
//

import Foundation
enum HTTPMethod: String {
    case GET
    case POST
    case PATCH
    case DELETE
}

protocol APIEndpoint {
    var path: String { get }
    var method: HTTPMethod { get }
    var body: Data? { get }
    var requiresAuth: Bool { get }
}
