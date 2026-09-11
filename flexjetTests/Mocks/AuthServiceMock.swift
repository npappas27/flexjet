//
//  AuthServiceMock.swift
//  flexjetTests
//
//  Created by Nick Pappas on 9/11/26.
//

import Foundation

@testable import flexjet
final class AuthServiceMock: AuthProtocol {
    var result: Result<String?, Error> = .success("token-123")
    var loginCallCount = 0
    var lastUsername: String?
    var lastPassword: String?

    func login(username: String, password: String) async throws -> String? {
        loginCallCount += 1
        lastUsername = username
        lastPassword = password
        return try result.get()
    }
}
