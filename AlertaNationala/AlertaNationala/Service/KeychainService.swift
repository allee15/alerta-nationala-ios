//
//  KeychainService.swift
//  AlertaNationala
//
//  Created by Alexia Aldea on 20/08/2026.
//

import Foundation
import Security

final class KeychainService {

    static let shared = KeychainService()

    private init() {}

    private let service = "com.alertanationala.auth"

    private let accessTokenKey = "accessToken"
    private let refreshTokenKey = "refreshToken"


    func saveAccessToken(_ token: String) {
        save(token, forKey: accessTokenKey)
    }

    func getAccessToken() -> String? {
        get(forKey: accessTokenKey)
    }

    func deleteAccessToken() {
        delete(forKey: accessTokenKey)
    }


    func saveRefreshToken(_ token: String) {
        save(token, forKey: refreshTokenKey)
    }

    func getRefreshToken() -> String? {
        get(forKey: refreshTokenKey)
    }

    func deleteRefreshToken() {
        delete(forKey: refreshTokenKey)
    }


    func clearTokens() {
        deleteAccessToken()
        deleteRefreshToken()
    }

    private func save(_ value: String, forKey key: String) {
        guard let data = value.data(using: .utf8) else {
            return
        }

        delete(forKey: key)

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlockedThisDeviceOnly
        ]

        SecItemAdd(query as CFDictionary, nil)
    }

    private func get(forKey key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var result: AnyObject?

        let status = SecItemCopyMatching(
            query as CFDictionary,
            &result
        )

        guard status == errSecSuccess,
              let data = result as? Data,
              let value = String(data: data, encoding: .utf8)
        else {
            return nil
        }

        return value
    }

    private func delete(forKey key: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key
        ]

        SecItemDelete(query as CFDictionary)
    }
}
