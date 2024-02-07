//
//  NEXTCollectionView.swift
//  SwitchProject
//
//  Created by A667459 A667459 on 11/2/2567 BE.
//

import UIKit

class NEXTCollectionView: UICollectionView {
    override func dequeueReusableCell(withReuseIdentifier identifier: String,
                                      for indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        return cell
    }

}
