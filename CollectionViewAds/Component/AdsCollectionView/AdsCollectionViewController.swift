//
//  AdsViewController.swift
//  SwitchProject
//
//  Created by A667459 A667459 on 9/2/2567 BE.
//

import UIKit

class AdsViewController: BaseViewController {
    let adsCollectionView : AdsCollectionView!
    
    private var snap: Bool = false
    private let contentAdsID: String = "contentAds"
    private var currentcellIndex = 0
    
    var dataSource = ["ad1","ad2","ad3"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureContentAds()
        setupView()
        setupConstraint()
    }
    
    init() {
        self.adsCollectionView = AdsCollectionView()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.adsCollectionView = AdsCollectionView()
        super.init(coder: aDecoder)
    }
    
    private func setupView() {
        view.addSubview(adsCollectionView)
        adsCollectionView.backgroundColor = .clear
    }
    
    private func setupConstraint() {
        NSLayoutConstraint.activate([
            adsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            adsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            adsCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            adsCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        adsCollectionView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureContentAds() {
        adsCollectionView.clipsToBounds = false
        adsCollectionView.register(AdsCollectionViewCell.self, forCellWithReuseIdentifier: contentAdsID)
    }
}

extension AdsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

extension AdsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return contentAdsCollectionView(collectionView, cellForItemAt: indexPath)
    }
    
    
    private func contentAdsCollectionView(_ collectionView: UICollectionView,
                                          cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = adsCollectionView.dequeueReusableCell(withReuseIdentifier: contentAdsID, for: indexPath) as! AdsCollectionViewCell
        cell.imageView.image = UIImage(named: dataSource[indexPath.row])
        return cell
    }
}

extension AdsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: adsCollectionView.frame.width, height: adsCollectionView.frame.height)
    }
}
