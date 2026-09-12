//
//  FlightsViewModel.swift
//  flexjet
//
//  Created by Nick Pappas on 9/8/26.
//

import Combine
import FactoryKit
import Foundation

final class FlightsViewModel: ObservableObject {
    @Injected(\.flightService) var flightService
    @Injected(\.completedFlightsStore) var flightStore
    @Published var tabSelection: TabSelection = .upcoming
    @Published private(set) var upcomingFlights: [FlightResponse] = []
    @Published private(set) var pastFlights: [FlightResponse] = []
    @Published private(set) var state: ViewState = .idle
    @Published private var completedFlightIDs: Set<String> = []

    init() {
        flightStore.$completedIDs
            .assign(to: &$completedFlightIDs)
    }

    func isCompleted(_ id: String) -> Bool {
        flightStore.isCompleted(id)
    }
    
    func getFlights(refresh: Bool = false) async {
        guard refresh || state == .idle || state == .error else { return }
        do {
            if !refresh { state = .loading }
            let flights = try await flightService.getFlights()
            organizeFlights(flights)
            state = .loaded
        } catch {
            state = .error
        }
    }
    func organizeFlights(_ flights: [FlightResponse]) {
        let now = Date()

        upcomingFlights = flights
            .filter { $0.departure >= now }
            .sorted { $0.departure < $1.departure }

        pastFlights = flights
            .filter { $0.departure < now }
            .sorted { $0.departure > $1.departure }
    }
    
    enum TabSelection {
        case upcoming, past
    }
    
    
    enum ViewState {
        case loading, loaded, error, idle
    }
}
