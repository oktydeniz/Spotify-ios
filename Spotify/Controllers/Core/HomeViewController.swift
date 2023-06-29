//
//  ViewController.swift
//  Spotify
//
//  Created by oktay on 10.06.2023.
//

import UIKit

enum BrowsSectionType{
    case newReleases(viewModels: [NewReleasesCellViewModel]) // 1
    case featuredPlaylist(viewModels: [FeaturedPlaylistCellViewModel]) // 2
    case recomantationTracks(viewModels: [RecomendedTrackCellVİewModel]) // 3
}

class HomeViewController: UIViewController {

    private var collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout{
        sectionIndex, _ -> NSCollectionLayoutSection? in
        return HomeViewController.createSectionLayout(section: sectionIndex)
    })
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.tintColor = .label
        spinner.hidesWhenStopped = true
        return spinner
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .done, target: self, action: #selector(didTabSettings))
        
        
        configureCollectionView()
        view.addSubview(spinner)
        fetcData()
    }
    
    private var sections = [BrowsSectionType]()
    
    private func configureCollectionView(){
        view.addSubview(collectionView)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
        collectionView.register(NewReleasesCollectionViewCell.self, forCellWithReuseIdentifier: NewReleasesCollectionViewCell.identifier)
        collectionView.register(FeaturedPlaylistCollectionViewCell.self, forCellWithReuseIdentifier: FeaturedPlaylistCollectionViewCell.identifier)
        collectionView.register(RecommendedTrackCollectionViewCell.self, forCellWithReuseIdentifier: RecommendedTrackCollectionViewCell.identifier)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    private func fetcData() {
        let group = DispatchGroup()
        
        group.enter()
        group.enter()
        group.enter()
        
        var newReleases: NewReleasesResponse?
        var featurePlayList: FeaturedPlaylistResponse?
        var recomantation: RecommendationsResponse?
        
        
        APICaller.shared.getNewReleases { result in
            
            defer {
                group.leave()
            }
            switch result {
            case .success(let model):
                newReleases = model
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        APICaller.shared.getFeaturedPlaylists { result in
            defer {
                group.leave()
            }
            switch result {
            case .success(let model):
                featurePlayList = model
            case .failure(let error):
                print(error.localizedDescription)
            }
            
        }
        
        APICaller.shared.getRecommendationsGenres(complation: { result in
            switch(result){
            case .success(let model):
                let genres = model.genres
                var seeds = Set<String>()
                while seeds.count < 5 {
                    if let random = genres.randomElement() {
                        seeds.insert(random)
                    }
                }
                APICaller.shared.getRecommendations(genres: seeds, complation: { result in
                    defer {
                        group.leave()
                    }
                    switch(result){
                    case .success(let model):
                        recomantation = model
                    case.failure(let error):
                        print(error.localizedDescription)
                    }
                })
                break
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
        
        group.notify(queue: .main) {
            guard let newAlbums = newReleases?.albums.items,
                  let playlist = featurePlayList?.playlists.items,
                  let tracks = recomantation?.tracks else {return}
            
            self.configureModels(newAlbums: newAlbums, tracks: tracks, playlist: playlist)
        }
    }
    
    private func configureModels(newAlbums:[Album], tracks:[AudioTrack], playlist:[PlayList]) {
        // Configure Models
        sections.append(.newReleases(viewModels:newAlbums.compactMap({
            return NewReleasesCellViewModel(name: $0.name, artworkUrl: URL(string: $0.images.first?.url ?? ""), numberOfTracks: $0.total_tracks, artistName: $0.artists.first?.name ?? "-")
        })))
        
        sections.append(.featuredPlaylist(viewModels: playlist.compactMap({
            return FeaturedPlaylistCellViewModel(name: $0.name, artworkURL: URL(string: $0.images.first?.url ?? ""), creatorName: $0.owner.display_name)
        })))
        
        sections.append(.recomantationTracks(viewModels: tracks.compactMap({
            return RecomendedTrackCellVİewModel(name: $0.name, artistName: $0.artists.first?.name ?? "", artworkURL: URL(string: $0.album.images.first?.url ?? ""))
        })))
        collectionView.reloadData()
    }
    
    @objc func didTabSettings(){
        let vc = SettingsViewController()
        vc.title = "Settings"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }


}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let type = sections[section]
        switch type {
        case .newReleases(let viewModels):
            return viewModels.count
        case .featuredPlaylist(let viewModels):
            return viewModels.count
        case .recomantationTracks(let viewModels):
            return viewModels.count
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let type = sections[indexPath.section]
        
        switch type {
        case .newReleases(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewReleasesCollectionViewCell.identifier, for: indexPath) as? NewReleasesCollectionViewCell else {
                return UICollectionViewCell()
            }
            let viewModel = viewModels[indexPath.row]
            cell.configure(with: viewModel)
            return cell
        case .featuredPlaylist(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeaturedPlaylistCollectionViewCell.identifier, for: indexPath) as? FeaturedPlaylistCollectionViewCell else {
                return UICollectionViewCell()
            }
            let viewModel = viewModels[indexPath.row]
            cell.configure(with: viewModel)
            return cell
        case .recomantationTracks(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendedTrackCollectionViewCell.identifier, for: indexPath) as? RecommendedTrackCollectionViewCell else {
                return UICollectionViewCell()
            }
            let viewModel = viewModels[indexPath.row]
            cell.configure(with: viewModel)
            return cell
        }
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    
    static func createSectionLayout(section:Int) ->NSCollectionLayoutSection {
        switch section {
        case 0:
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            
            //Vertical group in horizantal group
            let verticalGroup =  NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(390)), subitem: item, count: 3)
            
            let horizantalGroup =  NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .absolute(390)), subitem:verticalGroup, count: 1)
            
            let section = NSCollectionLayoutSection(group: horizantalGroup)
            
            section.orthogonalScrollingBehavior = .groupPaging
            
            return section
        case 1:
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(200), heightDimension: .absolute(200)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            
            let verticalGroup =  NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(200), heightDimension: .absolute(400)), subitem:item, count: 2)
            
            let horizantalGroup =  NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(200), heightDimension: .absolute(400)), subitem:verticalGroup, count: 1)
            
            let section = NSCollectionLayoutSection(group: horizantalGroup)
            
            section.orthogonalScrollingBehavior = .continuous
            
            return section
        case 2:
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            
            
            let group =  NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(80)), subitem:item, count: 1)
            
            let section = NSCollectionLayoutSection(group: group)
            return section
        default:
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            
            let group =  NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(390)), subitem: item, count: 1)
            
            let section = NSCollectionLayoutSection(group: group)
            
            return section
        }
    }
}

