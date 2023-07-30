//
//  LibraryPlaylistViewController.swift
//  Spotify
//
//  Created by oktay on 26.07.2023.
//

import UIKit

class LibraryPlaylistViewController: UIViewController {
    
    private  var playlist = [PlayList]()
    private let noPlaylisView = ActionLabel()
    public var selectionHandler: ((PlayList) -> Void)?
    
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
        setUpPlaylistView()
        fetchData()
        if selectionHandler != nil {
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapClose))
        }
    }
    
    @objc func didTapClose() {
        dismiss(animated: true, completion: nil)
    }
    
    public func updateUI() {
        if playlist.isEmpty {
            noPlaylisView.isHidden = false
            tableView.isHidden = true
        } else {
            tableView.reloadData()
            noPlaylisView.isHidden = true
            tableView.isHidden = false
        }
    }
    
    private func fetchData() {
        APICaller.shared.getCurrentUserPlaylist { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    self?.playlist = model
                    self?.updateUI()
                case .failure(let error): print(error.localizedDescription)
                }
            }
        }
    }
    
    private func setUpPlaylistView() {
        view.addSubview(noPlaylisView)
        noPlaylisView.delegate = self
        noPlaylisView.configure(with: ActionLabelViewModel(text: "You do not have any playlist yet.", actionTitle: "Create"))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        noPlaylisView.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
        noPlaylisView.center = view.center
        tableView.frame = view.bounds
    }
    
    public func createPlaylistAlert() {
        let alert = UIAlertController(title: "New Playlist", message: "Enter playlist name.", preferredStyle: .alert)
        
        alert.addTextField { textfield in
            textfield.placeholder = "Playlist..."
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Create", style: .default, handler: { _ in
            guard let field = alert.textFields?.first, let text = field.text,
                  !text.trimmingCharacters(in: .whitespaces).isEmpty else {
                      return
                  }
            APICaller.shared.createPlaylist(with: text, completion: { [weak self] success in
                if success {
                    // refresh UI
                    HapticsManager.shared.vibratare(for: .success)
                    self?.fetchData()
                } else {
                    HapticsManager.shared.vibratare(for: .error)
                    print("Failed to create playlist...")
                }
            })
        }))
        present(alert, animated: true)
    }
    
}

extension LibraryPlaylistViewController: ActionLabelDelegate {
    
    func actionLabelViewDidTapButton(_actionView: ActionLabel) {
        createPlaylistAlert()
    }
    
}

extension LibraryPlaylistViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultSubtitleTableViewCell.idendtfier, for: indexPath) as? SearchResultSubtitleTableViewCell else {return UITableViewCell()}
        
        let playlist = playlist[indexPath.row]
        cell.configure(with: SearchResultSubtitleTableViewCellViewModel(title: playlist.name, subtitle: playlist.owner.display_name, imageURL: URL(string: playlist.images.first?.url ?? "")))
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playlist.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        HapticsManager.shared.vibratareForSelection()
        let plist = playlist[indexPath.row]
        guard selectionHandler == nil else  {
            selectionHandler?(plist)
            dismiss(animated: true, completion: nil)
            return
        }
        let vc = PlayListViewController(playlist: plist)
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.isOwner = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
