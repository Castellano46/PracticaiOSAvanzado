//
//  DragonBallTest.swift
//  DragonBalliOSAvanzadoTests
//
//  Created by Pedro on 25/10/23.
//

import XCTest
@testable import DragonBalliOSAvanzado

final class DragonBallTests: XCTestCase {
    var heroes: [Hero] = []

    override func setUp() {
        heroes = [
            Hero(name: "Goku", powerLevel: 9000),
            Hero(name: "Superman", powerLevel: 10000),
            Hero(name: "Spider-Man", powerLevel: 5000)
        ]
    }

    override func tearDown() {
        heroes = []
    }

    func testExample() throws {
        XCTAssertEqual(2 + 2, 4, "La suma de 2 + 2 debería ser igual a 4.")
    }

    func testHeroInitialization() {
        XCTAssertNotNil(heroes)
        XCTAssertEqual(heroes.count, 3)
    }

    func testHeroFiltering() {
        let filteredHeroes = HeroFilter.filterWeakerHeroes(heroes, powerLevelThreshold: 7000)
        XCTAssertEqual(filteredHeroes.count, 2)
        XCTAssertTrue(filteredHeroes.contains { $0.name == "Goku" })
        XCTAssertTrue(filteredHeroes.contains { $0.name == "Spider-Man" })
    }

    func testAPIErrorHandling() {
        let apiSimulator = APISimulator(response: .error("Error de servidor"))

        let apiClient = YourAPIClient(apiSimulator)

        let expectation = XCTestExpectation(description: "API Request")
        apiClient.fetchData { result in
            switch result {
            case .success:
                XCTFail("No se esperaba un resultado exitoso.")
            case .failure(let error):
                XCTAssertEqual(error, .serverError("Error de servidor"))
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }
}
