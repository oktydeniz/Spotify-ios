//
//  AlbumViewController.swift
//  Spotify
//
//  Created by oktay on 30.06.2023.
//

import UIKit

class AlbumViewController: UIViewController {
    
    private let album: Album
    
    init(album:Album) {
        self.album = album
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = album.name
        view.backgroundColor = .secondarySystemBackground
        
        APICaller.shared.getAlbumsDetails(for: album) { result in
            DispatchQueue.main.async {
                switch (result) {
                case .success(let model):
                    break
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

}
