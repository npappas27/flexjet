//
//  FlightServiceMock.swift
//  flexjet
//
//  Created by Nick Pappas on 9/11/26.
//

import Foundation

@testable import flexjet
final class FlightServiceMock: FlightProtocol {
    var result: Result<[FlightResponse], Error> = .success([])
    var getFlightsCallCount = 0

    func getFlights() async throws -> [FlightResponse] {
        getFlightsCallCount += 1
        return try result.get()
    }
}
