//
//  SecureDataProviderTests.swift
//  DragonBalliOSAvanzadoTests
//
//  Created by Pedro on 26/10/23.
//

import XCTest
@testable import DragonBalliOSAvanzado

class SecureDataProviderTests: XCTestCase {
    var secureDataProvider: SecureDataProviderProtocol!

    override func setUp() {
        super.setUp()
        secureDataProvider = SecureDataProvider()
    }

    override func tearDown() {
        super.tearDown()
        secureDataProvider = nil
    }

    func test_SaveAndLoadToken() {
        let token = "your_token_here"
        secureDataProvider.save(token: token)
        let loadedToken = secureDataProvider.getToken()
        XCTAssertEqual(loadedToken, token)
    }
}
