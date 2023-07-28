//
//  ActionLabel.swift
//  Spotify
//
//  Created by oktay on 28.07.2023.
//

import UIKit

struct ActionLabelViewModel {
    let text: String
    let actionTitle: String
}

protocol ActionLabelDelegate: AnyObject {
    func actionLabelViewDidTapButton(_actionView: ActionLabel)
}

class ActionLabel: UIView {
    
    weak var delegate: ActionLabelDelegate?
    
    private let label: UILabel = {
       let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let button: UIButton = {
       let button = UIButton()
        button.setTitleColor(.link, for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        isHidden = true
        addSubview(button)
        addSubview(label)
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        button.frame = CGRect(x: 0, y: height - 40, width: width, height: 40)
        label.frame = CGRect(x: 0, y: 0, width: width, height: height - 45)
    }
    
    @objc func didTapButton() {
        delegate?.actionLabelViewDidTapButton(_actionView: self)
    }
    
    func configure(with viewModel: ActionLabelViewModel) {
        label.text = viewModel.text
        button.setTitle(viewModel.actionTitle, for: .normal)
    }
}
