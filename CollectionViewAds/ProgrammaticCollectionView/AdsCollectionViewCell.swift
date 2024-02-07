//
//  AdsCollectionViewCell.swift
//  SwitchProject
//
//  Created by A667459 A667459 on 12/2/2567 BE.
//

import UIKit

class AdsCollectionViewCell: UICollectionViewCell {
    let imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
//        image.layer.masksToBounds = trues
        return image
    }()
    
    override init(frame:CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraint()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        setupConstraint()
    }
    
    override func layoutSubviews(){
        super.layoutSubviews()
        clipsToBounds = false
        contentView.clipsToBounds = false
    }
    
    private func setupView(){
        contentView.backgroundColor = .clear
        contentView.addSubview(imageView)
    }
    
    private func setupConstraint(){
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 0),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: 0),
            imageView.topAnchor.constraint(equalTo: self.topAnchor,constant: 0),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor,constant: 0)
        ])
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func configure(with imagePath: String) {
        imageView.image = UIImage(named: imagePath)
    }
}
