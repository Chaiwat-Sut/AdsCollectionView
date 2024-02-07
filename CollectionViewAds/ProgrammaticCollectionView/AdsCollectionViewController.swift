//
//  AdsCollectionViewController.swift
//  SwitchProject
//
//  Created by A667459 A667459 on 12/2/2567 BE.
//

import UIKit

private let reuseIdentifier = "Cell"

class AdsCollectionView: UICollectionView {
    struct Configuration {
        var itemSize: CGSize = .zero
        var spacing: CGFloat = 0
        var sectionInset: UIEdgeInsets = .zero
        var placeholder: UIImage? = nil
    }
    
    var layout: UICollectionViewFlowLayout
    
    var configuration: Configuration? {
        didSet {
            guard let configuration = configuration else {return}
            layout.itemSize = configuration.itemSize
            layout.minimumLineSpacing = configuration.spacing
            layout.sectionInset = configuration.sectionInset
            layout.prepare()
            layout.invalidateLayout()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    init(){
        layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        super.init(frame: .zero, collectionViewLayout: layout)
        self.showsHorizontalScrollIndicator = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.layout = UICollectionViewFlowLayout()
        super.init(coder: aDecoder)
    }
    
    override func dequeueReusableCell(withReuseIdentifier identifier: String, for indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        return cell
    }
}
