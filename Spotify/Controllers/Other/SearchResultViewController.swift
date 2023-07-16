//
//  SearchResultViewController.swift
//  Spotify
//
//  Created by oktay on 10.06.2023.
//

import UIKit

struct SearchSection {
    let title: String
    let result: [SearchResult]
}
protocol SearchResultViewControllerDelegate: AnyObject {
    func didTapResult(_ result: SearchResult)
}

class SearchResultViewController: UIViewController {

    private var sections: [SearchSection] = []
    
    weak var delegate: SearchResultViewControllerDelegate?
    
    private let tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .grouped)
        view.register(SearchResultSubtitleTableViewCell.self, forCellReuseIdentifier: SearchResultSubtitleTableViewCell.idendtfier)
        view.register(SearchResultDefaultTableViewCell.self, forCellReuseIdentifier: SearchResultDefaultTableViewCell.idendtfier)
        view.isHidden = true
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    func update(with result: [SearchResult]) {
        let artists = result.filter({
            switch $0 {
            case .artist: return true
            default: return false
            }
        })
        let albums = result.filter({
            switch $0 {
            case .album: return true
            default: return false
            }
        })
        let playlists = result.filter({
            switch $0 {
            case .playlist: return true
            default: return false
            }
        })
        let tracks = result.filter({
            switch $0 {
            case .track: return true
            default: return false
            }
        })
        self.sections = [
            SearchSection(title: "Songs", result: tracks),
            SearchSection(title: "Artists", result: artists),
            SearchSection(title: "Playlists", result: playlists),
            SearchSection(title: "Albums", result: albums),]
        tableView.reloadData()
        tableView.isHidden = result.isEmpty
    }
}

extension SearchResultViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].result.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let result = sections[indexPath.section].result[indexPath.row]

        switch result {
            case .artist(let artist):
                guard let artistCell = tableView.dequeueReusableCell(withIdentifier: SearchResultDefaultTableViewCell.idendtfier, for: indexPath) as? SearchResultDefaultTableViewCell else {
                    return UITableViewCell()
                }
                let vModel = SearchResultDefaultTableViewCellViewModel(title:artist.name , imageURL: URL(string: artist.images?.first?.url ?? ""))
                    artistCell.configure(with: vModel)
                return artistCell
            
            case .album(let album):
                guard let albumCell = tableView.dequeueReusableCell(withIdentifier: SearchResultSubtitleTableViewCell.idendtfier, for: indexPath) as? SearchResultSubtitleTableViewCell else {
                    return UITableViewCell()
                }
                let vModel = SearchResultSubtitleTableViewCellViewModel(title:album.name , subtitle: album.artists.first?.name ?? "", imageURL: URL(string: album.images.first?.url ?? ""))
                albumCell.configure(with: vModel)
                return albumCell
            
            case .playlist(let playlist):
                guard let playlistCell = tableView.dequeueReusableCell(withIdentifier: SearchResultSubtitleTableViewCell.idendtfier, for: indexPath) as? SearchResultSubtitleTableViewCell else {
                    return UITableViewCell()
                }
            let vModel = SearchResultSubtitleTableViewCellViewModel(title:playlist.name , subtitle: playlist.owner.display_name, imageURL: URL(string: playlist.images.first?.url ?? ""))
                playlistCell.configure(with: vModel)
                return playlistCell
            
            case .track(let track):
                guard let trackCell = tableView.dequeueReusableCell(withIdentifier: SearchResultSubtitleTableViewCell.idendtfier, for: indexPath) as? SearchResultSubtitleTableViewCell else {
                    return UITableViewCell()
                }
                let vModel = SearchResultSubtitleTableViewCellViewModel(title:track.name , subtitle: track.artists.first?.name ?? "-", imageURL: URL(string: track.album?.images.first?.url ?? ""))
                trackCell.configure(with: vModel)
                return trackCell
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let result = sections[indexPath.section].result[indexPath.row]
        delegate?.didTapResult(result)
    }
}
