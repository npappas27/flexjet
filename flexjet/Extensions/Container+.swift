//
//  Container+.swift
//  flexjet
//
//  Created by Nick Pappas on 9/8/26.
//

import FactoryKit
import Foundation

extension Container {
    
    @MainActor
    var networkService: Factory<NetworkProtocol> {
        self { NetworkService(keychain: self.keychain()) }
            .singleton
    }

    @MainActor
    var authService: Factory<AuthProtocol> {
        self {
            AuthService(network: self.networkService())
        }
        .singleton
    }
    
    @MainActor
    var flightService: Factory<FlightProtocol> {
        self {
            FlightService(network: self.networkService())
        }
        .singleton
    }
    
    @MainActor
    var authRepository: Factory<AuthRepository> {
        self {
            AuthRepository()
        }
        .singleton
    }
    
    @MainActor
    var keychain: Factory<KeychainProtocol> {
        self { KeychainService() }
            .singleton
    }
}
