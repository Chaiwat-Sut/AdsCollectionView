//
//  AdsViewController.swift
//  SwitchProject
//
//  Created by A667459 A667459 on 12/2/2567 BE.
//

import UIKit

class AdsViewController: UIViewController {
    let contentAdsCollectionView: AdsCollectionView
    private let contentAdsID: String = "contentAds"
    

    override func viewDidLoad() {
        super.viewDidLoad()
//        view.backgroundColor = .blacks
        configureContentAds()
        setupConstraint()
    }
    
    var dataSource: [String] = []
    
    init() {
        self.contentAdsCollectionView = AdsCollectionView()
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        self.contentAdsCollectionView = AdsCollectionView()
        super.init(coder: coder)
    }
    
    private func configureContentAds(){
        contentAdsCollectionView.clipsToBounds = false
        contentAdsCollectionView.isPagingEnabled = true
        contentAdsCollectionView.dataSource = self
        contentAdsCollectionView.delegate = self
        contentAdsCollectionView.register(AdsCollectionViewCell.self,forCellWithReuseIdentifier: contentAdsID)
    }
    
    private func setupConstraint(){
        view.addSubview(contentAdsCollectionView)
        NSLayoutConstraint.activate([
            contentAdsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentAdsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentAdsCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            contentAdsCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        contentAdsCollectionView.translatesAutoresizingMaskIntoConstraints = false
    }
}

extension AdsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: contentAdsID, for: indexPath) as? AdsCollectionViewCell else {return UICollectionViewCell()}
        cell.configure(with: dataSource[indexPath.row])
        return cell
    }
}

extension AdsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
