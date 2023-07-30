//
//  WelcomeViewController.swift
//  Spotify
//
//  Created by oktay on 10.06.2023.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    private let signInButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("Sign in with Spotify", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "welcome_bg")
        return imageView
    }()
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "AppIcon")
        return imageView
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 32, weight: .semibold)
        label.text = "Listen to Millions\nof Songs on\nthe go."
        return label
    }()
    
    private let overlayView: UIView = {
       let view = UIView()
        view.alpha = 0.7
        view.backgroundColor = .black
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Spotify"
        view.addSubview(imageView)
        view.addSubview(overlayView)
        view.addSubview(signInButton)
        signInButton.addTarget(self, action:#selector(didTabSignIn), for: .touchUpInside)
        view.addSubview(label)
        view.addSubview(logoImageView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageView.frame = view.bounds
        overlayView.frame = view.bounds
        signInButton.frame = CGRect(x: 20,
                                    y: view.height-50-view.safeAreaInsets.bottom,
                                    width: view.width-40,
                                    height: 50)
        
        logoImageView.frame = CGRect(x: (view.width - 120)/2 , y: (view.height - 350) / 2 , width: 120, height: 120)
        label.frame = CGRect(x: 30, y: logoImageView.bottom + 30, width: view.width - 60, height: 150)
    }
    
    @objc func didTabSignIn(){
        let vc = AuthViewController()
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.completionHandler = { success in
            DispatchQueue.main.async {
                self.handleSingIn(success: success)
            }
            
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func handleSingIn(success:Bool) {
        guard success else {
            let alert = UIAlertController(title: "Oops", message: "Something went wrong when signing in.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            present(alert, animated: true)
            return
        }
        let mainAppTabBarVC = TabBarViewController()
        mainAppTabBarVC.modalPresentationStyle = .fullScreen
        present(mainAppTabBarVC, animated: true)
    }

}
