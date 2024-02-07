//
//  CollectionViewCell.swift
//  SwitchProject
//
//  Created by A667459 A667459 on 12/2/2567 BE.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var imageView: UIImageView!
    
    func configure(with imagePath: String) {
        imageView.image = UIImage(named: imagePath)
        imageView.contentMode = .scaleToFill
    }
}
