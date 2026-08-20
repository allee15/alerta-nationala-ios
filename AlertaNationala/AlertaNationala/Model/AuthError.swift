//
//  AuthError.swift
//  AlertaNationala
//
//  Created by Alexia Aldea on 20/08/2026.
//


import Foundation

enum AuthError: Error {
    case invalidURL
    case invalidResponse
    case noRefreshToken
    case unauthorized
}