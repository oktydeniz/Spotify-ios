//
//  LibraryToggleViewController.swift
//  Spotify
//
//  Created by oktay on 26.07.2023.
//

import UIKit

protocol LibraryToggleViewControllerDelegate: AnyObject {
    func libraryToggleViewDidTapPlaylists(_ toggleView: LibraryToggleViewController)
    func libraryToggleViewDidTapAlbums(_ toggleView: LibraryToggleViewController)
}

class LibraryToggleViewController: UIView {

    enum State {
        case playlist
        case album
    }
    
    weak var delegate: LibraryToggleViewControllerDelegate?
    var state: State = .playlist
    
    private let playListButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.label, for: .normal)
        button.setTitle("Playlist", for: .normal)
        return button
    }()
    
    private let albumButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.label, for: .normal)
        button.setTitle("Albums", for: .normal)
        return button
    }()
    
    private let indicatorView :UIView = {
       let view = UIView()
        view.backgroundColor = .systemGreen
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 4
        return view
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(playListButton)
        addSubview(albumButton)
        addSubview(indicatorView)
        playListButton.addTarget(self, action: #selector(didTabPlaylist), for: .touchUpInside)
        albumButton.addTarget(self, action: #selector(didTabAlbums), for: .touchUpInside)
    }
    
    @objc private func didTabPlaylist() {
        state = .playlist
        UIView.animate(withDuration: 0.3) {
            self.layoutIndicator()
        }
        delegate?.libraryToggleViewDidTapPlaylists(self)
    }
    
    @objc private func didTabAlbums() {
        state = .album
        UIView.animate(withDuration: 0.3) {
            self.layoutIndicator()
        }
        delegate?.libraryToggleViewDidTapAlbums(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playListButton.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        albumButton.frame = CGRect(x: playListButton.right, y: 0, width: 100, height: 40)
        layoutIndicator()
    }
   private func layoutIndicator(){
       switch (state) {
       case .playlist:
           indicatorView.frame = CGRect(x: 0, y: playListButton.bottom, width: 100, height: 3)
       case .album:
           indicatorView.frame = CGRect(x: 100, y: playListButton.bottom, width: 100, height: 3)
       }
    }
    
    func update(for state: State) {
        self.state = state
        UIView.animate(withDuration: 0.3) {
            self.layoutIndicator()
        }
    }
}
