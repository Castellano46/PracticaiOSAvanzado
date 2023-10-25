//
//  ApiProviderTests.swift
//  DragonBalliOSAvanzadoTests
//
//  Created by Pedro on 25/10/23.
//

import XCTest
@testable import DragonBalliOSAvanzado

final class ApiProviderTest: XCTestCase {
    private var sut: ApiProviderProtocol!

    override func setUp() {
        sut = MockApiService(secureDataProvider: SecureDataProvider())
    }

    func test_givenApiProvider_whenLoginWithUserAndPassword_thenGetValidToken() throws {
        let handler: (Notification) -> Bool = { notification in
            let token = notification.userInfo?[NotificationCenter.tokenKey] as? String
            XCTAssertNotNil(token)
            XCTAssertNotEqual(token ?? "", "")

            return true
        }

        let expectation = self.expectation(
            forNotification: NotificationCenter.apiLoginNotification,
            object: nil,
            handler: handler
        )

        sut.login(for: "d.jardon@gmail.com", with: "120485")
        wait(for: [expectation], timeout: 10.0)
    }

    func test_givenApiProvider_whenGetAllHeroes_ThenHeroesExists() throws {
        let expectation = self.expectation(description: "Fetch one hero data")

        self.sut.getHeroes(nil) { result in
            switch result {
            case .success(let heroes):
                XCTAssertNotEqual(heroes.count, 0)
            case .failure(let error):
                XCTFail("Error: \(error)")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 10.0)
    }

    func test_givenApiProvider_whenGetOneHero_ThenHeroExists() throws {
        let expectation = self.expectation(description: "Fetch one hero data")

        let heroName = "Goku"
        self.sut.getHeroes(heroName) { result in
            switch result {
            case .success(let heroes):
                XCTAssertEqual(heroes.count, 1)
                XCTAssertEqual(heroes.first?.name ?? "", heroName)
            case .failure(let error):
                XCTFail("Error: \(error)")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 10.0)
    }

    func test_givenApiProvider_whenGetOneHero_ThenHeroNotExists() throws {
        let expectation = self.expectation(description: "Fetch one hero data")

        let heroName = "Thanos"
        self.sut.getHeroes(heroName) { result in
            switch result {
            case .success(let heroes):
                XCTAssertEqual(heroes.count, 0)
            case .failure(let error):
                XCTFail("Error: \(error)")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 10.0)
    }
}
