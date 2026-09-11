//
//  DateRelativeShortTests.swift
//  flexjetTests
//
//  Created by Nick Pappas on 9/11/26.
//

import XCTest

@testable import flexjet
final class DateRelativeShortTests: XCTestCase {

    func testOneDayAgo() {
        let date = Date().addingTimeInterval(-86_400)

        XCTAssertEqual(date.relativeShort, "1d ago")
    }

    func testSixDaysAgo() {
        let date = Date().addingTimeInterval(-86_400 * 6)

        XCTAssertEqual(date.relativeShort, "6d ago")
    }

    func testSevenDaysAgo() {
        let date = Date().addingTimeInterval(-86_400 * 7)

        XCTAssertEqual(date.relativeShort, "1w ago")
    }

    func testFourteenDaysAgo() {
        let date = Date().addingTimeInterval(-86_400 * 14)

        XCTAssertEqual(date.relativeShort, "2w ago")
    }

    func testLessThanOneDayStillShowsOneDay() {
        let date = Date().addingTimeInterval(-3_600)

        XCTAssertEqual(date.relativeShort, "1d ago")
    }
}
