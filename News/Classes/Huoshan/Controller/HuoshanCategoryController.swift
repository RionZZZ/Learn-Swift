//
//  HuoshanCategoryController.swift
//  News
//
//  Created by Rion on 2019/4/18.
//  Copyright © 2019年 Rion. All rights reserved.
//

import UIKit
import SVProgressHUD

class HuoshanCategoryController: UIViewController {

    var category = HomeNewsTitleModel()
    var maxBehotTime: TimeInterval = 0
    var smallVideos = [NewsModel]()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SVProgressHUD.configuration()
        
        collectionView._registerCell(cell: HuoshanCell.self)
        collectionView.collectionViewLayout = HuoshanLayout()
        
//        Network.loadApiNewsFeeds(category: category.category, ttForm: .enterAuto) { (maxBehotTime, videos) in
//            self.smallVideos = videos
//            self.maxBehotTime = maxBehotTime
//            self.collectionView.reloadData()
//        }
        
        setRefresh()
    }
    
    
    func setRefresh() {
        
        let header = RefreshHeader { [weak self] in
            
            Network.loadApiNewsFeeds(category: self!.category.category, ttForm: .enterAuto) { (maxBehotTime, videos) in
                
                if (self!.collectionView.mj_header.isRefreshing) {
                    self!.collectionView.mj_header.endRefreshing()
                }
                self!.smallVideos = videos
                self!.maxBehotTime = maxBehotTime
                self!.collectionView.reloadData()
            }
        }
        header?.isAutomaticallyChangeAlpha = true
        header?.lastUpdatedTimeLabel.isHidden = true
        header?.beginRefreshing()
        collectionView.mj_header = header
        
        collectionView.mj_footer = RefreshFooter(refreshingBlock: { [weak self] in
            
            Network.loadMoreApiNewsFeeds(category: self!.category.category, ttForm: .enterAuto, maxBehotTime: self!.maxBehotTime, listConut: self!.smallVideos.count, completionHandler: { (videos) in
                
                if (self!.collectionView.mj_footer.isRefreshing) {
                    self!.collectionView.mj_footer.endRefreshing()
                }
                self!.collectionView.mj_footer.pullingPercent = 0.8
                if videos.count == 0 {
                    SVProgressHUD.showInfo(withStatus: "没有更多数据啦！")
                    return
                }
                
                self!.smallVideos += videos
                self!.collectionView.reloadData()
            })
            
        })
        collectionView.mj_footer.isAutomaticallyChangeAlpha = true
        
    }
    
}

extension HuoshanCategoryController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return smallVideos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView._dequeueReusableCell(indexPath: indexPath) as HuoshanCell
        cell.smallVideo = smallVideos[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let videoVC = SmallVideoViewController()
        videoVC.originalIndex = indexPath.item
        videoVC.smallVideos = smallVideos
        present(videoVC, animated: false, completion: nil)
    }
    
}


class HuoshanLayout: UICollectionViewFlowLayout {
    
    override func prepare() {
        super.prepare()
        let itemWidth = (screenWidth - 2) / 2
        let itemHeight = itemWidth * 1.5
        itemSize = CGSize(width: itemWidth, height: itemHeight)
        scrollDirection = .vertical
        minimumLineSpacing = 1
        minimumInteritemSpacing = 1
    }
}
