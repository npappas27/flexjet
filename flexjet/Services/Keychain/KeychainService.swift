//
//  KeychainService.swift
//  flexjet
//
//  Created by Nick Pappas on 9/9/26.
//

import Foundation
import Security

enum KeychainError: Error {
    case unhandledError(OSStatus)
}

protocol KeychainProtocol {
    func save(_ value: String, for key: String) throws
    func read(_ key: String) -> String?
    func delete(_ key: String) throws
}

final class KeychainService: KeychainProtocol {

    func save(_ value: String, for key: String) throws {
        let data = Data(value.utf8)

        // Replace existing value
        try? delete(key)

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]

        let status = SecItemAdd(query as CFDictionary, nil)

        guard status == errSecSuccess else {
            throw KeychainError.unhandledError(status)
        }
    }

    func read(_ key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var result: AnyObject?

        guard SecItemCopyMatching(
            query as CFDictionary,
            &result
        ) == errSecSuccess,
        let data = result as? Data else {
            return nil
        }

        return String(data: data, encoding: .utf8)
    }

    func delete(_ key: String) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]

        let status = SecItemDelete(query as CFDictionary)

        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw KeychainError.unhandledError(status)
        }
    }
}
