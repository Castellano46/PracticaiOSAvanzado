//
//  ValidationFieldsTests.swift
//  DragonBalliOSAvanzadoTests
//
//  Created by Pedro on 25/10/23.
//

import XCTest
@testable import DragonBalliOSAvanzado

final class ValidationFieldsTest: XCTestCase {
    private var sut: LoginViewModel!

    override  func setUp() {
        let secureData = SecureDataProvider()
        sut = LoginViewModel(apiProvider: ApiProvider(secureDataProvider: secureData), secureDataProvider: secureData)
    }

    func test_givenValidEmail_whenIsValid_thenTrue() throws {
        let validEmail = "d.jardon@gmail.com"
        let isEmailValid = sut.isValid(email: validEmail)

        XCTAssertTrue(isEmailValid)
    }

    func test_givenValidEmail_whenNotValid_thenFalse() throws {
        let invalidEmail = "d.jardongmail.com"
        let isEmailValid = sut.isValid(email: invalidEmail)

        XCTAssertFalse(isEmailValid)
    }
}
