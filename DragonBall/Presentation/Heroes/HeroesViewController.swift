//
//  HeroesViewController.swift
//  DragonBalliOSAvanzado
//
//  Created by Pedro on 16/10/23.
//

import UIKit

protocol HeroesViewControllerDelegate {
    var viewState: ((HeroesViewState) -> Void)? { get set }
    var heroesCount: Int { get }
    var heroes: Heroes { get set }

    func onViewAppear()
    func heroBy(index: Int) -> Hero?
    func heroDetailViewModel(index: Int) -> HeroDetailViewControllerDelegate?
}

enum HeroesViewState {
    case loading(_ isLoading: Bool)
    case updateData
}

class HeroesViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var viewModel: HeroesViewControllerDelegate?
    var originalHeroes: Heroes = []

    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        setObservers()
        viewModel?.onViewAppear()
        searchBar.delegate = self
        searchBar.placeholder = "Buscar Héroe"
        originalHeroes = viewModel?.heroes ?? []
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "HEROES_TO_HERO_DETAIL",
              let index = sender as? Int,
              let heroDetailViewController = segue.destination as? HeroDetailViewController,
              let detailViewModel = viewModel?.heroDetailViewModel(index: index)
        else {
            return
        }
        
        heroDetailViewController.viewModel = detailViewModel
    }
    
    private func initViews() {
        tableView.register(
            UINib(nibName: HeroCellView.identifier, bundle: nil),
            forCellReuseIdentifier: HeroCellView.identifier
        )

        tableView.delegate = self
        tableView.dataSource = self
    }

    private func setObservers() {
        viewModel?.viewState = { [weak self] state in
            DispatchQueue.main.async {
                switch state {
                    case .loading(let isLoading):
                        self?.loadingView.isHidden = !isLoading

                    case .updateData:
                        self?.tableView.reloadData()
                }
            }
        }
    }
}

extension HeroesViewController: UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.heroesCount ?? 0
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            if searchText.isEmpty {
                viewModel?.heroes = originalHeroes
                tableView.reloadData()
            } else {
                let filteredHeroes = originalHeroes.filter { hero in
                    guard let name = hero.name?.lowercased() else { return false }
                    return name.contains(searchText.lowercased())
                }

                viewModel?.heroes = filteredHeroes
                tableView.reloadData()
            }
        }
    

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        HeroCellView.estimatedHeight
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HeroCellView.identifier,
                                                       for: indexPath) as? HeroCellView else {
            return UITableViewCell()
        }

        if let hero = viewModel?.heroBy(index: indexPath.row) {
            cell.updateView(
                name: hero.name,
                photo: hero.photo,
                description: hero.description
            )
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: Navegar a detalle Hero
        performSegue(withIdentifier: "HEROES_TO_HERO_DETAIL", sender: indexPath.row)
    }
}
