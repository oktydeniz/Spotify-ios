//
//  AlbumTrackCollectionViewCell.swift
//  Spotify
//
//  Created by oktay on 9.07.2023.
//

import Foundation
import UIKit

class AlbumTrackCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "AlbumTrackCollectionViewCell"
    
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
        contentView.addSubview(trackNameLabel)
        contentView.addSubview(artistsNameLabel)
        contentView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        trackNameLabel.frame = CGRect(x: 10, y: 0, width: contentView.width - 15, height: contentView.height/2)
        artistsNameLabel.frame = CGRect(x:10, y: contentView.height/2, width: contentView.width - 15, height: contentView.height/2)
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        artistsNameLabel.text = nil
        trackNameLabel.text = nil
    }
    
    func configure(with viewModel: AlbumCollectionViewCellViewModel){
        artistsNameLabel.text = viewModel.artistName
        trackNameLabel.text = viewModel.name
    }
    
    
}
