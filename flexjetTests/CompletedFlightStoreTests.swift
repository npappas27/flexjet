//
//  CompletedFlightStoreTests.swift
//  flexjetTests
//
//  Created by Nick Pappas on 9/11/26.
//

import Foundation
import XCTest
@testable import flexjet

final class CompletedFlightsStoreTests: XCTestCase {

    override func setUp() {
        super.setUp()
        CompletedFlightsStore.ids = []
    }

    func test_complete_addsFlightID() {
        CompletedFlightsStore.complete("flight-123")

        XCTAssertTrue(CompletedFlightsStore.isCompleted("flight-123"))
    }

    func test_isCompleted_returnsFalseForUnknownID() {
        XCTAssertFalse(CompletedFlightsStore.isCompleted("flight-999"))
    }

    func test_complete_doesNotDuplicateIDs() {
        CompletedFlightsStore.complete("flight-123")
        CompletedFlightsStore.complete("flight-123")

        XCTAssertEqual(CompletedFlightsStore.ids.count, 1)
    }
}
