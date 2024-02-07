//
//  ProgrammatcViewController.swift
//  SwitchProject
//
//  Created by A667459 A667459 on 12/2/2567 BE.
//

import UIKit

class ProgrammatcViewController: UIViewController {
    
    @IBOutlet weak var adsView: UIView!
    var items: [String] = ["ad1","ad2","ad3"]
    var adsViewController: AdsViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView() 
    }
    
    func setupCollectionView() {
        adsViewController = AdsViewController()
        adsViewController.view.accessibilityIdentifier = "contentAdsView"
        adsView.addSubview(adsViewController.view)
        
        NSLayoutConstraint.activate([
            adsViewController.view.leadingAnchor.constraint(equalTo: adsView.leadingAnchor),
            adsViewController.view.trailingAnchor.constraint(equalTo: adsView.trailingAnchor),
            adsViewController.view.topAnchor.constraint(equalTo: adsView.topAnchor),
            adsViewController.view.bottomAnchor.constraint(equalTo: adsView.bottomAnchor)
        ])
        
        adsViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        
        adsViewController.dataSource = items
    }

}
