//
//  FlightDetailsViewModel.swift
//  flexjet
//
//  Created by Nick Pappas on 9/11/26.
//

import Combine
import FactoryKit
import Foundation

final class FlightDetailsViewModel: ObservableObject {
    @Injected(\.completedFlightsStore) private var flightStore
    @Published private(set) var isCompleted = false
    
    init(flightId: String) {
        isCompleted = flightStore.isCompleted(flightId)
    }
    
    func completeFlight(id: String) {
        guard !isCompleted else { return }
        flightStore.complete(id)
        isCompleted = true
    }
}
