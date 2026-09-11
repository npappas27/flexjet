//
//  KeychainMock.swift
//  flexjetTests
//
//  Created by Nick Pappas on 9/11/26.
//

import Foundation

@testable import flexjet
final class KeychainMock: KeychainProtocol {
    var storage: [String: String] = [:]
    var saveError: Error?

    func save(_ value: String, for key: String) throws {
        if let saveError { throw saveError }
        storage[key] = value
    }

    func read(_ key: String) -> String? {
        storage[key]
    }

    func delete(_ key: String) throws {
        storage[key] = nil
    }
}
