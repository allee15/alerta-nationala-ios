//
//  Model.swift
//  AlertaNationala
//
//  Created by Alexia Aldea
//

import Foundation

struct UserResponse {
    let accessToken: String
    let refreshToken: String
    let user: User
}

struct User {
    let id: String
    let email: String
    let role: String
    let zones: [String]
}

struct TokenResponse {
    let accessToken: String
    let refreshToken: String
}
