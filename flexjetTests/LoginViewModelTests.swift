//
//  LoginViewModelTests.swift
//  flexjetTests
//
//  Created by Nick Pappas on 9/11/26.
//

import XCTest
import FactoryKit
@testable import flexjet

@MainActor
final class LoginViewModelTests: XCTestCase {

    private var authService: AuthServiceMock!
    private var keychain: KeychainMock!
    private var authRepository: AuthRepository!
    private var sut: LoginViewModel!

    override func setUp() {
        super.setUp()

        authService = AuthServiceMock()
        keychain = KeychainMock()

        Container.shared.authService.register { self.authService }
        Container.shared.keychain.register { self.keychain }
        Container.shared.authRepository.register { AuthRepository() }

        authRepository = Container.shared.authRepository()
        sut = LoginViewModel()
    }

    override func tearDown() {
        Container.shared.authService.reset()
        Container.shared.keychain.reset()
        Container.shared.authRepository.reset()
        authService = nil
        keychain = nil
        authRepository = nil
        sut = nil

        super.tearDown()
    }

    func test_login_emptyFields_setsValidationErrorWithoutCallingService() async {
        sut.username = "user"

        await sut.login()

        XCTAssertEqual(sut.errorMessage, "Username and password are required.")
        XCTAssertEqual(authService.loginCallCount, 0)
    }

    func test_login_success_signsInWithoutError() async {
        sut.username = "user"
        sut.password = "pass"

        await sut.login()

        XCTAssertNil(sut.errorMessage)
        XCTAssertFalse(sut.isLoading)
        XCTAssertEqual(authRepository.token, "token-123")
    }

    func test_login_failure_setsGenericErrorMessage() async {
        authService.result = .failure(URLError(.badServerResponse))
        sut.username = "user"
        sut.password = "wrong"

        await sut.login()

        XCTAssertEqual(sut.errorMessage, "We're sorry, that didn't work. Please try again.")
        XCTAssertFalse(sut.isLoading)
        XCTAssertNil(authRepository.token)
    }

    func test_editingField_clearsErrorMessage() async {
        await sut.login()
        XCTAssertNotNil(sut.errorMessage)

        sut.username = "u"

        XCTAssertNil(sut.errorMessage)
    }
}
