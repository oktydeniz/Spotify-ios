//
//  PlaylistHeaderCollectionReusableView.swift
//  Spotify
//
//  Created by oktay on 1.07.2023.
//

import UIKit

protocol PlaylistHeaderCollectionReusableViewDelegate: AnyObject {
    func playlistHeaderCollectionReusableViewDidTapPlayAll(_ header: PlaylistHeaderCollectionReusableView)
}

final class PlaylistHeaderCollectionReusableView: UICollectionReusableView {
    static let identifier = "PlaylistHeaderCollectionReusableView"
    weak var delegate: PlaylistHeaderCollectionReusableViewDelegate?
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        return label
    }()
    
    private let desctiptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.numberOfLines = 0
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let ownerLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    
    private let imageView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFill
        imgView.image = UIImage(systemName: "photo")
        return imgView
    }()
    
    private let playAllButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGreen
        button.tintColor = .white
        let image = UIImage(systemName: "play.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .regular))
        button.setImage(image, for: .normal)
        button.layer.cornerRadius = 30
        button.layer.masksToBounds = true
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .secondarySystemBackground
        addSubview(imageView)
        addSubview(nameLabel)
        addSubview(desctiptionLabel)
        addSubview(ownerLabel)
        addSubview(playAllButton)
        playAllButton.addTarget(self, action: #selector(didTapPlayAll), for: .touchUpInside)
    }
    
    @objc private func didTapPlayAll () {
        self.delegate?.playlistHeaderCollectionReusableViewDidTapPlayAll(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let imgSize: CGFloat = height/1.8
        imageView.frame = CGRect(x: (width - imgSize) / 2, y: 20, width: imgSize, height: imgSize)
        
        nameLabel.frame = CGRect(x: 10, y: imageView.bottom, width: width-20, height: 44)
        desctiptionLabel.frame = CGRect(x: 10, y: nameLabel.bottom, width: width-20, height: 44)
        ownerLabel.frame = CGRect(x: 10, y: desctiptionLabel.bottom, width: width-20, height: 44)
        playAllButton.frame = CGRect(x: width - 80, y: height - 80, width: 60, height: 60)
    }
    
    func configure(with viewModel: PlaylistHeaderViewModel) {
        nameLabel.text = viewModel.name
        desctiptionLabel.text = viewModel.desctiption
        ownerLabel.text = viewModel.ownerName
        imageView.sd_setImage(with: viewModel.artworkURL, completed: nil)
        
    }
    
}
