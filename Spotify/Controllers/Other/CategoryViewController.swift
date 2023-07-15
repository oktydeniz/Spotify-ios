//
//  CategoryViewController.swift
//  Spotify
//
//  Created by oktay on 15.07.2023.
//

import UIKit

class CategoryViewController: UIViewController {
    
    private let category: Category
    private var playlist = [PlayList]()
    
    
    // MARK: init UI
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { _, _ -> NSCollectionLayoutSection in
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(250)), subitem: item, count: 2)
        
        group.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        return NSCollectionLayoutSection(group: group)
    }))
    
    
    init(category: Category) {
        self.category = category
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = category.name
        view.addSubview(collectionView)
        view.backgroundColor = .systemBackground
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(FeaturedPlaylistCollectionViewCell.self, forCellWithReuseIdentifier: FeaturedPlaylistCollectionViewCell.identifier)
        APICaller.shared.getCategoryPlaylist(category: category) {[weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    self?.playlist = model
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

}

 // MARK: Deletages

extension CategoryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        playlist.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeaturedPlaylistCollectionViewCell.identifier, for: indexPath) as? FeaturedPlaylistCollectionViewCell else {
            return UICollectionViewCell()
        }
        let plist = playlist[indexPath.row]
        cell.configure(with: FeaturedPlaylistCellViewModel(name:plist.name , artworkURL: URL(string: plist.images.first?.url ?? ""), creatorName: plist.owner.display_name))
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let vc = PlayListViewController(playlist: playlist[indexPath.row])
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
