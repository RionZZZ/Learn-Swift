//
//  DongtaiCollectionView.swift
//  News
//
//  Created by Rion on 2019/3/2.
//  Copyright © 2019年 Rion. All rights reserved.
//

import UIKit

class DongtaiCollectionView: UICollectionView, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource, NibLoadable {
    
    var thumbImageList = [ThumbImage]() {
        didSet {
            reloadData()
        }
    }
    var largeImages = [LargeImage]()
    
    var isPostVideo = false
    
    var isDongtaiDetail = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        delegate = self
        dataSource = self
        _registerCell(cell: DongtaiCollectionCell.self)
        collectionViewLayout = DongtaiCollectionFlowLayout()
        isScrollEnabled = false
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return thumbImageList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView._dequeueReusableCell(indexPath: indexPath) as DongtaiCollectionCell
        cell.thumbImageView.contentMode = .scaleAspectFill
        cell.thumbImage = thumbImageList[indexPath.item]
        cell.isPostVideo = isPostVideo
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return isDongtaiDetail ? Calculate.detailCollectionCellSize(thumbImageList) : Calculate.collectionCellSize(thumbImageList.count)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let previewLargeImage = PreviewLagerImageViewController()
        previewLargeImage.selectedIndex = indexPath.item
        previewLargeImage.images = largeImages
        UIApplication.shared.keyWindow?.rootViewController?.present(previewLargeImage, animated: false, completion: nil)
    }
    
}


class DongtaiCollectionFlowLayout: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        minimumLineSpacing = 5
        minimumInteritemSpacing = 5
    }
}
