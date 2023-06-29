//
//  RecommendedTrackCollectionViewCell.swift
//  Spotify
//
//  Created by oktay on 24.06.2023.
//

import UIKit

class RecommendedTrackCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "RecommendedTrackCollectionViewCell"
    
    private let albumCoverImgView: UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 2
        return imageView
    }()
    
    
    private let trackNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    
    private let artistsNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .thin)
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        backgroundColor = .secondarySystemBackground
        contentView.addSubview(albumCoverImgView)
        contentView.addSubview(trackNameLabel)
        contentView.addSubview(artistsNameLabel)
        contentView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        albumCoverImgView.frame = CGRect(x: 5, y: 2, width: contentView.height - 4, height: contentView.height - 4)
        trackNameLabel.frame = CGRect(x: albumCoverImgView.right + 10, y: 0, width: contentView.width - albumCoverImgView.right - 15, height: contentView.height/2)
        artistsNameLabel.frame = CGRect(x: albumCoverImgView.right + 10, y: contentView.height/2, width: contentView.width - albumCoverImgView.right - 15, height: contentView.height/2)
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        artistsNameLabel.text = nil
        trackNameLabel.text = nil
        albumCoverImgView.image = nil
    }
    
    func configure(with viewModel: RecomendedTrackCellVİewModel){
        artistsNameLabel.text = viewModel.artistName
        trackNameLabel.text = viewModel.name
        albumCoverImgView.sd_setImage(with: viewModel.artworkURL, completed: nil)
    }
    
    
}
