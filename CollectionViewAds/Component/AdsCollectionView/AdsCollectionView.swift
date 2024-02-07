//
//  AdsCollectionView.swift
//  SwitchProject
//
//  Created by A667459 A667459 on 9/2/2567 BE.
//

import UIKit

class AdsCollectionView: NEXTCollectionView {
    // MARK: - Model
    struct Configuration {
        var itemSize: CGSize = .zero
        var spacing: CGFloat = 0
        var sectionInset: UIEdgeInsets = .zero
        var placeholder: UIImage? = nil
    }
    
    // MARK: - Layout
    var layout: UICollectionViewFlowLayout
    
    // MARK: - Variables
    var configuration: Configuration? {
        didSet {
            guard let configuration = configuration else { return }
            layout.itemSize = configuration.itemSize
            layout.minimumLineSpacing = configuration.spacing
            layout.sectionInset = configuration.sectionInset
            layout.prepare()
            layout.invalidateLayout()
        }
    }
    
    // MARK: - Cycle
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    // MARK: - Initial
    init() {
        layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        super.init(frame: .zero, collectionViewLayout: layout)
        self.showsHorizontalScrollIndicator = false
        self.backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.layout = UICollectionViewFlowLayout()
        
        super.init(coder: aDecoder)
    }
}
