//
//  RefreshView.swift
//  
//
//  Created by Rion on 2019/3/12.
//

import MJRefresh

class RefreshFooter: MJRefreshAutoGifFooter {
    
    override func prepare() {
        super.prepare()
        //设置控件的高度
        mj_h = 50
        //遍历
        var images = [UIImage]()
        for index in 0..<8 {
            let image = UIImage(named: "sendloading_18x18_\(index)")
            images.append(image!)
        }
        //设置空闲状态的image数组
        setImages(images, for: .idle)
        //设置刷新状态的image数组
        setImages(images, for: .refreshing)
        setTitle("正在加载", for: .idle)
        setTitle("正在加载", for: .refreshing)
        setTitle("正在加载", for: .pulling)
        setTitle("没有更多数据了", for: .noMoreData)
    }
    
    override func placeSubviews() {
        super.placeSubviews()
        gifView.x = 135
        gifView.centerY = stateLabel.centerY
    }
    
    
}

class RefreshHeader: MJRefreshGifHeader {
    
    override func prepare() {
        super.prepare()
        //遍历
        var images = [UIImage]()
        for index in 0..<16 {
            let image = UIImage(named: "dropdown_loading_0\(index)")
            images.append(image!)
        }
        //设置空闲状态的image数组
        setImages(images, for: .idle)
        //设置刷新状态的image数组
        setImages(images, for: .refreshing)
        setTitle("下拉推荐", for: .idle)
        setTitle("松开推荐", for: .pulling)
        setTitle("推荐中", for: .refreshing)
    }
    
    override func placeSubviews() {
        super.placeSubviews()
        gifView.contentMode = .center
        gifView.frame = CGRect(x: 0, y: 4, width: mj_w, height: 25)
        stateLabel.font = UIFont.systemFont(ofSize: 12)
        stateLabel.frame = CGRect(x: 0, y: 25, width: mj_w, height: 14)
    }
    
}
