//
//  LibraryViewController.swift
//  Spotify
//
//  Created by oktay on 10.06.2023.
//

import UIKit
class LibraryViewController: UIViewController {

    private let playListVC = LibraryPlaylistViewController()
    private let albumsVC = LibraryAlbumsViewController()
    
    
    private let toogleView = LibraryToggleViewController()
    
    private let scrolView: UIScrollView = {
       let scroll = UIScrollView()
        scroll.isPagingEnabled = true
        return scroll
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrolView.delegate = self
        toogleView.delegate = self
        view.backgroundColor = .systemBackground
        view.addSubview(toogleView)
        view.addSubview(scrolView)
        scrolView.contentSize = CGSize(width: view.width * 2, height: scrolView.height )
        addChildren()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrolView.frame = CGRect(x: 0, y: view.safeAreaInsets.top + 55, width: view.width, height: view.height - view.safeAreaInsets.top - view.safeAreaInsets.bottom - 55)
        toogleView.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: 200, height: 55)
    }
    
    private func addChildren() {
        addChild(playListVC)
        scrolView.addSubview(playListVC.view)
        playListVC.view.frame = CGRect(x: 0, y: 0, width: scrolView.width, height: scrolView.height)
        playListVC.didMove(toParent: self)
     
        addChild(albumsVC)
        scrolView.addSubview(albumsVC.view)
        albumsVC.view.frame = CGRect(x: view.width, y: 0, width: scrolView.width, height: scrolView.height)
        albumsVC.didMove(toParent: self)
        
    }

}

extension LibraryViewController: UIScrollViewDelegate, LibraryToggleViewControllerDelegate {
    
    func libraryToggleViewDidTapPlaylists(_ toggleView: LibraryToggleViewController) {
        scrolView.setContentOffset(.zero, animated: true)
    }
    
    func libraryToggleViewDidTapAlbums(_ toggleView: LibraryToggleViewController) {
        scrolView.setContentOffset(CGPoint(x: view.width, y: 0), animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x >= (view.width - 100) {
            toogleView.update(for: .album)
        } else {
            toogleView.update(for: .playlist)
        }
    }
}
