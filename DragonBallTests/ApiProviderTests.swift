//
//  ApiProviderTests.swift
//  DragonBalliOSAvanzadoTests
//
//  Created by Pedro on 26/10/23.
//

import XCTest
@testable import DragonBalliOSAvanzado

class ApiProviderTests: XCTestCase {
    var apiProvider: ApiProviderProtocol!
    var secureDataProvider: SecureDataProviderProtocol = SecureDataProvider()

    override func setUp() {
        super.setUp()
        apiProvider = MockApiProvider(secureDataProvider: secureDataProvider)
    }

    override func tearDown() {
        super.tearDown()
        apiProvider = nil
    }

    func test_LoginWithValidCredentials() {
        let expectation = self.expectation(description: "Login completion")

        apiProvider.login(for: "username", with: "password")

        DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)
    }

    func test_FetchHeroes() {
        let expectation = self.expectation(description: "Fetch heroes completion")

        apiProvider.getHeroes(by: nil, token: "your_token_here") { heroes in
            XCTAssertNotNil(heroes)
            XCTAssertGreaterThan(heroes.count, 0)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)
    }
}
