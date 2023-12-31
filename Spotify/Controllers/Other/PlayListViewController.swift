//
//  PlayListViewController.swift
//  Spotify
//
//  Created by oktay on 10.06.2023.
//

import UIKit

class PlayListViewController: UIViewController {
    
    private var viewModels = [RecomendedTrackCellVİewModel]()
    private let playlist: PlayList
    private  var tracks  = [AudioTrack]()
    public var isOwner = false
    private let collectionView = UICollectionView(frame: .zero,
                                                  collectionViewLayout: UICollectionViewCompositionalLayout(
                                                    sectionProvider: { _, _ -> NSCollectionLayoutSection? in
                                                        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
                                                        item.contentInsets = NSDirectionalEdgeInsets(top: 1, leading: 2, bottom: 1, trailing: 2)
                                                        
                                                        
                                                        let group =  NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(60)), subitem:item, count: 1)
                                                        
                                                        let section = NSCollectionLayoutSection(group: group)
                                                        section.boundarySupplementaryItems = [
                                                            NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
                                                        ]
                                                        return section
                                                    }
                                                  ))
    
    
    init(playlist:PlayList) {
        self.playlist = playlist
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = playlist.name
        view.backgroundColor = .secondarySystemBackground
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(PlaylistHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: PlaylistHeaderCollectionReusableView.identifier)
        collectionView.register(RecommendedTrackCollectionViewCell.self, forCellWithReuseIdentifier: RecommendedTrackCollectionViewCell.identifier)
        collectionView.backgroundColor = .secondarySystemBackground
        
        APICaller.shared.getPlaylistDetails(for: playlist) { [weak self] result in
            DispatchQueue.main.async {
                switch (result) {
                case .success(let model):
                    self?.tracks = model.tracks.items.compactMap({$0.track})
                    self?.viewModels = model.tracks.items.compactMap({
                        RecomendedTrackCellVİewModel(name: $0.track.name, artistName: $0.track.artists.first?.name ?? "-", artworkURL: URL(string:  $0.track.album?.images.first?.url ?? ""))
                    })
                    self?.collectionView.reloadData()
                case .failure(let error):
                    print(error)
                }
            }
        }
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(didLongPress(_:)))
        collectionView.addGestureRecognizer(gesture)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapShare))
    }
    
    @objc func didLongPress(_ gesture:UILongPressGestureRecognizer) {
        guard gesture.state == .began else {return}
        let touchPoint = gesture.location(in: collectionView)
        guard let indexPath = collectionView.indexPathForItem(at: touchPoint) else {return}
        
        let trackToDelete = tracks[indexPath.row]
        
        let actionSheet = UIAlertController(title: trackToDelete.name, message: "Would you like to remove this from th playlist?", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Remove", style: .destructive) { [weak self] _ in
            guard let strongSelf = self else {return }
            APICaller.shared.removeTrackFromPlaylist(track: trackToDelete, playlist: strongSelf.playlist, completion: { success in
                DispatchQueue.main.async {
                    if success {
                        print("Removed")
                        strongSelf.tracks.remove(at: indexPath.row)
                        strongSelf.viewModels.remove(at: indexPath.row)
                        strongSelf.collectionView.reloadData()
                    } else {
                        print("Faild to Remove")
                    }
                }
            } )
        })
        present(actionSheet, animated: true, completion: nil)
        
    }
    
    @objc private func didTapShare() {
        guard let url = URL(string: playlist.external_urls["spotify"] ?? "") else {return}
        let vc = UIActivityViewController(activityItems: [url], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
        
    }
    
}


extension PlayListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendedTrackCollectionViewCell.identifier, for: indexPath) as? RecommendedTrackCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: viewModels[indexPath.row])
        
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let index = indexPath.row
        let track = tracks[index]
        PlaybackPresenter.shared.startPlayback(from: self, track: track)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: PlaylistHeaderCollectionReusableView.identifier, for: indexPath) as? PlaylistHeaderCollectionReusableView, kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        let headerVM = PlaylistHeaderViewModel(name: playlist.name, ownerName: playlist.owner.display_name, desctiption: playlist.description, artworkURL: URL(string: playlist.images.first?.url ?? ""))
        header.configure(with: headerVM)
        header.delegate = self
        return header
    }
    
}


extension PlayListViewController: PlaylistHeaderCollectionReusableViewDelegate {
    
    func playlistHeaderCollectionReusableViewDidTapPlayAll(_ header: PlaylistHeaderCollectionReusableView) {
        PlaybackPresenter.shared.startPlayback(from: self, tracks: tracks)
    }
}
