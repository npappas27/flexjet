//
//  FlightsViewModelTests.swift
//  flexjetTests
//
//  Created by Nick Pappas on 9/11/26.
//

import XCTest
import FactoryKit
@testable import flexjet

@MainActor
final class FlightsViewModelTests: XCTestCase {

    private var mockService: FlightServiceMock!
    private var viewModel: FlightsViewModel!

    override func setUp() {
        super.setUp()

        mockService = FlightServiceMock()

        Container.shared.flightService.register {
            self.mockService
        }

        viewModel = FlightsViewModel()
    }

    override func tearDown() {
        Container.shared.flightService.reset()
        super.tearDown()
    }

    func test_getFlights_success_setsLoadedState() async {
        mockService.result = .success([])

        await viewModel.getFlights()

        XCTAssertEqual(viewModel.state, .loaded)
        XCTAssertEqual(mockService.getFlightsCallCount, 1)
        XCTAssertTrue(viewModel.upcomingFlights.isEmpty)
        XCTAssertTrue(viewModel.pastFlights.isEmpty)
    }

    func test_getFlights_failure_setsErrorState() async {
        mockService.result = .failure(URLError(.badURL))
        
        await viewModel.getFlights()

        XCTAssertEqual(viewModel.state, .error)
        XCTAssertEqual(mockService.getFlightsCallCount, 1)
    }

    func test_getFlights_afterFailure_retries() async {
        mockService.result = .failure(URLError(.notConnectedToInternet))
        await viewModel.getFlights()

        mockService.result = .success([])
        await viewModel.getFlights()

        XCTAssertEqual(viewModel.state, .loaded)
        XCTAssertEqual(mockService.getFlightsCallCount, 2)
    }

    func test_getFlights_whenLoaded_doesNotRefetchWithoutRefresh() async {
        mockService.result = .success([])
        await viewModel.getFlights()

        await viewModel.getFlights()

        XCTAssertEqual(mockService.getFlightsCallCount, 1)
    }

    func test_organizeFlights_splitsUpcomingAndPastFlights() {
        let past = makeFlight(departure: Date().addingTimeInterval(-3600))
        let upcoming = makeFlight(departure: Date().addingTimeInterval(3600))

        viewModel.organizeFlights([past, upcoming])

        XCTAssertEqual(viewModel.pastFlights.count, 1)
        XCTAssertEqual(viewModel.upcomingFlights.count, 1)
    }

    func test_organizeFlights_sortsFlightsCorrectly() {
        let upcomingSoon = makeFlight(departure: Date().addingTimeInterval(3600))
        let upcomingLater = makeFlight(departure: Date().addingTimeInterval(7200))

        let pastRecent = makeFlight(departure: Date().addingTimeInterval(-3600))
        let pastOlder = makeFlight(departure: Date().addingTimeInterval(-7200))

        viewModel.organizeFlights([
            upcomingLater,
            pastOlder,
            upcomingSoon,
            pastRecent
        ])

        XCTAssertEqual(viewModel.upcomingFlights.map(\.departure), [
            upcomingSoon.departure,
            upcomingLater.departure
        ])

        XCTAssertEqual(viewModel.pastFlights.map(\.departure), [
            pastRecent.departure,
            pastOlder.departure
        ])
    }
    
    private func makeFlight(departure: Date) -> FlightResponse {
        FlightResponse(
            id: UUID().uuidString,
            tripNumber: "TRIP-123",
            flightNumber: "FL-456",
            tailNumber: "N12345",
            origin: "Cleveland",
            originIata: "CLE",
            destination: "New York",
            destinationIata: "LGA",
            departure: departure,
            arrival: departure.addingTimeInterval(7200),
            price: 500
        )
    }
}
