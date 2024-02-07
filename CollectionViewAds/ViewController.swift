//
//  ViewController.swift
//  SwitchProject

//
//  Created by A667459 A667459 on 6/2/2567 BE.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    @IBOutlet weak var adsCollectionView: UICollectionView!
    @IBOutlet weak var pageView: UIPageControl!
    
    let myData = ["ad1","ad2","ad3"]
    
    var currentCellIndex = 0
    var timer:Timer!
    var lastContentOffsetX: CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAds()
    }
    
    func setupAds(){
        adsCollectionView.showsHorizontalScrollIndicator = false
        adsCollectionView.delegate = self
        adsCollectionView.dataSource = self
        startTimer()
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(slideToNext), userInfo: nil, repeats: true)
    }
    
    @objc func slideToNext(){
        if currentCellIndex < myData.count-1 {
            currentCellIndex = currentCellIndex + 1
        }else {
            currentCellIndex = 0
        }
        pageView.currentPage = currentCellIndex
        adsCollectionView.scrollToItem(at: IndexPath(item:currentCellIndex,section: 0), at: .right, animated: true)
    }

    
    
}

extension ViewController: UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = adsCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? CollectionViewCell  else {return UICollectionViewCell()}
        cell.configure(with: myData[indexPath.row])
        return cell
    }
    
    
    
}

extension ViewController:UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: adsCollectionView.frame.width, height: adsCollectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        timer?.invalidate()
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let targetPoint = targetContentOffset
        let currentPoint = scrollView.contentOffset
        
        if (targetPoint.pointee.x > currentPoint.x) && (currentCellIndex != myData.count - 1) {
            currentCellIndex += 1
        }
        else if (targetPoint.pointee.x < currentPoint.x) && (currentCellIndex != 0) {
            currentCellIndex -= 1
        }
        print(targetPoint.pointee.x)
        print(currentPoint.x)
        print(currentCellIndex)
        pageView.currentPage = currentCellIndex
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        startTimer()
    }
}
