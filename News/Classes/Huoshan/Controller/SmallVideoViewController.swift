//
//  SamllVideoViewController.swift
//  News
//
//  Created by Rion on 2019/4/19.
//  Copyright © 2019年 Rion. All rights reserved.
//

import UIKit

class SmallVideoViewController: UIViewController {
    
    @IBOutlet weak var titleButton: UIButton!
    @IBOutlet weak var titleTop: NSLayoutConstraint!
    @IBOutlet weak var bottomViewBottom: NSLayoutConstraint!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var diggButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var smallVideos = [NewsModel]()
    var originalIndex = 0
    var currentIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    @IBAction func onCloseClick(_ sender: UIButton) {
        dismiss(animated: false, completion: nil)
    }
    
}

extension SmallVideoViewController {
    
    func setupUI() {
        
        collectionView.collectionViewLayout = SmallVideoLayout()
        collectionView._registerCell(cell: SmallVideoCell.self)
        
        diggButton.setImage(UIImage(named: "hts_vp_like_24x24_"), for: .normal)
        diggButton.setImage(UIImage(named: "hts_vp_like_press_24x24_"), for: .selected)
        bottomViewBottom.constant = safeAreaBottom!
        titleTop.constant = statusBarHeight
        view.layoutIfNeeded()
        
        let smallVideo = smallVideos[originalIndex]
        switch smallVideo.raw_data.group_source {
        case .huoshan:
            titleButton.setTitle("小火山视频", for: .normal)
            titleButton.setImage(UIImage(named: "detail_huoshan_logo_20x25_"), for: .normal)
        case .douyin:
            titleButton.setTitle("抖音短视频", for: .normal)
            titleButton.setImage(UIImage(named: "detail_douyin_logo_20x25_"), for: .normal)
        }
        commentButton.setTitle(smallVideo.raw_data.action.commentCount, for: .normal)
        diggButton.setTitle(smallVideo.raw_data.action.diggCount, for: .normal)
    }
}

class SmallVideoLayout: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        itemSize = CGSize(width: collectionView!.width, height: collectionView!.height)
        scrollDirection = .horizontal
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
    }
}

extension SmallVideoViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return smallVideos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView._dequeueReusableCell(indexPath: indexPath) as SmallVideoCell
        cell.smallVideo = smallVideos[indexPath.item]
        return cell
    }
    
    
}
