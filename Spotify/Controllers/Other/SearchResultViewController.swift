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
        view.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        switch result {
            case .artist(let model):
            cell.textLabel?.text = model.name
            case .album(let model):
            cell.textLabel?.text = model.name
            case .playlist(let model):
            cell.textLabel?.text = model.name
            case .track(let model):
            cell.textLabel?.text = model.name
        }
        return cell
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
