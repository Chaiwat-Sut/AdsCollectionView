//
//  AdsCollectionViewCell.swift
//  SwitchProject
//
//  Created by A667459 A667459 on 9/2/2567 BE.
//

import UIKit

class AdsCollectionViewCell: UICollectionViewCell {
    // MARK: - Views
    let imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 16
        image.layer.masksToBounds = true
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraint()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
        setupConstraint()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        clipsToBounds = false
        contentView.clipsToBounds = false
    }
    
    private func setupView() {
        contentView.backgroundColor = .clear
        contentView.addSubview(imageView)
    }
    
    private func setupConstraint() {
        imageView.anchorToSuperView()
    }
}

