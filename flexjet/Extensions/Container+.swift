//
//  Container+.swift
//  flexjet
//
//  Created by Nick Pappas on 9/8/26.
//

import FactoryKit
import Foundation

@MainActor
extension Container {
    var keychain: Factory<KeychainProtocol> {
        self { KeychainService() }
            .singleton
    }

    var networkService: Factory<NetworkProtocol> {
        self {
            NetworkService(keychain: self.keychain())
        }
        .singleton
    }

    var authService: Factory<AuthProtocol> {
        self {
            AuthService(network: self.networkService())
        }
        .singleton
    }

    var flightService: Factory<FlightProtocol> {
        self {
            FlightService(network: self.networkService())
        }
        .singleton
    }

    var authRepository: Factory<AuthRepository> {
        self { AuthRepository() }
            .singleton
    }

    var completedFlightsStore: Factory<CompletedFlightsStore> {
        self { CompletedFlightsStore() }
            .singleton
    }
}
