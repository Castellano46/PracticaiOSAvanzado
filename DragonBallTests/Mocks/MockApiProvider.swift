//
//  MockApiProvider.swift
//  DragonBalliOSAvanzado
//
//  Created by Pedro on 25/10/23.
//

import Foundation
import DragonBalliOSAvanzado

class MockApiProvider: ApiProviderProtocol {

    func login(for user: String, with password: String) {
        NotificationCenter.default.post(
            name: NotificationCenter.apiLoginNotification,
            object: nil,
            userInfo: [NotificationCenter.tokenKey: "123456789abcdef"]
        )
    }

    func getHeroes(by name: String?, token: String, completion: ((Heroes) -> Void)?) {
        let responseDataHeroes: [[String: Any]] = [
            [
                "id": "D13A40E5-4418-4223-9CE6-D2F9A28EBE94",
                "name": "Goku",
                "description": "Sobran las presentaciones cuando se habla de Goku...",
                "photo": "https://cdn.alfabetajuega.com/alfabetajuega/2020/12/goku1.jpg?width=300",
                "favorite": false
            ],
            [
                "id": "6E1B907C-EB3A-45BA-AE03-44FA251F64E9",
                "name": "Vegeta",
                "description": "Vegeta es todo lo contrario. Es arrogante, cruel y despreciable...",
                "photo": "https://cdn.alfabetajuega.com/alfabetajuega/2020/12/vegetita.jpg?width=300",
                "favorite": false
            ]
        ]

        let data = try? JSONSerialization.data(withJSONObject: responseDataHeroes)
        let heroes = try? JSONDecoder().decode([Hero].self, from: data ?? Data())

        if let heroName {
            completion?(heroes?.filter { $0.name == heroName } ?? [])
        } else {
            completion?(heroes ?? [])
        }
    }

    func getLocations(by heroId: String, token: String, completion: ((HeroLocations) -> Void)?) {

        let mockLocations: HeroLocations = [
            HeroLocation(id: "1", latitude: "1.23", longitude: "4.56", date: "2023-10-25", hero: nil),
            HeroLocation(id: "2", latitude: "3.45", longitude: "6.78", date: "2023-10-26", hero: nil)
        ]
        
        completion?(mockLocations)
    }
}
