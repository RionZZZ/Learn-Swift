//
//  HuoshanCategoryController.swift
//  News
//
//  Created by Rion on 2019/4/18.
//  Copyright © 2019年 Rion. All rights reserved.
//

import UIKit

class HuoshanCategoryController: UIViewController {

    var category = HomeNewsTitleModel()
    var maxBehotTime: TimeInterval = 0
    var smallVideos = [NewsModel]()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView._registerCell(cell: HuoshanCell.self)
        collectionView.collectionViewLayout = HuoshanLayout()
        
        Network.loadApiNewsFeeds(category: category.category, ttForm: .enterAuto) { (maxBehotTime, videos) in
            self.smallVideos = videos
            self.maxBehotTime = maxBehotTime
            self.collectionView.reloadData()
        }
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
