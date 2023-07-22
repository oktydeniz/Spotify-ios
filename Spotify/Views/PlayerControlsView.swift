//
//  PlayerControlsView.swift
//  Spotify
//
//  Created by oktay on 22.07.2023.
//

import Foundation
import UIKit

protocol PlayerControlsViewDelegate: AnyObject {
    func playerControlsViewDidTapPlayPauseButton(_ playerControlsView: PlayerControlsView)
    func playerControlsViewDidTapForwardButton(_ playerControlsView: PlayerControlsView)
    func playerControlsViewDidTapBackwardButton(_ playerControlsView: PlayerControlsView)
}

final class PlayerControlsView: UIView {
    
    weak var delegate: PlayerControlsViewDelegate?
    
    private let volumeSlider : UISlider = {
        let slider = UISlider()
        slider.value = 0.5
        return slider
    }()
    
    private let nameLable: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()

    private let backButton: UIButton = {
        let backButton = UIButton()
        backButton.tintColor = .label
        let img = UIImage(systemName: "backward.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .regular))
        backButton.setImage(img, for: .normal)
        return backButton
    }()
    
    private let nextButton: UIButton = {
        let nextButton = UIButton()
        nextButton.tintColor = .label
        let img = UIImage(systemName: "forward.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .regular))
        nextButton.setImage(img, for: .normal)
        return nextButton
    }()
    
    private let playPauseButton: UIButton = {
        let playPauseButton = UIButton()
        playPauseButton.tintColor = .label
        let img = UIImage(systemName: "pause.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .regular))
        playPauseButton.setImage(img, for: .normal)
        return playPauseButton
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        
        addSubview(nameLable)
        addSubview(subtitleLabel)
        addSubview(volumeSlider)
        addSubview(backButton)
        addSubview(nextButton)
        addSubview(playPauseButton)
        
        backButton.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(didTapNext), for: .touchUpInside)
        playPauseButton.addTarget(self, action: #selector(didTapPlayPause), for: .touchUpInside)
        
        clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        nameLable.frame = CGRect(x: 0, y: 0, width: width, height: 50)
        subtitleLabel.frame = CGRect(x: 0, y: nameLable.bottom + 10, width: width, height: 50)
        volumeSlider.frame = CGRect(x: 10, y: subtitleLabel.bottom + 20, width: width - 20, height: 44)

        let btnSize: CGFloat = 60
        playPauseButton.frame = CGRect(x: (width - btnSize)/2, y: volumeSlider.bottom + 30, width: btnSize, height: btnSize)
        
        backButton.frame = CGRect(x: playPauseButton.left - 80 - btnSize, y: playPauseButton.top, width: btnSize, height: btnSize)
        nextButton.frame = CGRect(x: playPauseButton.right + 80, y: playPauseButton.top, width: btnSize, height: btnSize)
        
    }
    
    @objc private func didTapBack() {
        delegate?.playerControlsViewDidTapBackwardButton(self)
    }
    
    @objc private func didTapNext() {
        delegate?.playerControlsViewDidTapForwardButton(self)
    }
    
    @objc private func didTapPlayPause() {
        delegate?.playerControlsViewDidTapPlayPauseButton(self)
    }
    
}
