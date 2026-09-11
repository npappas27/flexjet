//
//  NetworkingService.swift
//  flexjet
//
//  Created by Nick Pappas on 9/8/26.
//

import Foundation

protocol NetworkProtocol {
    func request<Request: Encodable, Response: Decodable>(
        url: URL,
        method: String,
        body: Request?
    ) async throws -> Response
}

final class NetworkService: NetworkProtocol {
    private let keychain: KeychainProtocol

    init(keychain: KeychainProtocol) {
        self.keychain = keychain
    }

    func request<Request: Encodable, Response: Decodable>(
        url: URL,
        method: String,
        body: Request?
    ) async throws -> Response {
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if let token = keychain.read("auth_token") {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        if let body {
            request.httpBody = try JSONEncoder().encode(body)
        }

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let response = response as? HTTPURLResponse,
              200..<300 ~= response.statusCode else {
            throw URLError(.badServerResponse)
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        return try decoder.decode(Response.self, from: data)
    }
}
