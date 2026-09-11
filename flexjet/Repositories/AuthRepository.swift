//
//  AuthRepository.swift
//  flexjet
//
//  Created by Nick Pappas on 9/8/26.
//

import Combine
import FactoryKit
import Foundation

@MainActor
final class AuthRepository: ObservableObject {
    @Published private(set) var token: String?

    @Injected(\.authService) private var authService
    @Injected(\.keychain) private var keychain

    private let tokenKey = "auth_token"

    init() {
        token = keychain.read(tokenKey)
    }

    func login(username: String, password: String) async throws {
        let token = try await authService.login(
            username: username,
            password: password
        )

        guard let token else { return }
        try keychain.save(token, for: tokenKey)
        self.token = token
    }

    func logout() throws {
        try keychain.delete(tokenKey)
        token = nil
    }
}
