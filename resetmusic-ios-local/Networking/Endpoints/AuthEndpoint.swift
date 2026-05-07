//
//  AuthEndpoint.swift
//  resetmusic-ios-local
//
//  Created by Codex on 06/05/26.
//

import Foundation


enum AuthEndpoint: APIEndpoint {
    case register(Data)
    case login(Data)
    case logout
    case forgotPassword(Data)

    var path: String {
        switch self {
        case .register:        return "/api/users/register"
        case .login:           return "/api/users/login"
        case .logout:          return "/api/users/logout"
        case .forgotPassword:  return "/api/users/forgot-password"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .register, .login, .logout, .forgotPassword:
            return .POST
        }
    }

    var body: Data? {
        switch self {
        case .register(let data),
             .login(let data),
             .forgotPassword(let data):   
            return data
        case .logout:
            return nil
        }
    }

    var requiresAuth: Bool {
        switch self {
        case .logout:  return true
        default:       return false
        }
    }
}
