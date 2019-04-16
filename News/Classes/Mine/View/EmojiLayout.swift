//
//  EmojiLayout.swift
//  News
//
//  Created by Rion on 2019/4/15.
//  Copyright © 2019年 Rion. All rights reserved.
//

import UIKit

class EmojiLayout: UICollectionViewFlowLayout {
    
    private var columns = 7
    private var rows = 3
    private var attributes = [UICollectionViewLayoutAttributes]()

    override func prepare() {
        super.prepare()
        itemSize = CGSize(width: emojiWidth, height: emojiWidth)
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        scrollDirection = .horizontal
        
        collectionView?.isPagingEnabled = true
        collectionView?.bounces = false
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.showsHorizontalScrollIndicator = false
        
        let margin = ((collectionView?.height)! - 3 * emojiWidth) * 0.5
        collectionView?.contentInset = UIEdgeInsets(top: margin, left: 0, bottom: margin, right: 0)
        
        var page = 0
        let items = collectionView?.numberOfItems(inSection: 0)
        for item in 0..<items! {
            let indexPath = IndexPath(item: item, section: 0)
            let layoutAttributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            page = item / (columns * rows)
            let x = itemSize.width * CGFloat(item % columns) + CGFloat(page) * screenWidth
            let y = itemSize.height * CGFloat((item - page * rows * columns) / columns)
            layoutAttributes.frame = CGRect(x: x, y: y, width: itemSize.width, height: itemSize.height)
            attributes.append(layoutAttributes)
        }
        
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attributes.filter({ rect.contains($0.frame) })
    }
    
}
