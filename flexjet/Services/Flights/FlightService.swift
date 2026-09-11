//
//  FlightService.swift
//  flexjet
//
//  Created by Nick Pappas on 9/9/26.
//

import Foundation

protocol FlightProtocol {
    func getFlights() async throws -> [FlightResponse]
}

final class FlightService: FlightProtocol {
    private let network: NetworkProtocol
    
    init(network: NetworkProtocol) {
        self.network = network
    }
    
    func getFlights() async throws -> [FlightResponse] {
        let url = URL(string: "https://v0-simple-authentication-api.vercel.app/api/flights")!

        let response: [FlightResponse] = try await network.request(
            url: url,
            method: "GET",
            body: Optional<String>.none
        )

        return response
    }
}
