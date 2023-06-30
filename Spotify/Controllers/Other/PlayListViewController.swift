//
//  PlayListViewController.swift
//  Spotify
//
//  Created by oktay on 10.06.2023.
//

import UIKit

class PlayListViewController: UIViewController {
        private let playlist: PlayList
        
        init(playlist:PlayList) {
            self.playlist = playlist
            super.init(nibName: nil, bundle: nil)
        }

        override func viewDidLoad() {
            super.viewDidLoad()
            title = playlist.name
            view.backgroundColor = .secondarySystemBackground
            
            APICaller.shared.getPlaylistDetails(for: playlist) { result in 
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
