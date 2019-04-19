//
//  SamllVideoViewController.swift
//  News
//
//  Created by Rion on 2019/4/19.
//  Copyright © 2019年 Rion. All rights reserved.
//

import UIKit
//import BMPlayer
import SnapKit

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
    
    //播放器
//    private lazy var player = BMPlayer(customControlView: SmallVideoPlayerCustomView())
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupPlayer(currentIndex: originalIndex)
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
        //跳到当前item
        collectionView.scrollToItem(at: IndexPath(item: originalIndex, section: 0), at: .centeredHorizontally, animated: false)
    }
    
    func setupPlayer(currentIndex: Int) {
        let smallVideo = smallVideos[currentIndex]
        if let videoUrl = smallVideo.raw_data.video.play_addr.url_list.first {
            
            let dataTask = URLSession.shared.dataTask(with: URL(string: videoUrl)!) { (data, response, error) in
                DispatchQueue.main.async {
                    let cell = self.collectionView.cellForItem(at: IndexPath(item: currentIndex, section: 0)) as! SmallVideoCell
                    
//                    if self.player.isPlaying { self.player.pause() }
//                    // 先把 bgImageView 的子视图移除，再添加
//                    for subview in cell.bgImageView.subviews { subview.removeFromSuperview() }
//                    cell.bgImageView.addSubview(self.player)
//                    self.player.snp.makeConstraints({ $0.edges.equalTo(cell.bgImageView) })
//                    let asset = BMPlayerResource(url: URL(string: response!.url!.absoluteString)!)
//                    self.player.setVideo(resource: asset)
                }
            }
            
            dataTask.resume()
        }
        
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
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentIndex = Int(scrollView.contentOffset.x / scrollView.width + 0.5)
        setupPlayer(currentIndex: currentIndex)
    }
    
    
}
