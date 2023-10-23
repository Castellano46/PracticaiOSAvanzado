//
//  HeroesViewModel.swift
//  DragonBalliOSAvanzado
//
//  Created by Pedro on 16/10/23.
//

import Foundation

class HeroesViewModel: HeroesViewControllerDelegate {
    var viewModel: HeroesViewModel?
    
    private let apiProvider: ApiProviderProtocol
    private let secureDataProvider: SecureDataProviderProtocol

    var viewState: ((HeroesViewState) -> Void)?
    var heroesCount: Int {
        heroes.count
    }

    var heroes: Heroes = []
    var originalHeroes: Heroes = []

    init(apiProvider: ApiProviderProtocol, secureDataProvider: SecureDataProviderProtocol) {
        self.apiProvider = apiProvider
        self.secureDataProvider = secureDataProvider
    }

    func onViewAppear() {
        viewState?(.loading(true))

        DispatchQueue.global().async {
            defer { self.viewState?(.loading(false)) }
            guard let token = self.secureDataProvider.getToken() else { return }

            self.apiProvider.getHeroes(by: nil, token: token) { heroes in
                self.originalHeroes = heroes
                self.heroes = heroes
                self.viewState?(.updateData)
            }
        }
    }

    func heroBy(index: Int) -> Hero? {
        if index >= 0 && index < heroesCount {
            return heroes[index]
        } else {
            return nil
        }
    }

    func heroDetailViewModel(index: Int) -> HeroDetailViewControllerDelegate? {
        guard let selectedHero = heroBy(index: index) else { return nil }
        return HeroDetailViewModel(hero: selectedHero, apiProvider: apiProvider, secureDataProvider: secureDataProvider)
    }

    func filterHeroes(with searchText: String) {
        if searchText.isEmpty {
            heroes = originalHeroes
        } else {
            heroes = originalHeroes.filter { hero in
                guard let name = hero.name?.lowercased() else { return false }
                return name.contains(searchText.lowercased())
            }
        }
        viewState?(.updateData)
    }
}
