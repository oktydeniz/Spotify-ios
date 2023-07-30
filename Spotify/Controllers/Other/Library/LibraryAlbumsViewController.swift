//
//  LibraryAlbumsViewController.swift
//  Spotify
//
//  Created by oktay on 26.07.2023.
//

import UIKit

class LibraryAlbumsViewController: UIViewController {
    private  var album = [Album]()
    private let noAlbumView = ActionLabel()
    private var observer: NSObjectProtocol?
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(SearchResultSubtitleTableViewCell.self, forCellReuseIdentifier: SearchResultSubtitleTableViewCell.idendtfier)
        tableView.isHidden = true
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        setUpAlbumView()
        fetchData()
        observer = NotificationCenter.default.addObserver(forName: .albumSavedNotification, object: nil, queue: .main, using: { [weak self] _ in 
            self?.fetchData()
        })
   
    }
    
    @objc func didTapClose() {
        dismiss(animated: true, completion: nil)
    }
    
    public func updateUI() {
        if album.isEmpty {
            noAlbumView.isHidden = false
            tableView.isHidden = true
        } else {
            tableView.reloadData()
            noAlbumView.isHidden = true
            tableView.isHidden = false
        }
    }
    
    private func fetchData() {
        album.removeAll()
        APICaller.shared.getCurrentUserAlbum{ [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    self?.album = model
                    self?.updateUI()
                case .failure(let error): print(error.localizedDescription)
                }
            }
        }
    }
    
    private func setUpAlbumView() {
        view.addSubview(noAlbumView)
        noAlbumView.delegate = self
        noAlbumView.configure(with: ActionLabelViewModel(text: "You have not saved any Albums yet.", actionTitle: "Browse"))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        noAlbumView.frame = CGRect(x: (view.width - 150) / 2, y: (view.height - 150) / 2, width: 150, height: 150)
        tableView.frame = CGRect(x: 0, y: 0, width: view.width, height: view.height)
    }
    
}

extension LibraryAlbumsViewController: ActionLabelDelegate {
    
    func actionLabelViewDidTapButton(_actionView: ActionLabel) {
        tabBarController?.selectedIndex = 0
        
    }
    
}

extension LibraryAlbumsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultSubtitleTableViewCell.idendtfier, for: indexPath) as? SearchResultSubtitleTableViewCell else {return UITableViewCell()}
        
        let _album = album[indexPath.row]
        cell.configure(with: SearchResultSubtitleTableViewCellViewModel(title: _album.name, subtitle: _album.artists.first?.name ?? "-", imageURL: URL(string: _album.images.first?.url ?? "")))
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return album.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let _album = album[indexPath.row]
        let vc = AlbumViewController(album: _album)
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
