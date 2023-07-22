//
//  SearchViewController.swift
//  Spotify
//
//  Created by oktay on 10.06.2023.
//

import UIKit
import SafariServices
class SearchViewController: UIViewController, UISearchResultsUpdating {

    private var categories = [Category]()
    let searchController: UISearchController = {
        let vc = UISearchController(searchResultsController: SearchResultViewController())
        vc.searchBar.placeholder = "Song, Artists, Albums"
        vc.searchBar.searchBarStyle = .minimal
        vc.definesPresentationContext = true
        return vc
    }()
    private let collectionView: UICollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { _, _ -> NSCollectionLayoutSection? in
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 7, bottom: 2, trailing: 7)
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize:NSCollectionLayoutSize(
                widthDimension:.fractionalWidth(1),
                heightDimension: .absolute(150)),
                subitem:item,
                count: 2)
            
            group.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0)
            
            return NSCollectionLayoutSection(group: group)
            
        }))
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        view.addSubview(collectionView)
        collectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        
        APICaller.shared.getCategories() { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    self?.categories = model
                    self?.collectionView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    func updateSearchResults(for searchController: UISearchController) {

    }

}

extension SearchViewController:UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate, SearchResultViewControllerDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier, for: indexPath) as? CategoryCollectionViewCell else {return UICollectionViewCell()}
        let category = categories[indexPath.row]
        cell.configure(model: CatetoryCollectionViewCellViewModel(title: category.name, artworkUrl: URL(string: category.icons.first?.url ?? "")))
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at:indexPath , animated: true)
        let category = self.categories[indexPath.row]
        let vc = CategoryViewController(category: category)
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let resultsController = searchController.searchResultsController as? SearchResultViewController, let query = searchBar.text, !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        resultsController.delegate = self
        
        APICaller.shared.search(with: query) { result in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let model):
                    resultsController.update(with: model)
                }
            }
            
        }
    }

    func didTapResult(_ result: SearchResult) {
        switch result {
            case .artist(let model):
                guard let url = URL(string: model.external_urls["spotify"] ?? "") else {
                    return
                }
                let safari = SFSafariViewController(url: url)
                present(safari, animated: true)
            case .album(let model):
                let vc = AlbumViewController(album: model)
                vc.navigationItem.largeTitleDisplayMode = .never
                navigationController?.pushViewController(vc, animated: true)
            case .playlist(let model):
                let vc = PlayListViewController(playlist: model)
                vc.navigationItem.largeTitleDisplayMode = .never
                navigationController?.pushViewController(vc, animated: true)
            case .track(let model):
            PlaybackPresenter.startPlayback(from: self, track: model)
        }
    }
}
