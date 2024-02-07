//
//  CollectionViewCell.swift
//  SwitchProject
//
//  Created by A667459 A667459 on 12/2/2567 BE.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var adsImage: UIImageView!

    func configure(with adPath: String) {
        adsImage.image = UIImage(named: adPath)
    }
}
