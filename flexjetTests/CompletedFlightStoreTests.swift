//
//  CompletedFlightStoreTests.swift
//  flexjetTests
//
//  Created by Nick Pappas on 9/11/26.
//

import FactoryKit
import Foundation
import XCTest
@testable import flexjet

@MainActor
final class CompletedFlightsStoreTests: XCTestCase {
    private var sut: CompletedFlightsStore!

    override func setUp() {
        super.setUp()

        UserDefaults.standard.removeObject(forKey: "completed_flights")
        sut = Container.shared.completedFlightsStore()
    }

    override func tearDown() {
        Container.shared.completedFlightsStore.reset()
        UserDefaults.standard.removeObject(forKey: "completed_flights")
        sut = nil

        super.tearDown()
    }

    func test_complete_addsFlightID() {
        sut.complete("flight-123")

        XCTAssertTrue(sut.isCompleted("flight-123"))
    }

    func test_isCompleted_returnsFalseForUnknownID() {
        XCTAssertFalse(sut.isCompleted("flight-999"))
    }

    func test_complete_doesNotDuplicateIDs() {
        sut.complete("flight-123")
        sut.complete("flight-123")

        XCTAssertEqual(sut.completedIDs.count, 1)
    }
}
