//
//  AuthProtocol.swift
//  flexjet
//
//  Created by Nick Pappas on 9/8/26.
//

import Foundation

protocol AuthProtocol {
    func login(username: String, password: String) async throws -> String?
}

final class AuthService: AuthProtocol {
    
    private let network: NetworkProtocol
    
    init(network: NetworkProtocol) {
        self.network = network
    }
    
    func login(username: String, password: String) async throws -> String? {
        let url = URL(string: "https://v0-simple-authentication-api.vercel.app/api/signIn")!
        
        let response: LoginResponse = try await network.request(
            url: url,
            method: "POST",
            body: LoginRequest(username: username, password: password)
        )
        return response.token
    }
}
