//
//  ViewController.swift
//  Spotify
//
//  Created by oktay on 10.06.2023.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .done, target: self, action: #selector(didTabSettings))
        
        fetcData()
    }
    
    private func fetcData() {
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
                    switch(result){
                    case .success(let model):break
                    case.failure(let error):break
                    }
                })
                break
            case .failure(let error):break
            }
        })
    }
    
    @objc func didTabSettings(){
        let vc = SettingsViewController()
        vc.title = "Settings"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }


}

