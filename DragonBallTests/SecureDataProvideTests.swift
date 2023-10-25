//
//  SecureDataProvideTests.swift
//  DragonBalliOSAvanzadoTests
//
//  Created by Pedro on 25/10/23.
//

import XCTest
@testable import DragonBalliOSAvanzado

final class SecureDataProviderTest: XCTestCase {
    private var sut: SecureDataProviderProtocol!

    override func setUp() {
        sut = SecureDataProvider()
    }

    func test_givenSecureDataProvider_whenLoadToken_thenGetStoredToken() throws {
        let token = "123456abcde"
        sut.save(token: token)
        let tokenLoaded = sut.getToken()

        XCTAssertEqual(token, tokenLoaded)
    }
}
