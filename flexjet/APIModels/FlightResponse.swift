//
//  FlightResponse.swift
//  flexjet
//
//  Created by Nick Pappas on 9/9/26.
//

import Foundation

struct FlightResponse: Decodable, Identifiable {
    let id: String
    let tripNumber: String
    let flightNumber: String?
    let tailNumber: String
    let origin: String
    let originIata: String
    let destination: String
    let destinationIata: String
    let departure: Date
    let arrival: Date
    let price: Int
}
