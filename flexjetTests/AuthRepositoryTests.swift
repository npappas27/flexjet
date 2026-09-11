//
//  AuthRepositoryTests.swift
//  flexjetTests
//
//  Created by Nick Pappas on 9/11/26.
//

import XCTest
import FactoryKit
import Security
@testable import flexjet

@MainActor
final class AuthRepositoryTests: XCTestCase {

    private var authService: AuthServiceMock!
    private var keychain: KeychainMock!

    override func setUp() {
        super.setUp()

        authService = AuthServiceMock()
        keychain = KeychainMock()

        Container.shared.authService.register { self.authService }
        Container.shared.keychain.register { self.keychain }
    }

    override func tearDown() {
        Container.shared.authService.reset()
        Container.shared.keychain.reset()
        authService = nil
        keychain = nil

        super.tearDown()
    }

    func test_init_restoresTokenFromKeychain() {
        keychain.storage["auth_token"] = "saved-token"

        let sut = AuthRepository()

        XCTAssertEqual(sut.token, "saved-token")
    }

    func test_init_withoutStoredToken_hasNoToken() {
        let sut = AuthRepository()

        XCTAssertNil(sut.token)
    }

    func test_login_success_savesAndPublishesToken() async throws {
        authService.result = .success("new-token")
        let sut = AuthRepository()

        try await sut.login(username: "user", password: "pass")

        XCTAssertEqual(sut.token, "new-token")
        XCTAssertEqual(keychain.storage["auth_token"], "new-token")
        XCTAssertEqual(authService.lastUsername, "user")
        XCTAssertEqual(authService.lastPassword, "pass")
    }

    func test_login_serviceFailure_throwsAndDoesNotSaveToken() async {
        authService.result = .failure(URLError(.badServerResponse))
        let sut = AuthRepository()

        do {
            try await sut.login(username: "user", password: "wrong")
            XCTFail("Expected login to throw")
        } catch {}

        XCTAssertNil(sut.token)
        XCTAssertNil(keychain.storage["auth_token"])
    }

    func test_login_keychainFailure_throwsAndDoesNotPublishToken() async {
        keychain.saveError = KeychainError.unhandledError(errSecInteractionNotAllowed)
        let sut = AuthRepository()

        do {
            try await sut.login(username: "user", password: "pass")
            XCTFail("Expected login to throw")
        } catch {}

        XCTAssertNil(sut.token)
    }

    func test_logout_clearsTokenFromMemoryAndKeychain() throws {
        keychain.storage["auth_token"] = "saved-token"
        let sut = AuthRepository()

        try sut.logout()

        XCTAssertNil(sut.token)
        XCTAssertNil(keychain.storage["auth_token"])
    }
}
