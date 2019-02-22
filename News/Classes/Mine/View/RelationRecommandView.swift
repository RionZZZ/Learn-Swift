//
//  RelationRecommandView.swift
//  News
//
//  Created by Rion on 2019/2/21.
//  Copyright © 2019年 Rion. All rights reserved.
//

import UIKit

class RelationRecommandView: UIView, NibLoadable {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var labelHeight: NSLayoutConstraint!
    
    var userCards = [UserCard]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.collectionViewLayout = RelationRecommandFlowLayout()
        collectionView._registerCell(cell: RelationRecommandCell.self)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        width = screenWidth
//        backgroundColor = UIColor(r: 235, g: 235, b: 235)
    }
}

extension RelationRecommandView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userCards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView._dequeueReusableCell(indexPath: indexPath) as RelationRecommandCell
        cell.userCard = userCards[indexPath.item]
        return cell
    }
    
    
}


class RelationRecommandFlowLayout: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        
        scrollDirection = .horizontal
        itemSize = CGSize(width: 142, height: 190)
        minimumLineSpacing = 10
        sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
}
